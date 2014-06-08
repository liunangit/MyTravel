//
//  ExchangeManager.h
//  Travel
//
//  Created by liunan on 14-5-31.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CurrencyType {
    CurrencyType_Unknow = 0,
    CurrencyType_CNY,
    CurrencyType_JPY,
} CurrencyType;

@interface ExchangeManager : NSObject

+ (id)sharedInstance;
+ (float)exchangeCNYtoJPY:(float)CNYcount;
+ (float)exchangeJPYtoCNY:(float)JPYCount;
- (void)getRateExchange;

@end
