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
        client = [[ViSearchClient alloc] initWithBaseUrl:nil accessKey:@"0a7559fbaa885bba83e2b10e2bbdb09c" secretKey:@"451a70561e967f76313d512a43fbf2b3"];
    });
    
    return client;
}

@end
