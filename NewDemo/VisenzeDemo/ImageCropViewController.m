//
//  ImageCropViewController.m
//  VisenzeDemo
//
//  Created by Yaoxuan on 3/25/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "ImageCropViewController.h"

typedef enum {
    PanAtTopLeftCorner,
    PanAtTopRightCorner,
    PanAtBottomLeftCorner,
    PanAtBottomRightCorner,
    PanAtTopBorder,
    PanAtBottomBorder,
    PanAtLeftBorder,
    PanAtRightBorder,
    PanAtCenter,
    PanAtNone
} PanPostition;

static CGFloat const MINIMUM_WIDTH = 100;

@interface ImageCropViewController ()

@end

@implementation ImageCropViewController {
    CGRect imgFrame;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    // Add captured image
    UIImageView *displayView = [[UIImageView alloc] initWithImage:self.image];
    
    displayView.frame = self.imagePreview.bounds;
    CGPoint center = displayView.center;
    CGFloat width, height;
    if (displayView.frame.size.height >= displayView.frame.size.width) {
        height = displayView.frame.size.height;
        width = self.image.size.width / self.image.size.height * height;
    } else {
        width = displayView.frame.size.width;
        height = self.image.size.height / self.image.size.width * width;
    }
    
    CGRect frame = CGRectMake(0, 0, width, height);
    displayView.frame = frame;
    displayView.center = center;
    
    [self.imagePreview addSubview:displayView];
    
    // Add scaler
    UIImage *img = [[UIImage imageNamed:@"scaler.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *scalerView = [[UIImageView alloc] initWithImage:img];
    [scalerView setUserInteractionEnabled:YES];
    
    CGRect scalerFrame = CGRectMake(0, 0, displayView.frame.size.width/2, displayView.frame.size.height/2);
    scalerView.frame = scalerFrame;
    scalerView.center = displayView.center;
    
    // Add gesture to scaler
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [scalerView addGestureRecognizer:pan];
    
    [self.imagePreview addSubview:scalerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - IBActions

- (IBAction)searchClicked:(id)sender {
    
}

- (IBAction)backClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Gesture

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    static PanPostition panPostion = PanAtNone;
    //[self adjustAnchorPointForGestureRecognizer:recognizer];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        panPostion = getPosition([recognizer locationInView:recognizer.view],
            recognizer.view.frame.size.width, recognizer.view.frame.size.height);
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateBegan) {
        CGRect tmpFrame;
        CGPoint translation = [recognizer translationInView:recognizer.view];
        tmpFrame = recognizer.view.frame;
        CGFloat x, y, width, height;
        switch (panPostion) {
            case PanAtCenter:
                NSLog(@"center");
                CGFloat _x = tmpFrame.origin.x + translation.x;
                CGFloat _y = tmpFrame.origin.y + translation.y;
                x = MIN(MAX(0, _x), self.imagePreview.frame.size.width - recognizer.view.frame.size.width);
                y = MIN(MAX(0, _y), self.imagePreview.frame.size.height - recognizer.view.frame.size.height);
                
                tmpFrame.origin = CGPointMake(x, y);
                recognizer.view.frame = tmpFrame;
                break;
            case PanAtBottomRightCorner:
                tmpFrame.size = CGSizeMake(MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.width + translation.x), self.imagePreview.frame.size.width - tmpFrame.origin.x),
                    MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.height + translation.y), self.imagePreview.frame.size.height - tmpFrame.origin.y));
                recognizer.view.frame = tmpFrame;
                break;
            case PanAtBottomLeftCorner:
                if (translation.x > 0 && tmpFrame.size.width == MINIMUM_WIDTH) {
                    return;
                }
                
                tmpFrame = CGRectMake(MAX(0, tmpFrame.origin.x + translation.x), tmpFrame.origin.y,
                    MAX(tmpFrame.size.width - translation.x, MINIMUM_WIDTH), MAX(tmpFrame.size.height + translation.y, MINIMUM_WIDTH));
                recognizer.view.frame = tmpFrame;
                break;
            case PanAtTopLeftCorner:
                NSLog(@"");
                x = MAX(0, MIN(tmpFrame.origin.x + translation.x, tmpFrame.origin.x + tmpFrame.size.width - MINIMUM_WIDTH));
                y = MAX(0, MIN(tmpFrame.origin.y + translation.y, tmpFrame.origin.y + tmpFrame.size.height - MINIMUM_WIDTH));
                width = tmpFrame.origin.x + tmpFrame.size.width - x;
                height = tmpFrame.origin.y + tmpFrame.size.height - y;
                
                tmpFrame = CGRectMake(x, y, width, height);
                recognizer.view.frame = tmpFrame;
                break;
            case PanAtTopRightCorner:
                NSLog(@"");
                height = MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.height - translation.y), tmpFrame.size.height + tmpFrame.origin.y);
                width =  MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.width + translation.x), self.imagePreview.frame.size.width - tmpFrame.origin.x);
                tmpFrame = CGRectMake(tmpFrame.origin.x, tmpFrame.origin.y + tmpFrame.size.height - height, width, height);
                
                recognizer.view.frame = tmpFrame;
                break;
            case PanAtLeftBorder:
                NSLog(@"");
                width = MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.width - translation.x), tmpFrame.size.width + tmpFrame.origin.x);
                x = tmpFrame.origin.x + tmpFrame.size.width - width;
                tmpFrame = CGRectMake(x, tmpFrame.origin.y, width, tmpFrame.size.height);
                
                recognizer.view.frame = tmpFrame;
                break;
            case PanAtRightBorder:
                NSLog(@"");
                width = MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.width + translation.x), self.imagePreview.frame.size.width - tmpFrame.origin.x);
                tmpFrame.size.width = width;
                
                recognizer.view.frame = tmpFrame;
                break;
            case PanAtTopBorder:
                NSLog(@"");
                height = MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.height - translation.y), tmpFrame.origin.y + tmpFrame.size.height);
                y = tmpFrame.size.height + tmpFrame.origin.y - height;
                
                tmpFrame.origin.y = y;
                tmpFrame.size.height = height;
                
                recognizer.view.frame = tmpFrame;
                break;
            case PanAtBottomBorder:
                NSLog(@"");
                height = MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.height + translation.y), self.imagePreview.frame.size.height - tmpFrame.origin.y);
                tmpFrame.size.height = height;
                
                recognizer.view.frame = tmpFrame;
                break;
            default:
                break;
        }
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    }

}

