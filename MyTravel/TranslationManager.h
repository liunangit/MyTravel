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
- (void)translate:(NSString *)str completion:(translationCompletion)completion;

@end
