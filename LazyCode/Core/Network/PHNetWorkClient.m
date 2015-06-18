//
//  PHNetWorkClient.m
//  LazyCode
//
//  Created by penghe on 15/1/12.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "PHNetWorkClient.h"
#import "AFDownloadRequestOperation.h"

@interface PHNetWorkClient ()

@end

@implementation PHNetWorkClient
#pragma mark

//API地址
static NSString * const kClientAPIBaseURLString = @"www.baidu.com";
static NSString * const AppBuddleID = @"mobi.wonders.apps.ios.iSmile";
//默认超时时间
static const NSTimeInterval KDefaultTimeout = 10.0f;

static PHNetWorkClient *__helper = nil;

#pragma mark
//服务器请求的公共URL
+ (NSString *)baseUrl
{
    return kClientAPIBaseURLString;
}
//一些其他设置
- (void)paramsSetting
{
    //超时时间
    if (self.requestTimeoutInterval == 0) {
        __helper.requestSerializer.timeoutInterval = KDefaultTimeout;

    }
    else
    {
        __helper.requestSerializer.timeoutInterval = self.requestTimeoutInterval;

    }
    //请求类型
    if (self.SerializerType == PHRequestSerializerTypeHTTP) {
        __helper.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else
    {
        __helper.requestSerializer = [AFJSONRequestSerializer serializer];
    }


}
+ (instancetype)sharedClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __helper = [[self alloc] initWithBaseURL:[NSURL URLWithString:[[self class] baseUrl]]];
        if ([[[self class] baseUrl] notEmpty]) {
            [__helper paramsSetting];
        }
    });
    return __helper;
}


#pragma mark -- Request Types
- (AFHTTPRequestOperation *)GET:(NSString *)urlPath
                          param:(NSDictionary *)params
                        success:(BlockHTTPRequestSuccess)success
                        failure:(BlockHTTPRequestFailure)failure
{

    return [self requestWithPath:urlPath method:PHHttpRequestGet parameters:params success:success failure:failure];


}

- (AFHTTPRequestOperation *)POST:(NSString *)urlPath
                           param:(NSDictionary *)params
                         success:(BlockHTTPRequestSuccess)success
                         failure:(BlockHTTPRequestFailure)failure
{

    return [self requestWithPath:urlPath method:PHHttpRequestPost parameters:params success:success failure:failure];

}

- (AFHTTPRequestOperation *)requestWithPath:(NSString *)urlPath
                                     method:(PHHttpRequestType)requestType
                                 parameters:(id)parameters
                                    success:(BlockHTTPRequestSuccess)success
                                    failure:(BlockHTTPRequestFailure)failure;
{
    switch (requestType) {
        case PHHttpRequestGet:
        {
            return [__helper GET:urlPath parameters:parameters success:success failure:failure];
        }
            break;
        case PHHttpRequestPost:
        {
            return [__helper POST:urlPath parameters:parameters success:success failure:failure];
        }
            break;
        case PHHttpRequestDelete:
        {
            return [__helper DELETE:urlPath parameters:parameters success:success failure:failure];
        }
            break;
        case PHHttpRequestPut:
        {
            return [__helper PUT:urlPath parameters:parameters success:success failure:false];
        }
            break;

        default:
            break;

    }
}

#pragma mark - Cancel Opration
- (void)callAllOperations
{
    [__helper.operationQueue cancelAllOperations];
}
- (void)cancelHTTPOperationsWithMethod:(NSString *)method url:(NSString *)url
{
    if ([url length]==0) {
        return;
    }
    NSError *error;
    NSString *uRLString;
    if ([[[NSURL URLWithString:url]scheme] length] != 0)
    {
        uRLString = [[NSURL URLWithString:url] absoluteString];
    }
    else
    {
        uRLString = [[NSURL URLWithString:[[[self class] baseUrl] stringByAppendingString:url]] absoluteString];
        
    }
    NSString *pathToBeMatched = [[[__helper.requestSerializer requestWithMethod:method URLString:uRLString parameters:nil error:&error] URL] path];
    
    for (NSOperation *operation in [__helper.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        BOOL hasMatchingMethod = !method || [method  isEqualToString:[[(AFHTTPRequestOperation *)operation request] HTTPMethod]];
        BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];
        
        if (hasMatchingMethod && hasMatchingPath) {
            [operation cancel];
        }
    }
}
#pragma mark -- Post Files
- (AFHTTPRequestOperation *)POST:(NSString *)urlPath
                           param:(NSDictionary *)params
                            file:(NSData *)file
                         fileKey:(NSString *)fileKey
                        fileName:(NSString *)fileName
                    fileMimeType:(NSString *)fileMimeType
                  uploadProgress:(BlockHTTPRequestUploadProgress)uploadProgress
                         success:(BlockHTTPRequestSuccess)success
                         failure:(BlockHTTPRequestFailure)failure
{
    AFHTTPRequestOperation *operation;
    operation = [__helper POST:urlPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:file name:fileKey fileName:fileName mimeType:fileMimeType];
        
    } success:success failure:failure];
    
    [operation setUploadProgressBlock:uploadProgress];
    return operation;
}
- (AFHTTPRequestOperation *)POST:(NSString *)urlPath
                           param:(NSDictionary *)params
                       fileArray:(NSArray *)fileArray
                  uploadProgress:(BlockHTTPRequestUploadProgress)uploadProgress
                         success:(BlockHTTPRequestSuccess)success
                         failure:(BlockHTTPRequestFailure)failure
{
    __block  AFHTTPRequestOperation *operation;
    
    [fileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        operation = [__helper POST:urlPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSDictionary *fileDic = obj;
            [formData appendPartWithFileData:[fileDic objectForKey:@"fileData"] name:[fileDic objectForKey:@"fileKey"] fileName:[fileDic objectForKey:@"fileName"] mimeType:[fileDic objectForKey:@"fileMimeType"]];
            
        } success:success failure:failure];
        
    }];
    [operation setUploadProgressBlock:uploadProgress];
    return operation;
    
}
#pragma mark - DownBreakResume

