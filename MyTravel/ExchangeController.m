//
//  ExchangeController.m
//  MyTravel
//
//  Created by liunan on 14-6-7.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "ExchangeController.h"
#import "ExchangeTableViewCell.h"
#import "ExchangeManager.h"
#import "ReactiveCocoa.h"

@interface ExchangeController () <ExchangeTableViewCellDelegate>

@property (nonatomic, strong) NSArray *currencyList;
@property (nonatomic, strong) ExchangeTableViewCell *CNYCell;

@end

@implementation ExchangeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currencyList = @[@1, @2];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture.rac_gestureSignal subscribeNext:^(id next) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHideKeyBoardsNotification object:nil];
    }];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setCNYCount:100];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCNYCount:(float)count
{
    ExchangeTableViewCell *cell = self.CNYCell;
    if (cell && cell.currencyType == CurrencyType_CNY && cell.price <= 0) {
        [cell setPrice:count];
        [self exchangeInputDidChanged:cell];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currencyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeCellIdentifier" forIndexPath:indexPath];
    cell.delegate = self;
    
    NSInteger row = indexPath.row;
    cell.currencyType = [self.currencyList[row] integerValue];
    if (row == 0) {
        self.CNYCell = cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (void)exchangeInputDidChanged:(ExchangeTableViewCell *)cell
{
    float CNYPrice = 0;
    float JPYPrice = 0;
    
    if (cell.currencyType == CurrencyType_CNY) {
        CNYPrice = cell.price;
        JPYPrice = [ExchangeManager exchangeCNYtoJPY:CNYPrice];
        [self updateAllCellsCNY:-1 JPY:JPYPrice];
    }
    else if (cell.currencyType == CurrencyType_JPY) {
        JPYPrice = cell.price;
        CNYPrice = [ExchangeManager exchangeJPYtoCNY:JPYPrice];
        [self updateAllCellsCNY:CNYPrice JPY:-1];
    }
}

- (void)updateAllCellsCNY:(float)CNYPrice JPY:(float)JPYPrice
{
    for (ExchangeTableViewCell *cell in [self.tableView visibleCells]) {
        if (cell.currencyType == CurrencyType_CNY) {
            if (CNYPrice >= 0) {
                  cell.price = CNYPrice;
            }
            continue;
        }
        if (cell.currencyType == CurrencyType_JPY) {
            if (JPYPrice >= 0) {
                cell.price = JPYPrice;
            }
            continue;
        }
    }
}

@end
