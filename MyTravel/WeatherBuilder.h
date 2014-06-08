//
//  WeatherBuilder.h
//  Travel
//
//  Created by liunan on 14-6-1.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherInfo;

@interface WeatherBuilder : NSObject

+ (id)sharedInstance;
+ (WeatherInfo *)buildWeatherInfo:(NSDictionary *)weatherDic;

@end
