//
//  UIColor+UIColor_ToHex.m
//  VisenzeDemo
//
//  Created by Yaoxuan on 7/4/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "UIColor+UIColor_ToHex.h"

@implementation UIColor (UIColor_ToHex)

+ (NSString *)toHexStringFrom:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

@end
