//
//  UIColor+UIColor_ToHex.h
//  VisenzeDemo
//
//  Created by Yaoxuan on 7/4/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColor_ToHex)

+ (NSString *)toHexStringFrom:(UIColor *)color;
+ (UIColor *)colorFromHexString:(NSString *)colorString;

@end
