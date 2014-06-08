//
//  ExchangeTableViewCell.m
//  MyTravel
//
//  Created by liunan on 14-6-7.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "ExchangeTableViewCell.h"
#import "ReactiveCocoa.h"

@interface ExchangeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@end

@implementation ExchangeTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textFiled.clearButtonMode = UITextFieldViewModeAlways;
    self.textFiled.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.textFiled.rac_textSignal subscribeNext:^(NSString *text) {
        _price = [text floatValue];
        if ([self.delegate respondsToSelector:@selector(exchangeInputDidChanged:)]) {
            [self.delegate exchangeInputDidChanged:self];
        }
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHideKeyBoardsNotification
                                                           object:nil]
     subscribeNext:^(id x) {
         [self.textFiled resignFirstResponder];
     }];
}

- (void)setCurrencyType:(CurrencyType)currencyType
{
    if (_currencyType != currencyType) {
        _currencyType = currencyType;
        NSString *labelText = nil;
        switch (currencyType) {
            case CurrencyType_CNY:
                labelText = @"人民币";
                break;
            case CurrencyType_JPY:
                labelText = @"日元";
                break;
            default:
                break;
        }
        
        self.label.text = labelText;
    }
}

- (void)setPrice:(float)price
{
    self.textFiled.text = [NSString stringWithFormat:@"%.2f", price];
    _price = price;
}

@end
