//
//  ViewController.m
//  VisenzeDemo
//
//  Created by Yaoxuan on 3/24/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "ViewController.h"
#import "CameraOverlayViewController.h"
#import "ImageCropViewController.h"
#import "ColorSearchViewController.h"
#import "UIColor+UIColor_ToHex.h"

@interface ViewController ()

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ImageButtonClicked:(id)sender {
    //check camera availability
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //return;
    };
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CameraOverlayViewController * vc = (CameraOverlayViewController *)[sb instantiateViewControllerWithIdentifier:@"camera_overlay"];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)colorButtonClicked:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ColorSearchViewController *cvc = (ColorSearchViewController *)[sb instantiateViewControllerWithIdentifier:@"color_search"];
    
    NSArray *colors = @[@"#000000",
                        @"#ffffff",
                        @"#d70216",
                        @"#fc6020",
                        @"#fdbe2c",
                        @"#dffd35",
                        @"#83fd31",
                        @"#00fd49",
                        @"#00b249",
                        @"#2afda2",
                        @"#2dfffe",
                        @"#1ba1fc",
                        @"#3167fb",
                        @"#2355fb",
                        @"#7e25fb",
                        @"#e85dfc",
                        @"#fc1ebd",
                        @"#fd1261",];
    

    NSMutableArray *colorList = [NSMutableArray array];
    for (NSString *colorString in colors) {
        [colorList addObject:[UIColor colorFromHexString:colorString]];
    }
    cvc.colorList = colorList;
    
    [self presentViewController:cvc animated:YES completion:nil];
}

#pragma mark - App Delegate

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
