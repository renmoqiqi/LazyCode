//
//  PHFileCache.m
//  LazyCode
//
//  Created by penghe on 15/1/11.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "PHFileCache.h"

@implementation PHFileCache
{
    NSString *	_cachePath;
    NSString *	_cacheUser;
    NSFileManager *	_fileManager;
}
DEF_SINGLETON( PHFileCache );


- (id)init
{
    self = [super init];
    if ( self )
    {
        self.cacheUser = @"";
        self.cachePath = [NSString stringWithFormat:@"%@/%@/Cache/", [PHSandbox libCachePath], [PHSystermInfo appVersion]];

        _fileManager = [[NSFileManager alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    _fileManager = nil;

    self.cachePath = nil;
    self.cacheUser = nil;
}

- (NSString *)fileNameForKey:(NSString *)key
{
    NSString * pathName = nil;

    if ( self.cacheUser && [self.cacheUser length] )
    {
        pathName = [self.cachePath stringByAppendingFormat:@"%@/", self.cacheUser];
    }
    else
    {
        pathName = self.cachePath;
    }

    if ( NO == [_fileManager fileExistsAtPath:pathName] )
    {
        [_fileManager createDirectoryAtPath:pathName
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
    }

    return [pathName stringByAppendingString:key];
}

- (id)objectForKey:(id)key objectClass:(Class)aClass
{
    if (aClass != nil)
    {
        // 用的是AutoCoding里的方法
        return [aClass objectWithContentsOfFile:[self fileNameForKey:key]];
    }
    else
    {
        return [self objectForKey:key];
    }
}

- (BOOL)hasObjectForKey:(id)key
{
    return [_fileManager fileExistsAtPath:[self fileNameForKey:key]];
}

- (id)objectForKey:(id)key
{
    return [NSData dataWithContentsOfFile:[self fileNameForKey:key]];
}

- (void)setObject:(id)object forKey:(id)key
{
    if ( nil == object )
    {
        [self removeObjectForKey:key];
    }
    else
    {
        //        NSData * data = [object asNSData];
        //        if ( data )
        //        {
        //            [data writeToFile:[self fileNameForKey:key]
        //                      options:NSDataWritingAtomic
        //                        error:NULL];
        //        }

        // 用的是AutoCoding里的方法

        [object writeToFile:[self fileNameForKey:key] atomically:YES];
        
    }
}

- (void)removeObjectForKey:(NSString *)key
{
    [_fileManager removeItemAtPath:[self fileNameForKey:key] error:nil];
}

- (void)removeAllObjects
{
    [_fileManager removeItemAtPath:_cachePath error:NULL];
    [_fileManager createDirectoryAtPath:_cachePath
            withIntermediateDirectories:YES
                             attributes:nil
                                  error:NULL];
}

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    [self setObject:obj forKey:key];
}


@end
