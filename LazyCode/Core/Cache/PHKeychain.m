//
//  PHKeychain.m
//  LazyCode
//
//  Created by penghe on 15/1/11.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "PHKeychain.h"

#undef	DEFAULT_DOMAIN
#define DEFAULT_DOMAIN	@"PHKeychain"

@interface PHKeychain ()
- (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain;
- (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain;
@end

@implementation PHKeychain

DEF_SINGLETON( PHKeychain )


- (id)init
{
    self = [super init];
    if ( self )
    {
        self.defaultDomain = DEFAULT_DOMAIN;
    }
    return self;
}

- (void)dealloc
{
    self.defaultDomain = nil;
}

+ (void)setDefaultDomain:(NSString *)domain
{
    [[PHKeychain sharedInstance] setDefaultDomain:domain];
}

+ (NSString *)readValueForKey:(NSString *)key
{
    return [[PHKeychain sharedInstance] readValueForKey:key andDomain:nil];
}

+ (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain
{
    return [[PHKeychain sharedInstance] readValueForKey:key andDomain:domain];
}

- (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain
{
    if ( nil == key )
        return nil;

    if ( NSNotFound != [key rangeOfString:@"/" options:NSCaseInsensitiveSearch].location )
    {
        NSUInteger	offset = 0;

        domain	= [key substringFromIndex:0 untilCharset:[NSCharacterSet characterSetWithCharactersInString:@"/"] endOffset:&offset];
        key		= [key substringFromIndex:offset];
    }

    if ( nil == domain )
    {
        domain = self.defaultDomain;
        if ( nil == domain )
        {
            domain = DEFAULT_DOMAIN;
        }
    }

    domain = [domain stringByAppendingString:[PHSystermInfo appIdentifier]];

    NSArray * keys = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil];
    NSArray * objects = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClassGenericPassword, key, domain, nil];

    NSMutableDictionary * query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];
    NSMutableDictionary * attributeQuery = [query mutableCopy];
    [attributeQuery setObject: (id) kCFBooleanTrue forKey:(__bridge id) kSecReturnAttributes];

    NSDictionary * attributeResult = NULL;
    CFTypeRef inTypeRef =  ( __bridge CFTypeRef ) attributeResult;
    OSStatus status = SecItemCopyMatching( (__bridge CFDictionaryRef)attributeQuery, &inTypeRef );

    if ( noErr != status )
        return nil;

    NSMutableDictionary * passwordQuery = [query mutableCopy];
    [passwordQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];

    NSData * resultData = nil;
    CFTypeRef inTypeRef2 =  ( __bridge CFTypeRef ) resultData;
    status = SecItemCopyMatching( (__bridge CFDictionaryRef)passwordQuery, &inTypeRef2 );

    if ( noErr != status )
        return nil;

    if ( nil == resultData )
        return nil;
    
    NSString * password = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    return password;
}

+ (void)writeValue:(NSString *)value forKey:(NSString *)key
{
    [[PHKeychain sharedInstance] writeValue:value forKey:key andDomain:nil];
}

+ (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain
{
    [[PHKeychain sharedInstance] writeValue:value forKey:key andDomain:domain];
}

- (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain
{
    if ( nil == key )
        return;

    if ( NSNotFound != [key rangeOfString:@"/" options:NSCaseInsensitiveSearch].location )
    {
        NSUInteger	offset = 0;

        domain	= [key substringFromIndex:0 untilCharset:[NSCharacterSet characterSetWithCharactersInString:@"/"] endOffset:&offset];
        key		= [key substringFromIndex:offset];
    }

    if ( nil == value )
    {
        value = @"";
    }

    if ( nil == domain )
    {
        domain = self.defaultDomain;
        if ( nil == domain )
        {
            domain = DEFAULT_DOMAIN;
        }
    }

    domain = [domain stringByAppendingString:[PHSystermInfo appIdentifier]];

    OSStatus status = 0;

    NSString * password = [PHKeychain readValueForKey:key andDomain:domain];
    if ( password )
    {
        if ( [password isEqualToString:value] )
            return;

        NSArray * keys = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, nil];
        NSArray * objects = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClassGenericPassword, domain, domain, key, nil];

        NSDictionary * query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObject:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge NSString *)kSecValueData] );
    }
    else
    {
        NSArray * keys = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, kSecValueData, nil];
        NSArray * objects = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClassGenericPassword, domain, domain, key, [value dataUsingEncoding:NSUTF8StringEncoding], nil];

        NSDictionary * query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
        status = SecItemAdd( (__bridge CFDictionaryRef)query, NULL);
    }
    
    if ( noErr != status )
    {
        PHLog(@"writeValue, status = %d", (int)status);
    }
}

