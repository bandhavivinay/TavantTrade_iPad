//
//  TTMapData.h
//  TavantTrade
//
//  Created by Bandhavi on 5/21/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTConstants.h"

@interface TTMapData : NSObject
@property(nonatomic,strong)NSString *symbolName;
@property(nonatomic,assign)EExchangeType exchangeType;
@property(nonatomic,strong)NSString *companyName;
@property(nonatomic,strong)NSString *percentageChange;
@property(nonatomic,strong)NSString *netChange;
@property(nonatomic,strong)NSString *turnover;
@property(nonatomic,strong)NSString *OIChange;
@property(nonatomic,strong)NSString *volume;

@end
