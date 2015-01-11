//
//  PHKeychain.h
//  LazyCode
//
//  Created by penghe on 15/1/11.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHCacheProtocol.h"

@interface PHKeychain : NSObject<PHCacheProtocol>
@property (nonatomic, copy) NSString * defaultDomain;

AS_SINGLETON( PHKeychain );

+ (void)setDefaultDomain:(NSString *)domain;

+ (NSString *)readValueForKey:(NSString *)key;
+ (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain;

+ (void)writeValue:(NSString *)value forKey:(NSString *)key;
+ (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain;

+ (void)deleteValueForKey:(NSString *)key;
+ (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain;

@end

@interface NSObject(PHKeychain)

+ (NSString *)keychainRead:(NSString *)key;
+ (void)keychainWrite:(NSString *)value forKey:(NSString *)key;
+ (void)keychainDelete:(NSString *)key;

- (NSString *)keychainRead:(NSString *)key;
- (void)keychainWrite:(NSString *)value forKey:(NSString *)key;
- (void)keychainDelete:(NSString *)key;

@end