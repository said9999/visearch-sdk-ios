//
//  SearchClient.h
//  VisenzeDemo
//
//  Created by Yaoxuan on 13/4/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViSearchClient.h"

@class SearchClient;
@interface SearchClient : NSObject

+ (ViSearchClient *)sharedInstance;

@end
