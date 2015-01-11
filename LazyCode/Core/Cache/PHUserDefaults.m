//
//  PHUserDefaults.m
//  LazyCode
//
//  Created by penghe on 15/1/11.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "PHUserDefaults.h"

@implementation PHUserDefaults

DEF_SINGLETON( PHUserDefaults )

- (BOOL)hasObjectForKey:(id)key
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value ? YES : NO;
}

- (id)objectForKey:(NSString *)key
{
    if ( nil == key )
        return nil;

    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}

- (void)setObject:(id)value forKey:(NSString *)key
{
    if ( nil == key || nil == value )
        return;

    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeObjectForKey:(NSString *)key
{
    if ( nil == key )
        return;

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAllObjects
{
    [NSUserDefaults resetStandardUserDefaults];
}

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    if ( obj )
    {
        [self setObject:obj forKey:key];
    }
    else
    {
        [self removeObjectForKey:key];
    }
}

@end


@implementation NSObject(PHUserDefaults)

+ (NSString *)persistenceKey:(NSString *)key
{
    if ( key )
    {
        key = [NSString stringWithFormat:@"%@.%@", [self description], key];
    }
    else
    {
        key = [NSString stringWithFormat:@"%@", [self description]];
    }

    key = [key stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    key = [key stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];

    return key.uppercaseString;
}

+ (id)userDefaultsRead:(NSString *)key
{
    if ( nil == key )
        return nil;

    key = [self persistenceKey:key];

    return [[PHUserDefaults sharedInstance] objectForKey:key];
}

+ (void)userDefaultsWrite:(id)value forKey:(NSString *)key
{
    if ( nil == key || nil == value )
        return;

    key = [self persistenceKey:key];

    [[PHUserDefaults sharedInstance] setObject:value forKey:key];
}

+ (void)userDefaultsRemove:(NSString *)key
{
    if ( nil == key )
        return;

    key = [self persistenceKey:key];

    [[PHUserDefaults sharedInstance] removeObjectForKey:key];
}

- (id)userDefaultsRead:(NSString *)key
{
    return [[self class] userDefaultsRead:key];
}

- (void)userDefaultsWrite:(id)value forKey:(NSString *)key
{
    [[self class] userDefaultsWrite:value forKey:key];
}

- (void)userDefaultsRemove:(NSString *)key
{
    [[self class] userDefaultsRemove:key];
}

+ (id)readObject
{
    return [self readObjectForKey:nil];
}

+ (id)readObjectForKey:(NSString *)key
{
    key = [self persistenceKey:key];

    id value = [[PHUserDefaults sharedInstance] objectForKey:key];
    if ( value )
    {
        //return [self objectFromAny:value];
        return value;
    }

    return nil;
}

+ (void)saveObject:(id)obj
{
    [self saveObject:obj forKey:nil];
}

+ (void)saveObject:(id)obj forKey:(NSString *)key
{
    if ( nil == obj )
        return;

    key = [self persistenceKey:key];
    /*
     NSString * value = [obj objectToString];
     if ( value && value.length )
     {
     [[XYUserDefaults sharedInstance] setObject:value forKey:key];
     }
     else
     {
     [[XYUserDefaults sharedInstance] removeObjectForKey:key];
     }
     */
    if (obj) {
        [[PHUserDefaults sharedInstance] setObject:obj forKey:key];
    }else {
        [[PHUserDefaults sharedInstance] removeObjectForKey:key];
    }
}

+ (void)removeObject
{
    [self removeObjectForKey:nil];
}

+ (void)removeObjectForKey:(NSString *)key
{
    key = [self persistenceKey:key];
    
    [[PHUserDefaults sharedInstance] removeObjectForKey:key];
}

@end

