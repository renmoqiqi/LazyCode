//
//  PHFileCache.h
//  LazyCode
//
//  Created by penghe on 15/1/11.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHCacheProtocol.h"

@interface PHFileCache : NSObject<PHCacheProtocol>

@property (nonatomic, copy) NSString *	cachePath;
@property (nonatomic, copy) NSString *	cacheUser;

AS_SINGLETON( PHFileCache );

- (NSString *)fileNameForKey:(NSString *)key;

//自定义类的加载 自动序列化里面的对象
- (id)objectForKey:(id)key objectClass:(Class)aClass;

@end