PanPostition getPosition(CGPoint position, CGFloat width, CGFloat height){
    CGFloat x = position.x;
    CGFloat y = position.y;
    
    PanPostition panPostion = PanAtNone;
    if (y >= height - 40 && y <= height + 10 && x >= width - 40 && x <= width + 10) {
        panPostion = PanAtBottomRightCorner;
    }
    else if (y >= height - 40 && y <= height + 10 && x >= -10 && x <= 40) {
        panPostion = PanAtBottomLeftCorner;
    }
    else if (y >= -10 && y <= 40 && x >= -10 && x <= 40) {
        panPostion = PanAtTopLeftCorner;
    }
    else if (y >= -10 && y <= 40 && x >= width - 40 && x <= width + 10) {
        panPostion = PanAtTopRightCorner;
    }
    else if (x >= 40 && x <= width -40 && y >= 40 && y <= height - 40) {
        panPostion = PanAtCenter;
    }
    else if (x <= 40) {
        panPostion = PanAtLeftBorder;
    }
    else if (y <= 40) {
        panPostion = PanAtTopBorder;
    }
    else if (x >= width - 40) {
        panPostion = PanAtRightBorder;
    }
    else if (y >= height - 40){
        panPostion = PanAtBottomBorder;
    }
    
    return panPostion;
}

@end
