//
//  ImageCropViewController.h
//  VisenzeDemo
//
//  Created by Yaoxuan on 3/25/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleUIView.h"
#import "AbstractViewController.h"

@interface ImageCropViewController : AbstractViewController

@property (strong, nonatomic) UIImage *image; // original image bind to the controller
@property (strong, nonatomic) IBOutlet UIView *imagePreview; // A background view of display view.
@property (strong, nonatomic) UIImageView *displayView; // uiimageview of the original image
@property (strong, nonatomic) ScaleUIView *scalerView; // scale box view

- (IBAction)backClicked:(id)sender;
- (IBAction)searchClicked:(id)sender;

@end
