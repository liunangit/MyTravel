//
//  ExchangeTableViewCell.h
//  MyTravel
//
//  Created by liunan on 14-6-7.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeManager.h"

@class ExchangeTableViewCell;

@protocol ExchangeTableViewCellDelegate <NSObject>

- (void)exchangeInputDidChanged:(ExchangeTableViewCell *)cell;

@end

@interface ExchangeTableViewCell : UITableViewCell

@property (nonatomic, assign) CurrencyType currencyType;
@property (nonatomic, weak) id<ExchangeTableViewCellDelegate> delegate;
@property (nonatomic) float price;

@end
