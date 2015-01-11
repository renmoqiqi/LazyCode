//
//  NSDictionary+PH.h
//  LazyCode
//
//  Created by penghe on 15/1/9.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark -

typedef NSDictionary *	(^NSDictionaryAppendBlock)( NSString * key, id value );

#pragma mark -

//. 返回一个对象的类型名称

#undef	CONVERT_PROPERTY_CLASS
#define	CONVERT_PROPERTY_CLASS( __name, __class ) \
+ (Class)convertPropertyClassFor_##__name \
{ \
return NSClassFromString( [NSString stringWithUTF8String:#__class] ); \
}

#pragma mark -

@interface NSDictionary (PH)
@property (nonatomic, readonly) NSDictionaryAppendBlock	APPEND;



@end

@interface NSMutableDictionary(PH)

@property (nonatomic, readonly) NSDictionaryAppendBlock	APPEND;

+ (NSMutableDictionary *)nonRetainingDictionary;



@end
