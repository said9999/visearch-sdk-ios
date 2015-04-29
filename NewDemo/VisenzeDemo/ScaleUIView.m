//
//  ScaleUIView.m
//  VisenzeDemo
//
//  Created by Yaoxuan on 29/4/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "ScaleUIView.h"

@implementation ScaleUIView

- (void)drawRect:(CGRect)rect {
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    [[UIColor clearColor] setFill];
    UIRectFill(CGRectMake(3, 3, rect.size.width - 6, rect.size.height - 6));
}

@end
