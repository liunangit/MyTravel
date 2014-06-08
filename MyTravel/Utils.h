//
//  Utils.h
//  Travel
//
//  Created by liunan on 14-6-2.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"

@interface Utils : NSObject

+ (NSString *)formatDate:(NSDate *)date;
+ (float)celsiusFromFahrenheit:(float)fahrenheit;
+ (float)fahrenheitFromCelsius:(float)celsius;
+ (float)celsiusFromThermodynamic:(float)thermodynamic;

+ (AFNetworkReachabilityStatus)networkStatus;
+ (void)showErrorPost:(NSString *)msg;

@end
