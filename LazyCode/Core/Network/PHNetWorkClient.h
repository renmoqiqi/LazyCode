//
//  PHNetWorkClient.h
//  LazyCode
//
//  Created by penghe on 15/1/12.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@class AFDownloadRequestOperation;

//几种请求方式
typedef NS_ENUM(NSInteger, PHHttpRequestType) {
    PHHttpRequestGet,
    PHHttpRequestPost,
    PHHttpRequestDelete,
    PHHttpRequestPut,
};
//requestSerializer 的几种方式 这里用常用两种
typedef NS_ENUM(NSInteger , PHRequestSerializerType) {
    PHRequestSerializerTypeHTTP = 0,
    PHRequestSerializerTypeJSON,
};
/**
 url 缓存
 */
typedef enum : NSUInteger {
    // 不使用缓存
    URLCachePolicyNone = 0,
    // 忽略缓存 == 不适用缓存
    URLCachePolicyIgnoringLocalCacheData = URLCachePolicyNone,

    // 数据请求失败时(无网络时首页非空，或者某些离线策略)使用缓存
    URLCachePolicyReturnCacheDataOnError,

    //使用缓存（不管它是否过期），如果缓存中没有，那从网络加载吧.如果缓存过期则从新请求
    URLCachePolicyReturnCacheDataAndRequestNetwork,

}PHURLCachePolicy;
#pragma mark - block

/**
 *  HTTP/HTTPs succeed block
 *  HTTP/HTTPs failed block
 */
typedef void (^BlockHTTPRequestSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^BlockHTTPRequestFailure)(AFHTTPRequestOperation *operation, NSError *error);

/**
 *  请求的缓存block
 *
 *  @param operation      当前请求的opeation
 *  @param responseObject 返回的对象
 *  @param cachePolicy    需要缓存的选择
 */
typedef void (^BlockHTTPRequestCache)(AFHTTPRequestOperation *operation, id responseObject, PHURLCachePolicy cachePolicy);


/**
 *  download progress block
 *  upload progress block
 */
typedef void (^AFDownloadProgressBlock)(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);
typedef void (^BlockHTTPRequestUploadProgress)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);





@interface PHNetWorkClient : AFHTTPRequestOperationManager

//请求超时时间
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

//发送类型枚举
@property (nonatomic, assign) PHRequestSerializerType SerializerType;

//手机网络如果设置YES则不请求数据
@property (assign, nonatomic) BOOL wifiOnlyMode;

//缓存过期时间秒计算
@property (assign, nonatomic) NSInteger cacheTimeInSeconds;
//有没有网络
@property (assign, nonatomic) BOOL online;
//单例
+ (instancetype)sharedClient;

#pragma mark

/**
 *  封装的GET请求
 *
 *  @param urlPath            请求的urlPath
 *  @param success            成功回调
 *  @param failure            失败回调
 *
 *  @return 已发送的request 可以为nil
 */
- (AFHTTPRequestOperation *)GET:(NSString *)urlPath
                          param:(NSDictionary *)params
                        success:(BlockHTTPRequestSuccess)success
                        failure:(BlockHTTPRequestFailure)failure;


/**
 *  封装的POST请求
 *
 *  @param urlPath            请求的urlPath
 *  @param success            成功回调
 *  @param failure            失败回调
 *
 *  @return 已发送的request 可以为nil
 */
- (AFHTTPRequestOperation *)POST:(NSString *)urlPath
                           param:(NSDictionary *)params
                         success:(BlockHTTPRequestSuccess)success
                         failure:(BlockHTTPRequestFailure)failure;

/**
 *  基本的文本参数请求网络
 *
 *  @param url        服务器API地址
 *  @param method     方法类型
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @return 已发送的request 可以为nil

 */
- (AFHTTPRequestOperation *)requestWithPath:(NSString *)urlPath
                 method:(PHHttpRequestType)requestType
             parameters:(id)parameters
                success:(BlockHTTPRequestSuccess)success
                failure:(BlockHTTPRequestFailure)failure;

#pragma mark

/**
 *  封装的POST请求,可以监控到上传文件的进度
 *
 *  @param urlPath            请求的urlPath
 *  @param uploadProgress     上传进度回调
 *  @param file               二进制文件
 *  @param formKey            图片key
 *  @param imageName          图片名字
 *  @param success            成功回调
 *  @param failure            失败回调
 *
 *  @return 已发送的request 可以为nil
 */
- (AFHTTPRequestOperation *)POST:(NSString *)urlPath
                           param:(NSDictionary *)params
                            file:(NSData *)file
                         formKey:(NSString *)formKey
                       imageName:(NSString *)imageName
                  uploadProgress:(BlockHTTPRequestUploadProgress)uploadProgress
                         success:(BlockHTTPRequestSuccess)success
                         failure:(BlockHTTPRequestFailure)failure;

/**
 *  封装的POST请求,可以监控到上传文件的进度
 *
 *  @param urlPath            请求的urlPath
 *  @param uploadProgress     上传进度回调
 *  @param fileDictionary     key 是 imageKey value 是图片二进制文件
 *  @param success            成功回调
 *  @param failure            失败回调
 *
 *  @return 已发送的request 可以为nil
 */
- (AFHTTPRequestOperation *)POST:(NSString *)urlPath
                           param:(NSDictionary *)params
                  fileDictionary:(NSDictionary *)fileDictionary
                  uploadProgress:(BlockHTTPRequestUploadProgress)uploadProgress
                         success:(BlockHTTPRequestSuccess)success
                         failure:(BlockHTTPRequestFailure)failure;

#pragma mark
/**
 *  封装的GET请求,可以监控下载文件的进度
 *
 *  @param urlPath            请求的urlPath
 *  @param downloadProgress   下载进度回调
 *  @param param              一些其他参数
 *  @param success            成功回调
 *  @param filePath           断点续传临时文件地址
 *  @param shouldResume       是否支持断点续传
 *  @param failure            失败回调

 *  @return 已发送的request 可以为nil
 */
- (AFHTTPRequestOperation *)GET:(NSString *)urlPath
                          param:(NSDictionary *)params
                       filePath:(NSString *)filePath
                   shouldResume:(BOOL)shouldResume
               downloadProgress:(AFDownloadProgressBlock)downloadProgress
                        success:(BlockHTTPRequestSuccess)success
                        failure:(BlockHTTPRequestFailure)failure;


// http cache  url as keys 需要服务器支持http1.1缓存规范
#pragma mark  

/**
 *  GET类型请求 缓存
 *
 *  @param urlPath     URL
 *  @param params      参数
 *  @param cachePolicy 需要的缓存类型
 *  @param onCache     cache block
 *  @param success     成功回调
 *  @param failure     失败回调
 *
 *  @return 返回request  可以为 nil
 */
- (AFHTTPRequestOperation *)GET:(NSString *)urlPath
                          param:(NSDictionary *)params
                withCachePolicy:(PHURLCachePolicy)cachePolicy
                        onCache:(BlockHTTPRequestCache)onCache
                        success:(BlockHTTPRequestSuccess)success
                        failure:(BlockHTTPRequestFailure)failure;

@end
