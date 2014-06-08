//
//  WeatherTableCell.m
//  MyTravel
//
//  Created by liunan on 14-6-8.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "WeatherTableCell.h"
#import "WeatherInfo.h"

@interface WeatherTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *minMaxLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;



@end

@implementation WeatherTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setInfo:(WeatherInfo *)info
{
    if (info != _info) {
        self.cityNameLabel.text = info.cityInfo.name;
        self.tempLabel.text = [NSString stringWithFormat:@"%d℃", (NSInteger)info.temp];
        self.descLabel.text = info.weatherCondition.weatherDesc;
        self.minMaxLabel.text = [NSString stringWithFormat:@"%d℃/%d℃", (NSInteger)info.tempMin, (NSInteger)info.tempMax];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.cityNameLabel.text = nil;
    self.tempLabel.text = nil;
    self.descLabel.text = nil;
    self.minMaxLabel.text = nil;
}

@end