+ (void)deleteValueForKey:(NSString *)key
{
    [[PHKeychain sharedInstance] deleteValueForKey:key andDomain:nil];
}

+ (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain
{
    [[PHKeychain sharedInstance] deleteValueForKey:key andDomain:domain];
}

- (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain
{
    if ( nil == key )
        return;

    if ( NSNotFound != [key rangeOfString:@"/" options:NSCaseInsensitiveSearch].location )
    {
        NSUInteger	offset = 0;

        domain	= [key substringFromIndex:0 untilCharset:[NSCharacterSet characterSetWithCharactersInString:@"/"] endOffset:&offset];
        key		= [key substringFromIndex:offset];
    }

    if ( nil == domain )
    {
        domain = self.defaultDomain;
        if ( nil == domain )
        {
            domain = DEFAULT_DOMAIN;
        }
    }

    domain = [domain stringByAppendingString:[PHSystermInfo appIdentifier]];

    NSArray * keys = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
    NSArray * objects = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClassGenericPassword, key, domain, kCFBooleanTrue, nil];

    NSDictionary * query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    SecItemDelete( (__bridge CFDictionaryRef)query );
}

- (BOOL)hasObjectForKey:(id)key
{
    id obj = [self readValueForKey:key andDomain:nil];
    return obj ? YES : NO;
}

- (id)objectForKey:(id)key
{
    return [self readValueForKey:key andDomain:nil];
}

- (void)setObject:(id)object forKey:(id)key
{
    [self writeValue:object forKey:key andDomain:nil];
}

- (void)removeObjectForKey:(id)key
{
    [self deleteValueForKey:key andDomain:nil];
}

- (void)removeAllObjects
{
    // TODO:
}

- (id)objectForKeyedSubscript:(id)key
{
    if ( nil == key || NO == [key isKindOfClass:[NSString class]] )
        return nil;
    
    return [self readValueForKey:key andDomain:nil];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    if ( nil == key || NO == [key isKindOfClass:[NSString class]] )
        return;
    
    if ( nil == obj )
    {
        [self deleteValueForKey:key andDomain:nil];
    }
    else
    {
        [self writeValue:obj forKey:key andDomain:nil];
    }
}


@end

@implementation NSObject(PHKeychain)

+ (NSString *)keychainRead:(NSString *)key
{
    return [PHKeychain readValueForKey:key andDomain:[[self class] description]];
}

+ (void)keychainWrite:(NSString *)value forKey:(NSString *)key
{
    [PHKeychain writeValue:value forKey:key andDomain:[[self class] description]];
}

+ (void)keychainDelete:(NSString *)key
{
    [PHKeychain deleteValueForKey:key andDomain:[[self class] description]];
}

- (NSString *)keychainRead:(NSString *)key
{
    return [PHKeychain readValueForKey:key andDomain:[[self class] description]];
}

- (void)keychainWrite:(NSString *)value forKey:(NSString *)key
{
    [PHKeychain writeValue:value forKey:key andDomain:[[self class] description]];
}

- (void)keychainDelete:(NSString *)key
{
    [PHKeychain deleteValueForKey:key andDomain:[[self class] description]];
}

@end
