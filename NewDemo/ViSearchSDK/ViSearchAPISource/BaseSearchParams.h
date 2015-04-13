//
//  BaseSearchParams.h
//  ViSearch-iOS-SDK
//
//  Created by Shaohuan on 12/17/14.
//
//
#import <Foundation/Foundation.h>

@interface BaseSearchParams: NSObject

@property (atomic) int limit;
@property (atomic) int page;
@property (atomic) BOOL facet;
@property (atomic) int facetSize;
@property (atomic) NSArray *facetField;
@property (atomic) BOOL score;
@property (atomic) NSMutableDictionary *fq;
@property (atomic) NSArray *fl;
@property (atomic) BOOL queryInfo;
@property (atomic) NSDictionary *custom;
@property (atomic) float scoreMin;
@property (atomic) float scoreMax;

- (id)init;
- (NSDictionary*)toDict;
- (NSData*)httpPostBodyWithObject:(id)object;
@end