//
//  PHCommonDefine.h
//  LazyCode
//
//  Created by penghe on 15/1/7.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#ifndef LazyCode_PHCommonDefine_h
#define LazyCode_PHCommonDefine_h

//系统版本 调试技巧
#if defined (DEBUG) && DEBUG == 1
#define PHLog(...) NSLog(__VA_ARGS__)
#else
#define PHLog(...)

#endif

// 单例模式
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;
//+ (void) purgeSharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}

#endif
