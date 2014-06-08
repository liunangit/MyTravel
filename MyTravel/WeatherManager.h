//
//  WeatherManager.h
//  Travel
//
//  Created by liunan on 14-6-1.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherInfo;

typedef void (^weather_response)(WeatherInfo *weatherInfo);

@interface WeatherManager : NSObject

+ (id)sharedInstance;
- (void)requestWeatherWithCityCode:(NSInteger)cityCode completion:(weather_response)response;
- (void)updateWeatherInfo;


@end
