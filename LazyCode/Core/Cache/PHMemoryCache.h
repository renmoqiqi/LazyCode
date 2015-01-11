//
//  PHMemoryCache.h
//  LazyCode
//
//  Created by penghe on 15/1/11.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHCacheProtocol.h"

@interface PHMemoryCache : NSObject<PHCacheProtocol>

@property (nonatomic, assign) BOOL					clearWhenMemoryLow;
@property (nonatomic, assign) NSUInteger			maxCacheCount;
@property (nonatomic, assign) NSUInteger			cachedCount;
@property (atomic, strong) NSMutableArray *			cacheKeys;
@property (atomic, strong) NSMutableDictionary *	cacheObjs;

AS_SINGLETON( PHMemoryCache );

@end
