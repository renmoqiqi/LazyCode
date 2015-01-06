//
//  PHDebug.h
//  LazyCode
//
//  Created by penghe on 15/1/6.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <Foundation/Foundation.h>
//系统版本 调试技巧
#if (DEBUG == 1)
#define PHLog(...) NSLog(__VA_ARGS__)
#else
#define PHLog(...)

#endif

@interface PHDebug : NSObject

@end
