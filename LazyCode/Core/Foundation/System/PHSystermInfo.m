//
//  PHSystermInfo.m
//  LazyCode
//
//  Created by penghe on 15/1/7.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "PHSystermInfo.h"
#import "OpenUDID.h"
#import "PHCommonDefine.h"
@implementation PHSystermInfo

DEF_SINGLETON(PHSystermInfo)

+ (NSString *)OSVersion
{
    return [NSString stringWithFormat:@"%@",[UIDevice currentDevice].systemVersion];
}
+ (NSString *)appVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    NSString * value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return value;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}
+ (NSString *)appShortVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    NSString * value = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return value;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}
+ (NSString *)deviceUUID
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    Class openUDID = NSClassFromString( @"OpenUDID" );
    if ( openUDID )
    {
        return [openUDID value];
    }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

    return nil;
}
+ (NSString *)appIdentifier
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    static NSString * __identifier = nil;
    if ( nil == __identifier )
    {
        __identifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    }
    return __identifier;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return @"";
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appSchema
{
    return [self appSchema:nil];
}

+ (NSString *)appSchema:(NSString *)name
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for ( NSDictionary * dict in array )
    {
        if ( name )
        {
            NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
            if ( nil == URLName )
            {
                continue;
            }

            if ( NO == [URLName isEqualToString:name] )
            {
                continue;
            }
        }

        NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        if ( nil == URLSchemes || 0 == URLSchemes.count )
        {
            continue;
        }

        NSString * schema = [URLSchemes objectAtIndex:0];
        if ( schema && schema.length )
        {
            return schema;
        }
    }
    
    return nil;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}
@end
