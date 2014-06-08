//
//  WeatherBuilder.m
//  Travel
//
//  Created by liunan on 14-6-1.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "WeatherBuilder.h"
#import "WeatherInfo.h"
#import "Utils.h"

@interface WeatherBuilder ()

@property (nonatomic, strong) NSDictionary *weatherConditionDic;
@end

@implementation WeatherBuilder

+ (id)sharedInstance
{
    static WeatherBuilder *g_builder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        g_builder = [[WeatherBuilder alloc] init];
    });
    return g_builder;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *weatherPlist = [[NSBundle mainBundle] pathForResource:@"Weather.plist" ofType:nil];
        self.weatherConditionDic = [NSDictionary dictionaryWithContentsOfFile:weatherPlist];
    }
    return self;
}

+ (WeatherInfo *)buildWeatherInfo:(NSDictionary *)weatherDic
{
    WeatherInfo *weatherInfo = [[WeatherInfo alloc] init];
    
    CityInfo *cityInfo = [[CityInfo alloc] init];
    cityInfo.cityCode = [weatherDic[@"id"] integerValue];
    
    NSDictionary *coordDic = weatherDic[@"coord"];
    if ([coordDic isKindOfClass:[NSDictionary class]]) {
        cityInfo.lat = [coordDic[@"lat"] floatValue];
        cityInfo.lon = [coordDic[@"lon"] floatValue];
    }
    cityInfo.name = weatherDic[@"name"];
    weatherInfo.cityInfo = cityInfo;
    weatherInfo.date = [NSDate date];
    
    NSDictionary *main = weatherDic[@"main"];
    if ([main isKindOfClass:[NSDictionary class]]) {
        weatherInfo.temp = [Utils celsiusFromThermodynamic:[main[@"temp"] floatValue]];
        weatherInfo.tempMin = [Utils celsiusFromThermodynamic:[main[@"temp_min"] floatValue]];
        weatherInfo.tempMax = [Utils celsiusFromThermodynamic:[main[@"temp_max"] floatValue]];
        weatherInfo.humidity = [main[@"humidity"] integerValue];
    }
  
    NSArray *conditionArray = weatherDic[@"weather"];
    if ([conditionArray isKindOfClass:[NSArray class]] && (conditionArray.count > 0)) {
        NSDictionary *conditionDic = [conditionArray firstObject];
        WeatherCondition *condition = [[WeatherCondition alloc] init];
        condition.weatherCode = [conditionDic[@"id"] integerValue];
        condition.weatherDesc = [[[self class] sharedInstance] descForWeatherCode:condition.weatherCode];
        weatherInfo.weatherCondition = condition;
    }

    
    return weatherInfo;
}

- (NSString *)descForWeatherCode:(NSInteger)code
{
    NSString *codeStr = [NSString stringWithFormat:@"%d", code];
    NSDictionary *conditionDic = [self.weatherConditionDic objectForKey:codeStr];
    return conditionDic[@"desc"];
}

@end
