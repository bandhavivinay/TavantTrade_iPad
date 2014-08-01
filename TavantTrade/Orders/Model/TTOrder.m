//
//  TTOrder.m
//  TavantTrade
//
//  Created by Bandhavi on 2/17/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTOrder.h"
#import "SBITradingUtility.h"

@implementation TTOrder

-(id)initWithOrderDictionary:(NSDictionary *)inDictionary{
    self = [super init];
    if(self){
        self.symbolData = [[TTSymbolData alloc] init];
        self.account = EMPTY_IF_NIL(inDictionary[@"account"]);
        self.clientID = EMPTY_IF_NIL(inDictionary[@"clientID"]);
        //Testing ...
        self.confirmDate = [SBITradingUtility returnDateWithTimeFrom:EMPTY_IF_NIL(inDictionary[@"secSinceBOE"])];
        //self.confirmDate = EMPTY_IF_NIL(inDictionary[@"confirmDate"]);
        self.clientID = EMPTY_IF_NIL(inDictionary[@"clientID"]);
        self.disclosedQuantity = [EMPTY_IF_NIL(inDictionary[@"discolsedQty"]) intValue];
        self.exchangeType = EMPTY_IF_NIL(inDictionary[@"exchange"]);
        self.messageType = EMPTY_IF_NIL(inDictionary[@"msgType"]);
        self.orderDuration = EMPTY_IF_NIL(inDictionary[@"orderDuration"]);
        self.priceToFill = [EMPTY_IF_NIL(inDictionary[@"priceToFill"]) doubleValue];
        self.priceType = EMPTY_IF_NIL(inDictionary[@"priceType"]);
        self.productType = EMPTY_IF_NIL(inDictionary[@"productType"]);
//        self.durationType = EMPTY_IF_NIL(inDictionary[@"durationType"]);
//        self.orderType = EMPTY_IF_NIL(inDictionary[@"orderType"]);
        self.quantitytoFill = [EMPTY_IF_NIL(inDictionary[@"qtyToFill"]) intValue];
        self.status = EMPTY_IF_NIL(inDictionary[@"status"]);
        self.symbolData.tradeSymbolName = EMPTY_IF_NIL(inDictionary[@"symbol"]);
        NSString *tempSymbolName = @"";
        NSScanner *scanner = [NSScanner scannerWithString:self.symbolData.tradeSymbolName];
        [scanner scanUpToString:@"-" intoString:&tempSymbolName];
        self.symbolData.symbolName = tempSymbolName;
//        self.symbolName = EMPTY_IF_NIL(inDictionary[@"symbol"]);
        self.transactionType = EMPTY_IF_NIL(inDictionary[@"transactionType"]);
        self.rejectionReason = EMPTY_IF_NIL(inDictionary[@"ordRejReason"]);
        self.transactionType = EMPTY_IF_NIL(inDictionary[@"transactionType"]);
        self.subscriptionKey = EMPTY_IF_NIL(inDictionary[@"subscriptionKey"]);
        self.orderID = EMPTY_IF_NIL(inDictionary[@"nestOrderNo"]);
        self.isAmo = ([EMPTY_IF_NIL(inDictionary[@"amo"]) isEqualToString:@"YES"])?@"true":@"false";
        self.triggeredPrice = [EMPTY_IF_NIL(inDictionary[@"triggerPrice"]) doubleValue];
        self.symbolData.companyName = EMPTY_IF_NIL(inDictionary[@"companyName"]);
        
        return self;
    }
    return nil;

}




@end
