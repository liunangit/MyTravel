//
//  WeatherManager.m
//  Travel
//
//  Created by liunan on 14-6-1.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "WeatherManager.h"
#import "WeatherInfo.h"
#import "AFHTTPRequestOperationManager.h"
#import "WeatherBuilder.h"
#import "ReactiveCocoa.h"

@interface WeatherManager ()

@property (nonatomic, strong) NSMutableDictionary *weatherDic;
@property (nonatomic, strong) dispatch_queue_t weather_dispatch_queue;

@end

@implementation WeatherManager

+ (id)sharedInstance
{
    static WeatherManager *g_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        g_manager = [[WeatherManager alloc] init];
    });
    return g_manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.weather_dispatch_queue = dispatch_queue_create("weather_dispatch_queue", NULL);
        [self loadWeatherCache];
        if (!self.weatherDic) {
            self.weatherDic = [[NSMutableDictionary alloc] init];
        }
        
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                               object:nil]
         subscribeNext:^(id x) {
             [self saveWeatherCache];
         }];
    }
    return self;
}

- (BOOL)shouldRequestLatestWeather:(NSInteger)cityCode
{
    NSNumber *codeNum = [NSNumber numberWithInt:cityCode];
    WeatherInfo *info = self.weatherDic[codeNum];
    if (!info) {
        return YES;
    }

    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:info.date];
    if (timeInterval > kWeatherRequestTimeInterval) {
        return YES;
    }
    return NO;
}

- (void)requestWeatherWithCityCode:(NSInteger)cityCode completion:(weather_response)response
{
    if (cityCode <= 0) {
        return;
    }
    
    dispatch_sync(self.weather_dispatch_queue, ^(void) {
        NSNumber *codeNum = [NSNumber numberWithInt:cityCode];
        if (![self shouldRequestLatestWeather:cityCode]) {
            WeatherInfo *info = self.weatherDic[codeNum];
            if (response) {
                response(info);
            }
            return;
        }
        
        NSString *requestURL = [kWeatherCityIDRequestURL stringByAppendingFormat:@"%d", cityCode];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Weaher: %@", responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDic = responseObject;
                WeatherInfo *info = [WeatherBuilder buildWeatherInfo:responseDic];
                self.weatherDic[codeNum] = info;
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    if (response) {
                        response(info);
                    }
                });
                return;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

    });
}

- (void)updateWeatherInfo
{
    [self requestWeatherWithCityCode:kCityCodeTokyo completion:nil];
}

#pragma mark - cache

- (NSString *)cachePath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Weather.data"];
}

- (void)loadWeatherCache
{
    NSString *path = [self cachePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        dispatch_sync(self.weather_dispatch_queue, ^(void) {
            @try {
                self.weatherDic = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            }
            @catch (NSException *exception) {
                NSLog(@"unarchiver error! %@", exception);
            }
        });
    }
}

- (void)saveWeatherCache
{
    NSString *path = [self cachePath];
    dispatch_async(self.weather_dispatch_queue, ^(void) {
        [NSKeyedArchiver archiveRootObject:self.weatherDic toFile:path];
    });
}

@end
