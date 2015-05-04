//
//  UIColor+PH.h
//  LazyCode
//
//  Created by penghe on 15/5/3.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <UIKit/UIKit.h>
//  RGB颜色
#define kRGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromHEX(hexValue) [UIColor colorFromHex:hexValue]
@interface UIColor (PH)
// 返回一个十六进制表示的颜色: @"FF0000" or @"#FF0000"
+ (instancetype)colorFromHexString:(NSString *)hexString;
// 返回颜色的十六进制string
- (NSString *)hexString;
// 返回一个十六进制表示的颜色: 0xFF0000
+ (instancetype)colorFromHex:(int)hex;
/**
 Creates an array of 4 NSNumbers representing the float values of r, g, b, a in that order.
 @return    NSArray
 */
- (NSArray *)rgbaArray;

@end
