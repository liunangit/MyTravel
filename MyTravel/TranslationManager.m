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

@property (nonatomic, strong) NSMutableDictionary *transCn2EnDic;
@property (nonatomic, strong) NSMutableDictionary *transCn2JaDic;
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
        self.transCn2EnDic = [NSMutableDictionary dictionary];
        self.transCn2JaDic = [NSMutableDictionary dictionary];
        self.queue = dispatch_queue_create("com.liunan.translation", NULL);
    }
    return self;
}

- (NSString *)translationEn2CnURLWithContent:(NSString *)content
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

- (NSString *)translationCn2JaURL
{
    static NSString *requestURL = @"http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule&smartresult=ugc&sessionFrom=null";
    return requestURL;
}

- (void)translateBetweenEnglishAndChinese:(NSString *)str completion:(translationCompletion)completion
{
    TranslationInfo *info = self.transCn2EnDic[str];
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
        
        NSString *requestURL = [self translationEn2CnURLWithContent:str];
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
                        self.transCn2EnDic[str] = info;
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

- (void)translateBetweenJapanieseAndChinese:(NSString *)str completion:(translationCompletion)completion
{
    TranslationInfo *info = self.transCn2JaDic[str];
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
        
        __block NSString *resultStr = nil;
        NSString *requestURL = [self translationCn2JaURL];
        NSDictionary *dic = @{@"type": @"ZH_CN2JA", @"doctype" : @"json", @"xmlVersion" : @"1.6", @"keyfrom" : @"fanyi.web", @"ue" : @"UTF-8", @"typoResult" : @"true"};
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString *percentEscapesStr = str;//[str stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
        [parameters setValue:percentEscapesStr forKey:@"i"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
            NSDictionary *resultDic = response;
            NSArray *translateResult = resultDic[@"translateResult"];
            
            if ([translateResult isKindOfClass:[NSArray class]] && translateResult.count > 0) {
                id t = [translateResult firstObject];
                if ([t isKindOfClass:[NSArray class]]) {
                    NSArray *tArray = t;
                    if (tArray.count > 0) {
                        NSDictionary *dic = [tArray firstObject];
                        resultStr = dic[@"tgt"];
                    }
                }
                else if ([t isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *tDic = t;
                    resultStr = tDic[@"tgt"];
                }
            }
            
            TranslationInfo *info = [[TranslationInfo alloc] init];
            info.query = str;
            info.translation = resultStr;
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                if (resultStr) {
                    self.transCn2JaDic[str] = info;
                }
                
                if (completion) {
                    completion(resultStr);
                }
            });
            return;
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"%@", error);
                  if (completion) {
                      completion(nil);
                  }
              }];
        
    });
}

- (void)translateCn2Ja:(NSString *)str completion:(translationCompletion)completion
{
    if (str.length == 0) {
        if (completion) {
            completion(str);
        }
        return;
    }
    
    [self translateBetweenJapanieseAndChinese:str completion:completion];
}

- (void)translateCn2En:(NSString *)str completion:(translationCompletion)completion
{
    if (str.length == 0) {
        if (completion) {
            completion(str);
        }
        return;
    }
    [self translateBetweenEnglishAndChinese:str completion:completion];
}

@end
