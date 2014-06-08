//
//  WeatherTableCell.h
//  MyTravel
//
//  Created by liunan on 14-6-8.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherInfo;

@interface WeatherTableCell : UITableViewCell

@property (nonatomic, strong) WeatherInfo *info;

@end
