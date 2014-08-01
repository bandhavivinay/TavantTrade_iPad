//
//  TTDiffusionData.m
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTDiffusionData.h"

@implementation TTDiffusionData

@synthesize askValue,bidValue,fiftyTwoWeekHigh,fiftyTwoWeekLow,highPrice,lastSalePrice,lowPrice,netPriceChange,netPriceChangeIndicator,volume,symbolData,closingPrice,openingPrice,topic;

-(id)init{
    self = [super init];
    if(self){
        self.netPriceChangeIndicator = @"+";
        return self;
    }
    return nil;
}


-(id)updateDiffusionDataWith:(NSArray *)streamingData{
    self.askValue = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:12] floatValue]);
    self.bidValue = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:10] floatValue]);
    self.fiftyTwoWeekHigh = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:8] floatValue]);
    self.fiftyTwoWeekLow = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:9] floatValue]);
    self.highPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:2] floatValue]);
    self.lowPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:3] floatValue]);
    self.netPriceChange = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:7] floatValue]);
    self.lastSalePrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:13] floatValue]);
    self.volume = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:16] floatValue]);
    self.openingPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:4] floatValue]);
    self.closingPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:5] floatValue]);
    if([EMPTY_IF_NIL([streamingData objectAtIndex:6]) length] == 0)
        self.netPriceChangeIndicator = @"";

    else
        self.netPriceChangeIndicator = EMPTY_IF_NIL([streamingData objectAtIndex:6]);

    return self;
}

@end
