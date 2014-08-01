//
//  TTDiffusionData.h
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSymbolData.h"
#import "TTConstants.h"

#define EMPTY_IF_NIL(__STRING) (__STRING ? __STRING : @"")

#define EMPTY_Float_IF_NIL(__float) (__float ? __float : 0.0)

@interface TTDiffusionData : NSObject

@property(nonatomic,strong)TTSymbolData *symbolData;
@property(nonatomic,assign)float lastSalePrice;
@property(nonatomic,assign)float bidValue;
@property(nonatomic,assign)float askValue;
@property(nonatomic,assign)float volume;
@property(nonatomic,assign)float fiftyTwoWeekHigh;
@property(nonatomic,assign)float fiftyTwoWeekLow;
@property(nonatomic,assign)float highPrice;
@property(nonatomic,assign)float lowPrice;
@property(nonatomic,assign)float openingPrice;
@property(nonatomic,assign)float closingPrice;
@property(nonatomic,assign)float netPriceChange;
@property(nonatomic,strong)NSString *netPriceChangeIndicator;
//@property(nonatomic,strong)NSString *subKey;
//@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *topic;
@property(nonatomic,assign)InstrumentType instrumentType;

-(id)updateDiffusionDataWith:(NSArray *)streamingData;

@end
