//
//  SearchClient.m
//  VisenzeDemo
//
//  Created by Yaoxuan on 13/4/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "SearchClient.h"


@implementation SearchClient

+ (ViSearchClient *)sharedInstance {
    static ViSearchClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[ViSearchClient alloc] initWithBaseUrl:nil accessKey:@"72a00824d883361de62ba6ad1819a21e" secretKey:@"dd9c554de2c7a0a3f833a403e10cf7b1"];
    });
    
    return client;
}

@end
