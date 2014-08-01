//
//  TTTradePreviewController.m
//  TavantTrade
//
//  Created by TAVANT on 1/23/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTTradePreviewController.h"
#import "TTDiffusionHandler.h"
#import "SBITradingUtility.h"
#import "TTDiffusionData.h"
#import "TTSymbolDetails.h"
#import "SBITradingNetworkManager.h"
#import "TTUrl.h"

@interface TTTradePreviewController ()
@end

@implementation TTTradePreviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    
    if(self.subscriptionKey){
        self.diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
        [ self.diffusionHandler subscribe:self.subscriptionKey withContext:self];
    }
    [self initialUIUpdate];
    
    _symbolLabel.font = SEMI_BOLD_FONT_SIZE(16.0);
    _companyLabel.font = SEMI_BOLD_FONT_SIZE(18.0);
    
    _lastLabel.font = _percentageChangeLabel.font = _tradeVolumeLabel.font = _transactionType.font = _exchange.font = _optionType.font = REGULAR_FONT_SIZE(15.0);
    
    _lastValue.font = _changeLabel.font = _volumeLabel.font = REGULAR_FONT_SIZE(13.0);
    
    _orderTypeLabel.font = _qtyLabel.font = _tradeValidityLabel.font = _prodTypeLabel.font = _disclosedQtyLabel.font = _disclosedQtyValue.font = _productTypeLabel.font = _validityLabel.font = _qtyValue.font = _orderTypeQty.font = REGULAR_FONT_SIZE(16.0);
    
    _confirmButton.titleLabel.font = _backButton.titleLabel.font = SEMI_BOLD_FONT_SIZE(15.0);
    _previewLabel.font = SEMI_BOLD_FONT_SIZE(22.0);
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    _previewLabel.text=NSLocalizedStringFromTable(@"Trade_Preview", @"Localizable", @"Trade Preview");
    _percentageChangeLabel.text=NSLocalizedStringFromTable(@"Change", @"Localizable", @"Change");
    _lastLabel.text=NSLocalizedStringFromTable(@"Last", @"Localizable", @"Last");
    _tradeVolumeLabel.text=NSLocalizedStringFromTable(@"Volume", @"Localizable", @"Volume");
    _qtyLabel.text=NSLocalizedStringFromTable(@"Qty", @"Localizable", @"Quantity");
    _orderTypeLabel.text=NSLocalizedStringFromTable(@"Order_Type", @"Localizable", @"Order Type");
    _disclosedQtyLabel.text=NSLocalizedStringFromTable(@"Dis_Qty", @"Localizable", @"Quantity");
    _tradeValidityLabel.text=NSLocalizedStringFromTable(@"Validity", @"Localizable", @"Validity");
    _prodTypeLabel.text=NSLocalizedStringFromTable(@"Product_Type", @"Localizable", @"Product Type");
    [_confirmButton setTitle:NSLocalizedStringFromTable(@"Confirm_Button_Title", @"Localizable", @"Confirm") forState:UIControlStateNormal];
    [_backButton setTitle:NSLocalizedStringFromTable(@"Trade_Title", @"Localizable", @"Trade") forState:UIControlStateNormal];
   
}

// updating UI taking the values from trade screen
-(void)initialUIUpdate{
  
    self.symbolLabel.text=self.symbolData.tradeSymbolName;
    self.companyLabel.text=self.company;
    self.qtyValue.text=self.qty;
    self.orderTypeQty.text=self.orderType;
    self.validityLabel.text=self.validity;
    self.productTypeLabel.text=self.prodType;
    self.disclosedQtyValue.text=self.disQty;
    self.transactionType.text=self.tradeType;
    self.exchange.text=self.symbolDetails.symbolData.exchange;
    //self.optionType.text=self.symbolDetails.symbolData.symbolData.optionType;
    // hardcoding for time bring
    self.optionType.text=@"Equity";
}

-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
    diffusionData = [diffusionData updateDiffusionDataWith:parsedArray];
//    if([diffusionData.symbolData.subscriptionKey isEqualToString: @"REPORTS/TEST/EXRS"]){
//        
//    }
    [self updateUI:diffusionData];
}

-(void)updateUI:(TTDiffusionData *) diffusionData{
    float priceChange = diffusionData.lastSalePrice-diffusionData.closingPrice;
    if([diffusionData.netPriceChangeIndicator isEqualToString:@""])
        diffusionData.netPriceChangeIndicator = GET_SIGN_INDICATOR(priceChange);
    float percentage = 0.00;
    if(diffusionData.closingPrice != 0)
        percentage = (fabsf(priceChange)/diffusionData.closingPrice)*100;
    if(isnan(percentage)){
        percentage = 0.00;
    }
    self.changeLabel.text = [NSString stringWithFormat:@"%@%.02f(%@%.02f%%)",diffusionData.netPriceChangeIndicator,fabsf(priceChange),diffusionData.netPriceChangeIndicator,percentage];
    self.volumeLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.volume] ;
    self.lastValue.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
    //self.changeLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.netPriceChange];
   
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closePreview:(id)sender {
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)confirmTrade:(id)sender {
    [self  showAlert: NSLocalizedStringFromTable(@"Trade_Confirm", @"Localizable",@"Would you like to confirm the trade?") :1];
   }

-(void) showAlert: (NSString *) message : (int) tag{
    
    if(tag==1){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Confirmation_Title", @"Localizable", @"Confirmation")
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Cancel",nil];
    [alert show];
    alert.tag=tag;
    }
    else{
        
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"TradeStatus_Title", @"Localizable", @" Trade status")
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert1 show];
        alert1.tag=tag;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1){
    switch(buttonIndex){
        case 0:{[self placeTrade];
                break;
        }
        case 1 :{ break;
        }
    }
    }
}

