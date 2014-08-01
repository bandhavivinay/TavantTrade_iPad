//
//  TTConstants.h
//  TavantTrade
//
//  Created by Bandhavi on 12/20/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#ifndef TavantTrade_Constants_h
#define TavantTrade_Constants_h

#define KWidgetsSettingsDidChangeNotification @"WidgetsSettingsChanged"
#define KWatchlistSettingsDidChangeNotification @"WatchlistSettingsChanged"
#define KWidgetsSetting @"WidgetSettings"
#define KWatchlistColumnSetting @"WatchlistSetting"

#define REGULAR_FONT_SIZE(fontSize) [UIFont fontWithName:@"OpenSans" size:fontSize]
#define SEMI_BOLD_FONT_SIZE(fontSize)[UIFont fontWithName:@"OpenSans-Semibold" size:fontSize]
#define LIGHT_FONT_SIZE(fontSize)[UIFont fontWithName:@"OpenSans-Light" size:fontSize]

#define COLUMN_OFFSET 55.0
#define TABLE_WIDTH 695.0


#define myValueString(enum) [@[@"EQUITY",@"FUTURE_STOCK",@"FUTURE_INDEX"] objectAtIndex:enum]


typedef enum InstrumentType {
	EQUITY = 0,
    FUTURE_STOCK = 1,
    FUTURE_INDEX = 2,
    FUTURE_CURRENCY = 3,
    OPTION_STOCK = 4,
    OPTION_INDEX = 5,
    OPTION_CURRENCY = 6
} InstrumentType;

typedef enum MarketDataType {
    TOP_GAINER = 0,
    TOP_LOSER = 1,
    HOURLY_GAINER = 2,
	HOURLY_LOSER = 3,
    VOL_SHOCKER = 4,
    VOL_TOPPER = 5,
    PRICE_SHOCKER = 6,
    MOST_ACTIVE = 7
} MarketDataType;

typedef enum ExchangeType{
    eNSE = 0,
    eBSE = 1
}EExchangeType;

typedef enum {
    eBuy=0,
    eSell=1
} ETransactionType;
typedef enum {
    eIntraday=0,
    eDelivery=1
} EProductType;
typedef enum {
    eLimitType=0,
    eMarketType=1,
    eSLLType=2,
    eSLMType=3
} EOrderType;
typedef enum {
    eDay=0,
    eIOC=1
} EDuration;

typedef enum {
    eTransaction=0,
    eProduct=1,
    eOrder,
    eDuration
}ETradingOptionsType;

typedef enum{
    eTradeAction=0,
    eQuoteAction=1,
    eDeleteSymbolAction,
    eOptionChainAction
}EWatchListActionItems;

typedef enum EWidgets{
    eChart = 0,
    eMarket = 1,
    eQuotes,
    eOrders,
    eTrade,
    eAccounts,
    ePosition,
    eViews,
    eMessages,
    eOptionChain
}EWidgets;

typedef enum EWatchlistColumns{
    eExpiryDate = 0,
    eLastTradedSize = 1,
    eLCL,
    eOI,
    eOptType,
    eRollingOI,
    eStrike,
    eUnderlier,
    eUCL,
    eVWAP,
    eOfferSize,
    eInstrument,
    eOffer
}EWatchlistColumns;

typedef enum EApplicationMenuItems {
    eChartMenuItem = 0,
    eQuoteMenuItem= 1,
    eMarketMenuItem,
    eTradeMenuItem,
    eOrdersMenuItem,
    eWatchlistMenuItem,
    eNewsMenuItem,
    ePositionsMenuItem,
    eOptionsChainMenuItem,
    eAdminViewsMenuItem,
    eAccountMenuItem,
    eAdminMessagesMenuItem,
    eScatterMapMenuItem,
    eCustomerFeedbackMenuItem,
    eBackOfficeLogsMenuItem,
    eSettingsMenuItem
}EApplicationMenuItems;


typedef enum ELimits{
    eClient=0,
    eCash=1,
    eFo=2,
    eCur=3
}ELimits;

typedef enum {
    eFeedbackQRC=0,
    eClientStatus=1,
    eLeadStatus=2
}ESOAPRequestType;

typedef enum EButtonType{
    eCategory=0,
    eSubCategory=1,
    eQuery=2
}EButtonType;

typedef enum ESearchFilterItems{
    eCompanyName=0,
    eExchange=1,
    eInstrumentType=2,
    eDateRange,
    eProductType,
    eSide
}ESearchFilterItems;

typedef enum {
    eDefault=0,
    eOptionChainSearch=1
} ESearchType;

#endif
