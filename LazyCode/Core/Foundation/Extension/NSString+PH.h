//
//  NSString+PH.h
//  LazyCode
//
//  Created by penghe on 15/1/9.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NSString *			(^NSStringAppendBlock)( id format, ... );
typedef NSString *			(^NSStringReplaceBlock)( NSString * string, NSString * string2 );

typedef NSMutableString *	(^NSMutableStringAppendBlock)( id format, ... );
typedef NSMutableString *	(^NSMutableStringReplaceBlock)( NSString * string, NSString * string2 );

@interface NSString (PH)

@property (nonatomic, readonly) NSStringAppendBlock		APPEND;
@property (nonatomic, readonly) NSStringAppendBlock		LINE;
@property (nonatomic, readonly) NSStringReplaceBlock	REPLACE;

@property (nonatomic, readonly) NSData *				data;
@property (nonatomic, readonly) NSDate *				date;

@property (nonatomic, readonly) NSString *				MD5;
@property (nonatomic, readonly) NSData *				MD5Data;


@property (nonatomic, readonly) NSString *				SHA1;

//返回NSString 包含所有的URL
- (NSArray *)allURLs;

- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding;
- (NSString *)urlByAppendingArray:(NSArray *)params;
- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding;
- (NSString *)urlByAppendingKeyValues:(id)first, ...;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict;
+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromArray:(NSArray *)array;
+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromKeyValues:(id)first, ...;

//URL 字符串 里面可能包含某些字符，比如‘$‘ ‘&’ ‘？’...等，这些字符在 URL 语法中是具有特殊语法含义的，
//比如 URL ：http://www.baidu.com/s?wd=%BD%AA%C3%C8%D1%BF&rsv_bp=0&rsv_spt=3&inputT=3512
//
//中 的 & 起到分割作用 等等，如果 你提供的URL 本身就含有 这些字符，就需要把这些字符 转化为 “%+ASCII” 形式，以免造成冲突。
- (NSString *)URLEncoding;
- (NSString *)URLDecoding;

//去掉两端的空格
- (NSString *)trim;
// 去掉首尾的 " '
- (NSString *)unwrap;
//根据count值 来拼接字符串
- (NSString *)repeat:(NSUInteger)count;
//把 // 替换成 /
- (NSString *)normalize;

- (BOOL)match:(NSString *)expression;
//数组里面是否有匹配的字符串
- (BOOL)matchAnyOf:(NSArray *)array;

//字符串为空
- (BOOL)empty;
//不为空
- (BOOL)notEmpty;

//两个字符串是否相等
- (BOOL)equal:(NSString *)other;
//字符串不相等
- (BOOL)isNot:(NSString *)other;
//是不是数组里面的一个元素
- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

- (BOOL)isNormal;		
- (BOOL)isTelephone;
- (BOOL)isUserName;
- (BOOL)isChineseUserName;
- (BOOL)isPassword;
- (BOOL)isEmail;
- (BOOL)isUrl;
- (BOOL)isIPAddress;

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string;
- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string endOffset:(NSUInteger *)endOffset;

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset;
- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;

//算固定宽或高返回计算的宽或高
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

+ (NSString *)fromResource:(NSString *)resName;
#pragma mark -
@end

@interface NSMutableString(PH)

@property (nonatomic, readonly) NSMutableStringAppendBlock	APPEND;
@property (nonatomic, readonly) NSMutableStringAppendBlock	LINE;
@property (nonatomic, readonly) NSMutableStringReplaceBlock	REPLACE;


@end
