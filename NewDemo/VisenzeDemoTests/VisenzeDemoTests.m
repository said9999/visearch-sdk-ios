//
//  VisenzeDemoTests.m
//  VisenzeDemoTests
//
//  Created by Yaoxuan on 3/24/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SearchClient.h"

@interface VisenzeDemoTests : XCTestCase

@end

@implementation VisenzeDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    
    [self measureBlock:^{
        XCTestExpectation *expectation = [self expectationWithDescription:@"async"];
        __block int count = 0;
        // Put the code you want to measure the time of here.
        for (int i = 1 ; i < 2; i++) {
            UIImage *image = [UIImage imageNamed:[[NSString stringWithFormat:@"%d", 11] stringByAppendingString:@".jpg"]];
            
            UploadSearchParams *params = [UploadSearchParams new];
            params.imageFile = image;
            params.fl = @[@"im_url"];
            [[SearchClient sharedInstance] searchWithImageData:params success:^(NSInteger statusCode, ViSearchResult *data, NSError *error) {
                count++;
                if (count == 1) {
                    [expectation fulfill];
                }
                //NSLog(@"%@", data);
            } failure:^(NSInteger statusCode, ViSearchResult *data, NSError *error) {
                count++;
                if (count == 1) {
                    [expectation fulfill];
                }
            }];
        }
        
        [self waitForExpectationsWithTimeout:20 handler:^(NSError *error) {
            if (error) {
                NSLog(@"Time out error %@", error);
            }
        }];
    }];
}

- (NSData *)compressImage:(UIImage *)image maxWidth:(float)mWidth quality:(float)myQuality{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = mWidth;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = mWidth/maxHeight;
    
    if (actualHeight > maxHeight || actualWidth > mWidth) {
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = 1024 / [[UIScreen mainScreen] scale] / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = mWidth;
        }else{
            actualHeight = maxHeight;
            actualWidth = mWidth;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, myQuality);
    UIGraphicsEndImageContext();
    
    return imageData;
}

- (void)testImageUpload {
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        for (int i = 1 ; i < 11; i++) {
            UIImage *image = [UIImage imageNamed:[[NSString stringWithFormat:@"%d",11] stringByAppendingString:@".jpg"]];
            [self compressImage:image maxWidth:1200 quality:0.9];
        }

    }];
    
}

@end
