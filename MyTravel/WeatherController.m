//
//  WeatherController.m
//  MyTravel
//
//  Created by liunan on 14-6-7.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "WeatherController.h"
#import "WeatherInfo.h"
#import "WeatherTableCell.h"
#import "WeatherManager.h"

@interface WeatherController ()

@property (nonatomic, strong) NSArray *cityList;
@property (nonatomic, strong) NSMutableDictionary *cityWeatherDic;

@end

@implementation WeatherController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cityList = @[@kCityCodeBeijing, @kCityCodeShenzhen, @kCityCodeHK, @kCityCodeTokyo, @kCityCodeKyoto, @kCityCodeOsaka];
    self.cityWeatherDic = [NSMutableDictionary dictionaryWithCapacity:self.cityList.count];

    for (NSNumber *cityCodeNum in self.cityList) {
        [[WeatherManager sharedInstance] requestWeatherWithCityCode:[cityCodeNum intValue] completion:^(WeatherInfo *info) {
            [self.cityWeatherDic setObject:info forKey:cityCodeNum];
            [self.tableView reloadData];
        }];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherInfoCellIdentifier" forIndexPath:indexPath];
    int row = indexPath.row;
    WeatherInfo *info = [self.cityWeatherDic objectForKey:self.cityList[row]];
    cell.info = info;
    return cell;
}

@end
