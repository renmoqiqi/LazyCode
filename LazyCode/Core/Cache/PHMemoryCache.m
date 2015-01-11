//
//  PHMemoryCache.m
//  LazyCode
//
//  Created by penghe on 15/1/11.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "PHMemoryCache.h"

#undef	DEFAULT_MAX_COUNT
#define DEFAULT_MAX_COUNT	(48)

@implementation PHMemoryCache
{
    BOOL					_clearWhenMemoryLow;
    NSUInteger				_maxCacheCount;
    NSUInteger				_cachedCount;
    NSMutableArray *		_cacheKeys;
    NSMutableDictionary *	_cacheObjs;
}

DEF_SINGLETON( PHMemoryCache );

- (id)init
{
    self = [super init];
    if ( self )
    {
        _clearWhenMemoryLow = YES;
        _maxCacheCount = DEFAULT_MAX_COUNT;
        _cachedCount = 0;

        _cacheKeys = [[NSMutableArray alloc] init];
        _cacheObjs = [[NSMutableDictionary alloc] init];

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryCacheNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_cacheObjs removeAllObjects];

    [_cacheKeys removeAllObjects];

}

- (BOOL)hasObjectForKey:(id)key
{
    return [_cacheObjs objectForKey:key] ? YES : NO;
}

- (id)objectForKey:(id)key
{
    return [_cacheObjs objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key
{
    if ( nil == key )
        return;

    if ( nil == object )
        return;

    id cachedObj = [_cacheObjs objectForKey:key];
    if ( cachedObj == object )
        return;

    _cachedCount += 1;

    if ( _maxCacheCount > 0 )
    {
        while ( _cachedCount >= _maxCacheCount )
        {
            NSString * tempKey = [_cacheKeys objectAtIndex:0];
            if ( tempKey )
            {
                [_cacheObjs removeObjectForKey:tempKey];
                [_cacheKeys removeObjectAtIndex:0];
            }

            _cachedCount -= 1;
        }
    }

    [_cacheKeys addObject:key];
    [_cacheObjs setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    if ( [_cacheObjs objectForKey:key] )
    {
        [_cacheKeys removeObjectIdenticalTo:key];
        [_cacheObjs removeObjectForKey:key];

        _cachedCount -= 1;
    }
}

- (void)removeAllObjects
{
    [_cacheKeys removeAllObjects];
    [_cacheObjs removeAllObjects];

    _cachedCount = 0;
}

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    [self setObject:obj forKey:key];
}

#pragma mark -

- (void)handleMemoryCacheNotification:(NSNotification *)notification
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    if ([notification.name isEqualToString:UIApplicationDidReceiveMemoryWarningNotification])
    {
        if ( _clearWhenMemoryLow )
        {
            [self removeAllObjects];
        }
    }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}


@end
