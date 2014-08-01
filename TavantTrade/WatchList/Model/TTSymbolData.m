//
//  TTSymbolData.m
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTSymbolData.h"

@implementation TTSymbolData
@synthesize symbolName,exchange,subscriptionKey,companyName,jsonRawDictionary,tradeSymbolName,series,expiryDate,optionType,strikePrice;

-(id)initWithDictionary:(id)symbolDictionary{
    self = [super init];
    if(self){
        self.companyName = symbolDictionary[@"name"];
        self.subscriptionKey = [NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",symbolDictionary[@"subscriptionKey"]];
        self.exchange = symbolDictionary[@"exchange"];
        self.symbolName = symbolDictionary[@"sorSymbol"];
        self.tradeSymbolName = symbolDictionary[@"tradeSymbol"];
        self.expiryDate = symbolDictionary[@"expiryDate"];
        self.optionType = symbolDictionary[@"optionType"];
        self.strikePrice = symbolDictionary[@"strikePrice"];
        self.instrumentType = symbolDictionary[@"instrumentType"];
        //get the series by accessing the last two characters from the tradesymbol...
        NSLog(@"Self.series %@",self.tradeSymbolName);
        self.series = [self.tradeSymbolName substringFromIndex: [self.tradeSymbolName length] - 2];
        NSLog(@"Passed");
        
        return self;
    }
    return nil;
}

@end
