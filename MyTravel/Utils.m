//
//  Utils.m
//  Travel
//
//  Created by liunan on 14-6-2.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "Utils.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"

@implementation Utils

+ (NSString *)formatDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    static NSDateFormatter* fmt = nil;
    if (!fmt) {
        fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
    }
    
    return [fmt stringFromDate:date];
}

+ (float)celsiusFromFahrenheit:(float)fahrenheit
{
    return (fahrenheit - 32) / 1.8f;
}

+ (float)fahrenheitFromCelsius:(float)celsius
{
    return (32 + celsius) * 1.8f;
}

+ (float)celsiusFromThermodynamic:(float)thermodynamic
{
    return thermodynamic - 273.15;
}

+ (AFNetworkReachabilityStatus)networkStatus
{
    return [AFHTTPRequestOperationManager manager].reachabilityManager.networkReachabilityStatus;
}

+ (void)showErrorPost:(NSString *)msg
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    HUD.labelText = msg;
    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    
}
@end
