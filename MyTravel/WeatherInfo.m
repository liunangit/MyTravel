//
//  WeatherInfo.m
//  Travel
//
//  Created by liunan on 14-6-1.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "WeatherInfo.h"

@implementation WeatherInfo

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.cityInfo = [aDecoder decodeObjectForKey:@"cityInfo"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.temp = [aDecoder decodeFloatForKey:@"temp"];
        self.tempMin = [aDecoder decodeFloatForKey:@"tempMin"];
        self.tempMax = [aDecoder decodeFloatForKey:@"tempMax"];
        self.humidity = [aDecoder decodeIntegerForKey:@"humidity"];
        self.weatherCondition = [aDecoder decodeObjectForKey:@"weatherCondition"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cityInfo forKey:@"cityInfo"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeFloat:self.temp forKey:@"temp"];
    [aCoder encodeFloat:self.tempMax forKey:@"tempMax"];
    [aCoder encodeFloat:self.tempMin forKey:@"tempMin"];
    [aCoder encodeInteger:self.humidity forKey:@"humidity"];
    [aCoder encodeObject:self.weatherCondition forKey:@"weatherCondition"];
}

@end

@implementation CityInfo

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.cityCode = [aDecoder decodeIntegerForKey:@"cityCode"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.lon = [aDecoder decodeFloatForKey:@"lon"];
        self.lat = [aDecoder decodeFloatForKey:@"lat"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.cityCode forKey:@"cityCode"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeFloat:self.lon forKey:@"lon"];
    [aCoder encodeFloat:self.lat forKey:@"lat"];
    [aCoder encodeObject:self.country forKey:@"country"];
}

@end

@implementation WeatherCondition

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.weatherCode = [aDecoder decodeIntegerForKey:@"weatherCode"];
        self.weatherDesc = [aDecoder decodeObjectForKey:@"weatherDesc"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.weatherCode forKey:@"weatherCode"];
    [aCoder encodeObject:self.weatherDesc forKey:@"weatherDesc"];
}

@end