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

@end
