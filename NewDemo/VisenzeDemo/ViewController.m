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
#import "ViSearchAPI.h"

@interface ViewController ()

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ViSearchAPI setupAccessKey:@"b2b376be9a7c63189dcc8a7b1e7f962c" andSecretKey:@"4bc4df401569831b69cd1a5d811d7c81"];
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
    cvc.colorList = @[@1,@2,@3,@4,@5,@6,@7,@8,@9];
    
    [self presentViewController:cvc animated:NO completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
