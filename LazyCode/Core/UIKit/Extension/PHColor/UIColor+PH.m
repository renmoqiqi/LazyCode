//
//  UIColor+PH.m
//  LazyCode
//
//  Created by penghe on 15/5/3.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "UIColor+PH.h"

@implementation UIColor (PH)
+ (instancetype)colorFromHexString:(NSString *)hexString{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];

    [scanner scanHexInt:&rgbValue];
    return [[self class] colorFromHex:rgbValue];
}

+ (instancetype)colorFromHex:(int)hex{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

- (NSString *)hexString{
    NSArray *colorArray	= [self rgbaArray];
    int r = [colorArray[0] floatValue] * 255;
    int g = [colorArray[1] floatValue] * 255;
    int b = [colorArray[2] floatValue] * 255;
    NSString *red = [NSString stringWithFormat:@"%02x", r];
    NSString *green = [NSString stringWithFormat:@"%02x", g];
    NSString *blue = [NSString stringWithFormat:@"%02x", b];

    return [NSString stringWithFormat:@"#%@%@%@", red, green, blue];
}
- (NSArray *)rgbaArray
{
    // Takes a [self class] and returns R,G,B,A values in NSNumber form
    CGFloat r = 0;
    CGFloat g = 0;
    CGFloat b = 0;
    CGFloat a = 0;

    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)])
    {
        [self getRed:&r green:&g blue:&b alpha:&a];
    }
    else
    {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }

    return @[@(r), @(g), @(b), @(a)];
}
@end
