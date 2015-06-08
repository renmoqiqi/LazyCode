//
//  PHSandbox.h
//  LazyCode
//
//  Created by penghe on 15/1/11.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHSandbox : NSObject
@property (nonatomic, readonly, copy) NSString *	appPath;
@property (nonatomic, readonly, copy) NSString *	docPath;
@property (nonatomic, readonly, copy) NSString *	libPrefPath;
@property (nonatomic, readonly, copy) NSString *	libCachePath;
@property (nonatomic, readonly, copy) NSString *	tmpPath;

AS_SINGLETON( PHSandbox )

+ (NSString *)appPath;		// 程序目录，不能存任何东西
+ (NSString *)docPath;		// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)libPrefPath;	// 配置目录，配置文件存这里
+ (NSString *)libCachePath;	// 缓存目录，系统在磁盘空间不足的情况下会删除里面的文件，ITUNES会删除
+ (NSString *)tmpPath;		// 缓存目录，APP退出后，系统可能会删除这里的内容

//是否存在目录
+ (BOOL)touch:(NSString *)path;
//是否存在文件
+ (BOOL)touchFile:(NSString *)file;
+ (NSString *)resPath:(NSString *)file;      // 返回资源目录的文件路径
//删除某个文件 file 沙盒路径
+ (BOOL)removeFile:(NSString *)file;
/**
 * 创建目录
 * api parameters 说明
 * aPath 目录路径
 */
+ (void)createDirectoryAtPath:(NSString *)aPath;

/**
 * 返回目下所有给定后缀的文件的方法
 * api parameters 说明
 *
 * direString 目录绝对路径
 * fileType 文件后缀名
 * operation (预留,暂时没用)
 */
+ (NSArray *)allFilesAtPath:(NSString *)direString type:(NSString*)fileType operation:(int)operation;


/**
 * 返回目录文件的size,单位字节
 * api parameters 说明
 *
 * filePath 目录路径
 * diskMode 是否是磁盘占用的size
 */
+ (uint64_t)sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode;

// 设置目录里的文件不备份
+ (BOOL)skipFileBackupForItemAtURL:(NSURL*)URL;

@end
