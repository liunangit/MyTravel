//
//  TranslationManager.m
//  Travel
//
//  Created by liunan on 14-5-31.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "TranslationManager.h"
#import "TranslationInfo.h"
#import "AFHTTPRequestOperationManager.h"
#import "Utils.h"

@interface TranslationManager ()

@property (nonatomic, strong) NSMutableDictionary *transDic;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation TranslationManager

+ (id)sharedInstance
{
    static TranslationManager *g_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        g_manager = [[TranslationManager alloc] init];
    });
    return g_manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.transDic = [NSMutableDictionary dictionary];
        self.queue = dispatch_queue_create("com.liunan.translation", NULL);
    }
    return self;
}

- (NSString *)translationURLWithContent:(NSString *)content
{
    static NSArray *keyfromList = nil;
    static NSArray *apiKeyList = nil;
    
    if (!keyfromList) {
        keyfromList = @[@"liunan", @"liunan1", @"liunan2", @"liunan3", @"liunan4"];
    }
    
    if (!apiKeyList) {
        apiKeyList = @[@"1102454909", @"183636238", @"183636239", @"183636240", @"183636241"];
    }
    
    NSInteger randomIndex = arc4random() % keyfromList.count;
    NSString *keyfrom = [keyfromList objectAtIndex:randomIndex];
    NSString *apiKey = [apiKeyList objectAtIndex:randomIndex];
    
    return [NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=%@&key=%@&type=data&doctype=json&version=1.1&q=%@",
            keyfrom,
            apiKey,
            content];
}

- (void)translate:(NSString *)str completion:(translationCompletion)completion
{
    if (str.length == 0) {
        if (completion) {
            completion(str);
        }
        return;
    }
    
    TranslationInfo *info = self.transDic[str];
    if (info) {
        if (completion) {
            completion(info.translation);
        }
        return;
    }
    
    AFNetworkReachabilityStatus status = [Utils networkStatus];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        [Utils showErrorPost:@"无可用网络"];
        return;
    }
    
    dispatch_async(self.queue, ^(void) {
        
        NSString *requestURL = [self translationURLWithContent:str];
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Translation: %@", responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *responseDic = responseObject;
                TranslationInfo *info = [[TranslationInfo alloc] init];
                info.query = str;
                NSArray *translationArray = responseDic[@"translation"];
                if ([translationArray isKindOfClass:[NSArray class]] && translationArray.count > 0) {
                    info.translation = [translationArray firstObject];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    if (info.translation) {
                        self.transDic[str] = info;
                    }
                    if (completion) {
                        completion(info.translation);
                    }
                });
                return;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                NSLog(@"Error: %@", error);
                if (completion) {
                    completion(nil);
                }
                
                AFNetworkReachabilityStatus status = [Utils networkStatus];
                if ((status == AFNetworkReachabilityStatusNotReachable) ||
                    (status == AFNetworkReachabilityStatusUnknown)) {
                    [Utils showErrorPost:@"无可用网络"];
                    return;
                }
            });
        }];
    });
}

@end
