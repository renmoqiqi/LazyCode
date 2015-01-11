//
//  NSDictionary+PH.m
//  LazyCode
//
//  Created by penghe on 15/1/9.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "NSDictionary+PH.h"
#import "NSObject+PH.h"

@implementation NSDictionary (PH)
@dynamic APPEND;

//- (NSDictionaryAppendBlock)APPEND
//{
//    NSDictionaryAppendBlock block = ^ NSDictionary * ( NSString * key, id value )
//    {
//        if ( key && value )
//        {
//            NSString * className = [[self class] description];
//
//            if ( [self isKindOfClass:[NSMutableDictionary class]] || [className isEqualToString:@"NSMutableDictionary"] || [className isEqualToString:@"__NSDictionaryM"] )
//            {
//                [(NSMutableDictionary *)self setObject:value atPath:key];
//                return self;
//            }
//            else
//            {
//                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self];
//                [dict setObject:value atPath:key];
//                return dict;
//            }
//        }
//
//        return self;
//    };
//
//    return [block copy];
//}




@end
#pragma mark -

// No-ops for non-retaining objects.
static const void *	__TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void			__TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) {};

#pragma mark -
@implementation NSMutableDictionary(PH)

@dynamic APPEND;

//- (NSDictionaryAppendBlock)APPEND
//{
//    NSDictionaryAppendBlock block = ^ NSDictionary * ( NSString * key, id value )
//    {
//        if ( key && value )
//        {
//            [self setObject:value atPath:key];
//        }
//
//        return self;
//    };
//
//    return [block copy];
//}

+ (NSMutableDictionary *)nonRetainingDictionary
{
    CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
    CFDictionaryValueCallBacks callbacks  = kCFTypeDictionaryValueCallBacks;
    callbacks.retain                      = __TTRetainNoOp;
    callbacks.release                     = __TTReleaseNoOp;

    return  (__bridge_transfer NSMutableDictionary*)CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks);
}

@end