// placing the trade with details given
-(void)placeTrade{
    
    if(self.isModifyMode){
        SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
        NSString *relativePath = [TTUrl modifyOrderURL];
        NSMutableDictionary *postBodyDictionary=[self createTradeData];
        
        [postBodyDictionary setValue:self.currentSelectedOrder.orderID forKey:@"nestOrdNumber"];
        [postBodyDictionary setValue:@"" forKey:@"exchAlgoId"];
        [postBodyDictionary setValue:@"" forKey:@"exchAlgoSeqNum"];
        [postBodyDictionary setValue:@"" forKey:@"origClOrdID"];
        
        
//        NSMutableDictionary *postBodyDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:,@"nestOrdNumber",@"TEST",@"clientID",@"",@"exchAlgoId",@"",@"exchAlgoSeqNum",@"",@"origClOrdID", nil];
        
        if([self.currentSelectedOrder.isAmo caseInsensitiveCompare:@"true"] == NSOrderedSame){
            [postBodyDictionary setValue:self.currentSelectedOrder.status forKey:@"status"];
        }
        [postBodyDictionary setValue:self.currentSelectedOrder.isAmo forKey:@"amo"];
        
        if([self.currentSelectedOrder.priceType caseInsensitiveCompare:@"Limit"] == NSOrderedSame){
            [postBodyDictionary setValue:[NSNumber numberWithDouble:self.currentSelectedOrder.priceToFill] forKey:@"price"];
        }
        else if ([self.currentSelectedOrder.priceType caseInsensitiveCompare:@"stoploss"] == NSOrderedSame){
            [postBodyDictionary setValue:[NSNumber numberWithDouble:self.currentSelectedOrder.priceToFill] forKey:@"price"];
            [postBodyDictionary setValue:[NSNumber numberWithDouble:self.currentSelectedOrder.triggeredPrice] forKey:@"stopLossTriggerPrice"];
        }
        else if([self.currentSelectedOrder.priceType caseInsensitiveCompare:@"stoplossmarket"] == NSOrderedSame){
            [postBodyDictionary setValue:[NSNumber numberWithDouble:self.currentSelectedOrder.triggeredPrice] forKey:@"stopLossTriggerPrice"];
        }
        
        NSLog(@"%@",postBodyDictionary);
        
        [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyDictionary responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
            
            NSError *jsonParsingError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            NSLog(@"Order Response is %@",responseDictionary);
            
            if([data length] > 0){
                
                NSError *jsonParsingError = nil;
                NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
                NSLog(@"%@",responseArray);
            }
            
        }];

    }
    else{
        NSString *relativePath = [TTUrl tradeOrderURL];
        //[self.diffusionHandler subscribe:@"REPORTS/TEST/EXRS" withContext:self];
        NSMutableDictionary *tradeData=[self createTradeData];
        NSLog(@"Dictionary is: %@",tradeData);
        
        SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
        
        NSArray *postBodyArray = [NSArray arrayWithObject:tradeData];
        
        [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyArray responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
            
            NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
            if(recievedResponse.statusCode != 200){
                [self showAlert:NSLocalizedStringFromTable(@"Order_Failure", @"Localizable",@"Order is not placed successfully") :0];
            }
            else{
                [self showAlert:NSLocalizedStringFromTable(@"Order_Success", @"Localizable",@"Order placed successfully") :0];
            }
            
        }];
    }
    
    
}


// creating the dictionary for post body
-(NSMutableDictionary *) createTradeData{
    int qty=(int)self.qtyValue.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * today = [formatter stringFromDate:[NSDate date]];
       NSLog(@"Date format is %@",today);
           NSArray *objects= [[NSArray alloc] initWithObjects:
                    @"(",self.exchange.text,qty ,self.orderType,@"",self.symbolData.symbolName,self.tradeType,
                              self.optionType.text,@"",today,self.disQty,self.prodType,@"TEST",nil];
        NSArray *keys=[[NSArray alloc] initWithObjects: @"customerFirm",@"iDSource",@"orderQty",@"ordType",@"securityID",@"symbol",@"side",@"securityType",@"timeInForce",@"transactTime",@"disclosedQty",
                       @"productType",@"clientID",nil];
    
       NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
   
    if([self.orderType isEqualToString:@"Limit"]){
        [dict setObject:self.price forKey:@"price"];
    }
    else if([self.orderType isEqualToString:@"SL-L"]){
        [dict setObject:self.price forKey:@"price"];
        [dict setObject:self.triggerPrice forKey:@"stopLossTriggerPrice"];
    }
    else if([self.orderType isEqualToString:@"SL-L"]){
        [dict setObject:self.triggerPrice forKey:@"stopLossTriggerPrice"];
    }
 
    // check for future Stock and index
    if([self.optionType.text isEqualToString:@"FUTIDX"]||[self.optionType.text isEqualToString:@"FUTSTK"]||[self.optionType.text isEqualToString:@"FUTCUR"])
    {
        [dict setValue:@"FUTURES" forKey:@"securityType"];
    }
    else if([self.optionType.text isEqualToString:@"OPTSTK"]||[self.optionType.text isEqualToString:@"OPTIDX"]||[self.optionType.text isEqualToString:@"OPTCUR"])
    {
        [dict setValue:@"OPTIONS" forKey:@"securityType"];
    }
  
   
    return dict;
}

@end
