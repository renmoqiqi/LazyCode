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

#pragma mark - Enumerations

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

typedef NS_ENUM(NSInteger, PHNetworkReachabilityStatus) {
    PHNetworkReachabilityStatusUnknown          = -1, //未知
    PHNetworkReachabilityStatusNotReachable     = 0,  //没有网络
    PHNetworkReachabilityStatusReachableViaWWAN = 1,  //手机网络
    PHNetworkReachabilityStatusReachableViaWiFi = 2,  //Wi-Fi网络
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
#pragma mark - Block

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

#pragma mark - Properties


//请求超时时间
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

//发送类型枚举
@property (nonatomic, assign) PHRequestSerializerType SerializerType;

//手机网络如果设置YES则不请求数据
@property (assign, nonatomic) BOOL wifiOnlyMode;

//网络监控的结果是 Wi-Fi还是手机网络还是没有网络
@property (assign, nonatomic) PHNetworkReachabilityStatus networkReachabilityStatus;

//缓存过期时间秒计算
@property (assign, nonatomic) NSInteger cacheTimeInSeconds;

//单例
+ (instancetype)sharedClient;
//监控网络启动
- (void)startMonitorNetworkStateChange;

#pragma mark - Cancel Opration


//取消所有网络请求
- (void)callAllOperations;
/**
 *  取消某个/些正在发送的请求
 *
 *  @param method                可以是 GET/POST/DELETE/PUT
 *  @param url                   要取消的 url
 */
- (void)cancelHTTPOperationsWithMethod:(NSString *)method url:(NSString *)url;
#pragma mark - Request types

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

#pragma mark - Post Files

/**
 *  封装的POST请求,可以监控到上传文件的进度
 *
 *  @param urlPath            请求的urlPath
 *  @param uploadProgress     上传进度回调
 *  @param file               二进制文件
 *  @param fileKey            文件key
 *  @param fileName          文件原始名字
 *  @param fileMimeType      文件类型
 *  @param success            成功回调
 *  @param failure            失败回调
 *
 *  @return 已发送的request 可以为nil
 */
- (AFHTTPRequestOperation *)POST:(NSString *)urlPath
                           param:(NSDictionary *)params
                            file:(NSData *)file
                         fileKey:(NSString *)fileKey
                        fileName:(NSString *)fileName
                    fileMimeType:(NSString *)fileMimeType
                  uploadProgress:(BlockHTTPRequestUploadProgress)uploadProgress
                         success:(BlockHTTPRequestSuccess)success
                         failure:(BlockHTTPRequestFailure)failure;

/**
 *  封装的POST请求,可以监控到上传文件的进度
 *
 *  @param urlPath            请求的urlPath
 *  @param uploadProgress     上传进度回调
 *  @param fileDictionary     一个文件字典 fileData图片二进制数据 fileName 图片原始名字 fileMimeType 文件类型 fileKey 文件对应服务器的key
 *  @param success            成功回调
 *  @param failure            失败回调
 *
 *  @return 已发送的request 可以为nil
 */
- (AFHTTPRequestOperation *)POST:(NSString *)urlPath
                           param:(NSDictionary *)params
                       fileArray:(NSArray *)fileArray
                  uploadProgress:(BlockHTTPRequestUploadProgress)uploadProgress
                         success:(BlockHTTPRequestSuccess)success
                         failure:(BlockHTTPRequestFailure)failure;

#pragma mark - DownBreakResume
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
#pragma mark - urlCache

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
