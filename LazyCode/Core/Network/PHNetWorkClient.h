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

#pragma mark - block

/**
 *  HTTP/HTTPs succeed block
 *  HTTP/HTTPs failed block
 */
typedef void (^BlockHTTPRequestSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^BlockHTTPRequestFailure)(AFHTTPRequestOperation *operation, NSError *error);


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

#pragma mark  


@end
