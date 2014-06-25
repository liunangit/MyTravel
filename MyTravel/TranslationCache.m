//
//  TranslationCache.m
//  MyTravel
//
//  Created by wihing on 14-6-25.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "TranslationCache.h"

@interface TranslationCache ()

@property (strong, nonatomic) NSString *cacheFileName;
@property (strong, nonatomic) NSString *cacheFilePath;
@property (strong, nonatomic) NSMutableDictionary *memoryCache;

@end

@implementation TranslationCache

- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _cacheFileName = name;
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _cacheFilePath = [paths[0] stringByAppendingPathComponent:_cacheFileName];
        
        _memoryCache = [NSKeyedUnarchiver unarchiveObjectWithFile:_cacheFilePath];
        if (_memoryCache == nil) {
            _memoryCache = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

- (TranslationInfo *)cachedTranslationInfoWithString:(NSString *)string
{
    return self.memoryCache[string];
}

- (void)cacheTranslationInfo:(TranslationInfo *)translationInfo withString:(NSString *)string
{
    self.memoryCache[string] = translationInfo;
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.memoryCache];
    [data writeToFile:self.cacheFilePath atomically:YES];
}

@end
