//
//  TranslationManager.h
//  Travel
//
//  Created by liunan on 14-5-31.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^translationCompletion)(NSString *result);

@interface TranslationManager : NSObject

+ (id)sharedInstance;

//中英互译
- (void)translateCn2En:(NSString *)str completion:(translationCompletion)completion;

//中日互译
- (void)translateCn2Ja:(NSString *)str completion:(translationCompletion)completion;

@end
