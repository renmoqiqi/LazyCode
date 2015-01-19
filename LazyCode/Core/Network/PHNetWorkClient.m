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
static NSString * const kClientAPIBaseURLString = @"";
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
    if (self.requestTimeoutInterval) {
       __helper.requestSerializer.timeoutInterval = self.requestTimeoutInterval;
    }
    if (self.SerializerType == PHRequestSerializerTypeHTTP) {
       __helper.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else
    {
        __helper.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    __helper.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

}
+ (instancetype)sharedClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __helper = [[self alloc] initWithBaseURL:[NSURL URLWithString:[[self class] baseUrl]]];
    });
    return __helper;
}

#pragma mark
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
        [self paramsSetting];
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
#pragma mark
#pragma mark -- urlTools
+ (NSString*)urlEncode:(NSString*)str {
    //different library use slightly different escaped and unescaped set.
    //below is copied from AFNetworking but still escaped [] as AF leave them for Rails array parameter which we don't use.
    //https://github.com/AFNetworking/AFNetworking/pull/555
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
}
+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
            value = [self urlEncode:value];
            [urlParametersString appendFormat:@"&%@=%@", key, value];
        }
    }
    return urlParametersString;
}

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *filteredUrl = originUrlString;
    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
    if (paraUrlString && paraUrlString.length > 0) {
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        } else {
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
        return filteredUrl;
    } else {
        return originUrlString;
    }
}

#pragma mark 
- (AFHTTPRequestOperation *)POST:(NSString *)urlPath
                           param:(NSDictionary *)params
                            file:(NSData *)file
                         formKey:(NSString *)formKey
                       imageName:(NSString *)imageName
                  uploadProgress:(BlockHTTPRequestUploadProgress)uploadProgress
                         success:(BlockHTTPRequestSuccess)success
                         failure:(BlockHTTPRequestFailure)failure
{
    [self paramsSetting];
    AFHTTPRequestOperation *operation;
    operation = [__helper POST:urlPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       [formData appendPartWithFileData:file name:formKey fileName:imageName mimeType:@"image/png"];
        
    } success:success failure:failure];

    [operation setUploadProgressBlock:uploadProgress];
    return operation;
}
- (AFHTTPRequestOperation *)POST:(NSString *)urlPath
                           param:(NSDictionary *)params
                  fileDictionary:(NSDictionary *)fileDictionary
                  uploadProgress:(BlockHTTPRequestUploadProgress)uploadProgress
                         success:(BlockHTTPRequestSuccess)success
                         failure:(BlockHTTPRequestFailure)failure
{
    [self paramsSetting];
  __block  AFHTTPRequestOperation *operation;
    NSArray *imageKeyArray = params.allKeys;
    [imageKeyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        operation = [__helper POST:urlPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:fileDictionary[obj] name:obj fileName:[NSString stringWithFormat:@"%dImage",idx] mimeType:@"image/png"];

        } success:success failure:failure];
        
    }];
    [operation setUploadProgressBlock:uploadProgress];
    return operation;

}
- (AFHTTPRequestOperation *)GET:(NSString *)urlPath
                          param:(NSDictionary *)params
                       filePath:(NSString *)filePath
                   shouldResume:(BOOL)shouldResume
               downloadProgress:(AFDownloadProgressBlock)downloadProgress
                        success:(BlockHTTPRequestSuccess)success
                        failure:(BlockHTTPRequestFailure)failure;
{

    [self paramsSetting];
    // add parameters to URL;
    NSString *filteredUrl = [[self class] urlStringWithOriginUrlString:urlPath appendParameters:params];

    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:[NSURL URLWithString:filteredUrl]];

    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:requestUrl
                                                                                     targetPath:filePath shouldResume:shouldResume];
    [operation setProgressiveDownloadProgressBlock:downloadProgress];
    [operation setCompletionBlockWithSuccess:success failure:failure];

    [__helper.operationQueue addOperation:operation];
    return operation;
}
@end
