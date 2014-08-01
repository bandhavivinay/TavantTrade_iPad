//
//  TTDiffusionHandler.m
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTDiffusionHandler.h"
#import "SBITradingUtility.h"
#import "DFBaseConnectionProperties.h"

@implementation TTDiffusionHandler

static DFConnectionDetails *connectionDetails;
static NSString *diffHost;
static int diffPort;
static TTDiffusionHandler *sharedDiffusionManager = nil;
static DFClient *diffClient = nil;
static NSMutableArray *viewsArray;
static NSMutableArray *subscibingSymbolsArray;
static BOOL isCalledAfterRconnection = NO;

@synthesize symbolControllerMapping;

+ (id)sharedDiffusionManager;
{
    if(!sharedDiffusionManager)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedDiffusionManager = [[super allocWithZone:nil] init];
            diffClient = [[DFClient alloc] init];
            viewsArray = [[NSMutableArray alloc] init];
            subscibingSymbolsArray = [[NSMutableArray alloc] init];
        });
    }
    
    return sharedDiffusionManager;
}


-(void)initDiffusion{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	diffHost = [defs stringForKey:@"hostname"];
	if( !diffHost ) diffHost = @"10.129.133.50";
    
	diffPort = [[defs stringForKey:@"port"] intValue];
	if( !diffPort ) diffPort = 80;
    
    DFBaseConnectionProperties *connectionProperty = [[DFBaseConnectionProperties alloc]init];
    connectionProperty.timeout = [NSNumber numberWithInt:30.0];
    
    NSURL *diffURL = [NSURL URLWithString:[NSString stringWithFormat:@"dpt://%@:%d", diffHost, diffPort]];
    
    //Create DFCredential object...
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[SBITradingUtility plistFilePath]];
    
    DFCredentials *diffCredential = [[DFCredentials alloc] initWithUsernameAndPassword:[dictionary objectForKey:@"userName"] password:[dictionary objectForKey:@"password"]];
    
	connectionDetails = [[DFConnectionDetails alloc] initWithServer:[[DFServerDetails alloc] initWithURL:diffURL]
															 topics:nil
													 andCredentials:diffCredential];
    
    symbolControllerMapping = [[NSMutableDictionary alloc] init];
	diffClient.connectionDetails = connectionDetails;
	diffClient.delegate = self;
    
    NSArray* arraycopy = [viewsArray copy];
    for(id context in arraycopy){
        [context onConnectionWithStatus:NO];
        //remove the context from the array to avoid duplicate message sending for successful connection...
        [viewsArray removeObject:context];
    }
}

-(void)connectWithViewControllerContext:(id)context{
    
    if([viewsArray count] == 0){
        [diffClient connect];
    }
    NSLog( @"Connecting to Diffusion: %@", diffClient.connectionDetails);
    
    
    if(![viewsArray containsObject:context]){
        //add the view object to the array...
        [viewsArray addObject:context];
    }
}

-(void)disconnect{
    NSLog( @"Disconnecting" );
    [diffClient close];
}

-(void)subscribe:(NSString *)symbol withContext:(id)context{
    NSString *subscribeSymbol = symbol;
    NSLog(@"Key to be subscribed is %@",subscribeSymbol);
    if(![subscibingSymbolsArray containsObject:symbol]){
        
        //add the symbol in the array of subsciption keys...
        [subscibingSymbolsArray addObject:symbol];
        
        if(diffClient.isConnected){
            NSLog(@"Subscribing... %@",subscribeSymbol);
            [diffClient subscribe:subscribeSymbol];
        }
        else{
            NSLog(@"No active connection exists");
            [self reconnectDiffusion];
        }
        
    }
    else{
        NSLog(@"The key is already subscribed and added in the array");
    }
    
    if([symbolControllerMapping valueForKey:subscribeSymbol] != nil){
        //the symbol is already subscribed by some other controller...
        NSMutableArray *controllerList = [symbolControllerMapping valueForKey:subscribeSymbol];
        if(![controllerList containsObject:context]){
            [controllerList addObject:context];
            [symbolControllerMapping setValue:controllerList forKey:subscribeSymbol];
        }

    }
    else{
        //create a new entry in the data source...
        [symbolControllerMapping setValue:[[NSMutableArray alloc] initWithObjects:context, nil] forKey:subscribeSymbol];
    
    }
    
    
}

