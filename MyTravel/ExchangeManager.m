//
//  ExchangeManager.m
//  Travel
//
//  Created by liunan on 14-5-31.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "ExchangeManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface ExchangeManager ()

@property (nonatomic, assign) float exchangeRate;
@property (nonatomic, strong) dispatch_queue_t exchange_dispatch_queue;

- (float)exchangeCount:(float)count from:(CurrencyType)from to:(CurrencyType)to;

@end

@implementation ExchangeManager

+ (id)sharedInstance
{
    static ExchangeManager *g_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        g_manager = [[ExchangeManager alloc] init];
    });
    
    return g_manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.exchangeRate = kDefaultExchangeRateOfCNYtoJPY;
        self.exchange_dispatch_queue = dispatch_queue_create("exchange_dispatch_queue", NULL);
        [self loadExchangeRate];
    }
    return self;
}

- (void)loadExchangeRate
{
    float rate = [[NSUserDefaults standardUserDefaults] floatForKey:@"ExchangeRate"];
    if (rate > 0) {
        self.exchangeRate = rate;
    }
}

- (void)setExchangeRate:(float)rate
{
    if (rate > 0) {
        [[NSUserDefaults standardUserDefaults] setFloat:rate forKey:@"ExchangeRate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _exchangeRate = rate;
    }
}

+ (float)exchangeCNYtoJPY:(float)CNYcount
{
    return [[ExchangeManager sharedInstance] exchangeCount:CNYcount from:CurrencyType_CNY to:CurrencyType_JPY];
}

+ (float)exchangeJPYtoCNY:(float)JPYCount
{
     return [[ExchangeManager sharedInstance] exchangeCount:JPYCount from:CurrencyType_JPY to:CurrencyType_CNY];
}

- (float)exchangeCount:(float)count from:(CurrencyType)from to:(CurrencyType)to
{
    if (from == to) {
        return count;
    }
    
    if (from == CurrencyType_CNY) {
        return count * self.exchangeRate;
    }
    return count / self.exchangeRate;
}

#pragma mark - Current Request

- (void)getRateExchange
{
    dispatch_sync(self.exchange_dispatch_queue, ^(void) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:kCurrentRequestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDic = responseObject;
                NSNumber *rate = responseDic[@"rate"];
                if (rate) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setExchangeRate:[rate floatValue]];
                    });
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    });
}

@end
