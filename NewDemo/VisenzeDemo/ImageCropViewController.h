//
//  ImageCropViewController.h
//  VisenzeDemo
//
//  Created by Yaoxuan on 3/25/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCropViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIView *imagePreview;

- (IBAction)backClicked:(id)sender;
- (IBAction)searchClicked:(id)sender;

@end
