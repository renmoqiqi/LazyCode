//
//  NSObject+PH.h
//  LazyCode
//
//  Created by penghe on 15/1/9.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PH)
- (NSInteger)asInteger;
- (float)asFloat;
- (BOOL)asBool;

- (NSNumber *)asNSNumber;
- (NSString *)asNSString;
- (NSDate *)asNSDate;
- (NSData *)asNSData;	// TODO
- (NSArray *)asNSArray;
- (NSMutableArray *)asNSMutableArray;
- (NSDictionary *)asNSDictionary;
- (NSMutableDictionary *)asNSMutableDictionary;

@end
