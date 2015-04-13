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
        client = [[ViSearchClient alloc] initWithBaseUrl:nil accessKey:@"b2b376be9a7c63189dcc8a7b1e7f962c" secretKey:@"4bc4df401569831b69cd1a5d811d7c81"];
    });
    
    return client;
}

@end
