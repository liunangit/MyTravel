//
//  WeatherInfo.h
//  Travel
//
//  Created by liunan on 14-6-1.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityInfo : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger cityCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) float lon;
@property (nonatomic, assign) float lat;
@property (nonatomic, copy) NSString *country;

@end

@interface WeatherCondition : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger weatherCode;
@property (nonatomic, copy) NSString *weatherDesc;

@end

@interface WeatherInfo : NSObject <NSCoding>

@property (nonatomic, strong) CityInfo *cityInfo;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) float temp;
@property (nonatomic, assign) float tempMin;
@property (nonatomic, assign) float tempMax;
@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, strong) WeatherCondition *weatherCondition;

@end