- (AFHTTPRequestOperation *)GET:(NSString *)urlPath
                          param:(NSDictionary *)params
                       filePath:(NSString *)filePath
                   shouldResume:(BOOL)shouldResume
               downloadProgress:(AFDownloadProgressBlock)downloadProgress
                        success:(BlockHTTPRequestSuccess)success
                        failure:(BlockHTTPRequestFailure)failure;
{

    // add parameters to URL;
    NSString *filteredUrl = [NSString urlStringWithOriginUrlString:urlPath appendParameters:params];

    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:[NSURL URLWithString:filteredUrl]];

    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:requestUrl
                                                                                     targetPath:filePath shouldResume:shouldResume];
    [operation setProgressiveDownloadProgressBlock:downloadProgress];
    [operation setCompletionBlockWithSuccess:success failure:failure];

    [__helper.operationQueue addOperation:operation];
    return operation;
}

#pragma mark - NetworkState
//监控网络变化
- (void)startMonitorNetworkStateChange
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *reachabilityManager = __helper.reachabilityManager;
    
    NSOperationQueue *operationQueue = __helper.operationQueue;
    // 2.设置网络状态改变后的处理
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                PHLog(@"未知网络");
                self.networkReachabilityStatus = PHNetworkReachabilityStatusUnknown;
                [operationQueue setSuspended:YES];
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                PHLog(@"没有网络(断网)");
                self.networkReachabilityStatus = PHNetworkReachabilityStatusNotReachable;
                
                [operationQueue setSuspended:YES];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                self.networkReachabilityStatus = PHNetworkReachabilityStatusReachableViaWWAN;
                
                if(self.wifiOnlyMode)
                {
                    operationQueue.maxConcurrentOperationCount = 0;
                    [operationQueue setSuspended:YES];
                    
                }
                else
                {
                    operationQueue.maxConcurrentOperationCount = 2;
                    [operationQueue setSuspended:NO];
                    
                }
                
                PHLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                self.networkReachabilityStatus = PHNetworkReachabilityStatusReachableViaWiFi;
                operationQueue.maxConcurrentOperationCount = 6;
                [operationQueue setSuspended:NO];
                PHLog(@"WIFI");
                break;
        }
    }];
    
    // 3.开始监控
    [reachabilityManager startMonitoring];
}

#pragma mark - urlCache
//cache
- (AFHTTPRequestOperation *)GET:(NSString *)urlPath
                          param:(NSDictionary *)params
                withCachePolicy:(PHURLCachePolicy)cachePolicy
                        onCache:(BlockHTTPRequestCache)onCache
                        success:(BlockHTTPRequestSuccess)success
                        failure:(BlockHTTPRequestFailure)failure
{
    NSURLRequest *request;
    switch (cachePolicy) {
        case 0:
            request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlPath] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:self.requestTimeoutInterval];
            break;

        case 1:
            request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlPath] cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:self.requestTimeoutInterval];
            break;
        case 2:
            if ([self checkCacheTime] == YES) {
                request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlPath] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:self.requestTimeoutInterval];
            }
            else
            {
                request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlPath] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:self.requestTimeoutInterval];
            }

            break;
            
        default:
            break;
    }

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [__helper.operationQueue addOperation:operation];
    return operation;
}
//文件创建时间
- (int)cacheFileDuration {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // get file attribute
    NSError *attributesRetrievalError = nil;
    NSString *path = nil;
    path = [NSString stringWithFormat:@"%@/%@",[PHSandbox libCachePath],AppBuddleID];
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path
                                                             error:&attributesRetrievalError];
    if (!attributes) {
        return -1;
    }
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return seconds;
}
//检测缓存时间是否过期
- (BOOL)checkCacheTime
{
    // check cache time
    int seconds = [self cacheFileDuration];
    if (seconds < 0 || seconds > [self cacheTimeInSeconds]) {
        return NO;
    }
    return YES;
}
@end
