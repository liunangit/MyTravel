//
//  TranslationCache.h
//  MyTravel
//
//  Created by wihing on 14-6-25.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranslationInfo.h"

@interface TranslationCache : NSObject

- (instancetype)initWithName:(NSString *)name;
- (TranslationInfo *)cachedTranslationInfoWithString:(NSString *)string;
- (void)cacheTranslationInfo:(TranslationInfo *)translationInfo withString:(NSString *)string;

@end
