//
//  PHUserDefaults.h
//  LazyCode
//
//  Created by penghe on 15/1/11.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHCacheProtocol.h"

@interface PHUserDefaults : NSObject<PHCacheProtocol>

AS_SINGLETON(PHUserDefaults)

@end

@interface NSObject(PHUserDefaults)

// for key value

+ (id)userDefaultsRead:(NSString *)key;
- (id)userDefaultsRead:(NSString *)key;

+ (void)userDefaultsWrite:(id)value forKey:(NSString *)key;
- (void)userDefaultsWrite:(id)value forKey:(NSString *)key;

+ (void)userDefaultsRemove:(NSString *)key;
- (void)userDefaultsRemove:(NSString *)key;

// for object

+ (id)readObject;
+ (id)readObjectForKey:(NSString *)key;

+ (void)saveObject:(id)obj;
+ (void)saveObject:(id)obj forKey:(NSString *)key;

+ (void)removeObject;
+ (void)removeObjectForKey:(NSString *)key;


@end


