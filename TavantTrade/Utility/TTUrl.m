//
//  TTUrl.m
//  TavantTrade
//
//  Created by Gautham S Shetty on 23/12/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTUrl.h"

@implementation TTUrl

+ (NSString *)BaseURL{
    
    return @"http://10.129.133.50:8081/api/";
}

+(NSString *)tradeLimitURL{
    return @"trade/limits";
}

+(NSString *)tickerNSEURL{
    return @"instruments/NIFTY/NSE/INDEX/null/null/null/0";
}

+(NSString *)tickerBSEURL{
    return @"instruments/SENSEX/BSE/INDEX/null/null/null/0";
}

+(NSString *)marketNewsURL{
    return @"marketdata/livenews";
}

+(NSString *)marketnewsDetailsURL{
    return @"marketdata/livenewsdetails";
}

+(NSString *)orderBookURL{
    return @"trade/orderreport";
}

+(NSString *)cancelOrderURL{
    return @"trade/cancelorder";
}

+(NSString *)modifyOrderURL{
    return @"trade/modifyorder";
}

+(NSString *)tradeOrderURL{
    return @"trade/newordersingle";
}
+(NSString *)accountLoginURL{
    return @"http://m.sbicapstestlab.com/login";
}

+(NSString *)positionURL{
    return @"trade/positions";
}
+(NSString *)messagesUrl{
    return @"informationmessage";
}

+(NSString *)recommendationURL{
    return @"marketdata/researchrecommendation";
}

+(NSString *)optionChainUrl{
    return @"instruments/option/";
}

+(NSString *)getAllIndices{
    return @"instruments/indices";
}

+(NSString *)customerFeedbackUrl{
    return @"http://bo.sbicapsec.com/clientreports/webservice/ssl.asmx";
}

@end
