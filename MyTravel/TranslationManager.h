//
//  TranslationManager.h
//  Travel
//
//  Created by liunan on 14-5-31.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^translationCompletion)(NSString *result);

typedef enum {
    TranslationTypeCn2En,   //中英互译
    TranslationTypeCn2Ja,
    TranslationTypeJa2Cn
}TranslationType;

@interface TranslationManager : NSObject

+ (id)sharedInstance;

- (void)translate:(NSString *)str type:(TranslationType)type completion:(translationCompletion)completion;

@end