-(void)unsubscribe:(NSString *)symbol withContext:(id)context{
    
    //update the data source accordingly...
    
     if([symbolControllerMapping valueForKey:symbol] != nil){
         
         NSMutableArray *controllerList = [symbolControllerMapping valueForKey:symbol];
         if([controllerList containsObject:context]){
             [controllerList removeObject:context];
             [symbolControllerMapping setValue:controllerList forKey:symbol];
             if([controllerList count] == 0){
                 [subscibingSymbolsArray removeObject:symbol];
                 [diffClient unsubscribe:symbol];
             }
         }

     }
    
}

-(void)reconnectDiffusion{
    isCalledAfterRconnection = YES;
    [diffClient reconnect];
}

#pragma mark -
#pragma mark DiffusionDelegate methods

- (void) onConnection:(BOOL) isConnected
{
	NSLog( @"%@ to %@", isConnected?@"Connected":@"Not connected", diffClient.connectionDetails );
	if( !isConnected )
	{
		NSString *errMesg = [NSString stringWithFormat:@"Connection to %@ failed", diffClient.connectionDetails ];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection failure" message:errMesg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		//[alert show];
	}
    
    if(isConnected && isCalledAfterRconnection){
        //resubscribe all the keys...
        for(NSString *symbol in subscibingSymbolsArray){
            [diffClient subscribe:symbol];
        }
        
    }
    
    NSArray* arraycopy = [viewsArray copy];
    for(id context in arraycopy){
        [context onConnectionWithStatus:isConnected];
        //remove the context from the array to avoid duplicate message sending for successful connection...
        [viewsArray removeObject:context];
    }
    

}

- (void) onLostConnection
{
	NSLog( @"Lost connection to %@", diffClient.connectionDetails);
    [self reconnectDiffusion];
    
}

- (void) onAbort

{
	NSLog( @"Connection to %@ was closed by the server", diffClient.connectionDetails );
}

- (void) onMessage:(DFTopicMessage *) message
{
   // NSLog( @"topic: \"%@\" message:\"%@\"", message.topic,message);
    NSMutableArray *controllerList = [symbolControllerMapping valueForKey:message.topic];
    //NSLog(@"controllerList %@",controllerList);
    for(id controller in controllerList){
        if(controller && [controller respondsToSelector:@selector(onDelta:)]){
            [controller onDelta:message];
        }
    }
}


/**
 * This method will be called on receipt of the ping request
 * @see DiffusionClient
 * @param message PingMessage
 */
- (void) onPing:(DFPingMessage *) message
{
}

/**
 * This method will be called after a send credentials message, and the server rejected the credentials
 * @see DiffusionClient
 */
- (void) onServerRejectedConnection
{
	NSLog( @"Connection to %@ was rejected", diffClient.connectionDetails );
    
	NSString *errMesg = [NSString stringWithFormat:@"Connection to %@ was rejected", diffClient.connectionDetails ];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection failure" message:errMesg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

/**
 * This method will be called if the server didn't respond to an Ack Message in time
 * @see TopicMessage
 */
- (void) onMessageNotAcknowledged:(DFTopicMessage *) message
{
	NSLog( @"Message not acknowledged: %@", message );
}

/**
 The given DFServerDetails object has been selected for connection
 */
-(void)onConnectionDetailsAcquired:(DFServerDetails*)details
{
	NSLog( @"Connecting to %@", details );
}

/**
 The list of DFServerDetails object has been exhausted, and no connect can be placed
 */
-(void)onConnectionSequenceExhausted:(DFClient *)client
{
	NSLog( @"Exhausted connection options" );
}

-(void)serviceResponse:(DFServiceTopicResponse *)responseDetails{
    NSLog(@"Response recieved is %@",responseDetails);
}

-(void)serviceError:(DFServiceTopicError *)errorDetails{
    NSLog(@"Service Error");
}


@end
