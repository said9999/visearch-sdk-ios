//
//  CameraOverlayViewController.h
//  VisenzeDemo
//
//  Created by Yaoxuan on 3/24/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraOverlayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *imagePreview;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic) UIImage *capturedImage;

- (IBAction)shootClicked:(id)sender;
- (IBAction)backClicked:(id)sender;
- (IBAction)albumButtonClicked:(id)sender;

@end
 