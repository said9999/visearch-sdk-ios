//
//  ImageCropViewController.m
//  VisenzeDemo
//
//  Created by Yaoxuan on 3/25/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "ImageCropViewController.h"
#import "SearchClient.h"
#import "ColorSearchViewController.h"

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
    self.displayView = [[UIImageView alloc] initWithImage:self.image];
    
    self.displayView.frame = self.imagePreview.bounds;
    CGPoint center = self.displayView.center;
    CGFloat width, height;
    if (self.image.size.height >= self.image.size.width) {
        height = self.displayView.frame.size.height;
        width = self.image.size.width / self.image.size.height * height;
    } else {
        width = self.displayView.frame.size.width;
        height = self.image.size.height / self.image.size.width * width;
    }
    
    CGRect frame = CGRectMake(0, 0, width, height);
    self.displayView.frame = frame;
    self.displayView.center = center;
    [self.displayView setUserInteractionEnabled:YES];
    
    [self.imagePreview addSubview:self.displayView];
    
    // Add scaler
    UIImage *img = [[UIImage imageNamed:@"scaler.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.scalerView = [[UIImageView alloc] initWithImage:img];
    [self.scalerView setUserInteractionEnabled:YES];
    
    CGRect scalerFrame = CGRectMake(0, 0, self.displayView.frame.size.width/2, self.displayView.frame.size.height/2);
    self.scalerView.frame = scalerFrame;

    // Add gesture to scaler
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.scalerView addGestureRecognizer:pan];
    
    [self.displayView addSubview:self.scalerView];
    self.scalerView.center = CGPointMake(self.displayView.bounds.size.width/2, self.displayView.bounds.size.height/2);
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
    UploadSearchParams *params = [[UploadSearchParams alloc] init];
    
    params.imageFile = self.image;
    params.box = [[Box alloc] initWithX1:self.scalerView.frame.origin.x y1:self.scalerView.frame.origin.y x2:self.scalerView.frame.origin.x + self.scalerView.frame.size.width y2:self.scalerView.frame.origin.y + self.scalerView.frame.size.height];
    NSLog(@"%d",params.box.x1);
    
    params.fl = @[@"im_url"];
    
    [[SearchClient sharedInstance] searchWithImageData:params success:^(NSInteger statusCode, ViSearchResult *data, NSError *error) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ColorSearchViewController *vc = [sb instantiateViewControllerWithIdentifier:@"color_search"];
        vc.searchResults = data.imageResultsArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:vc animated:YES completion:^{
                vc.collectionView.hidden = YES;
            }];
        });
    } failure:^(NSInteger statusCode, ViSearchResult *data, NSError *error) {
        ;
    }];
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
                x = MIN(MAX(0, _x), self.displayView.frame.size.width - recognizer.view.frame.size.width);
                y = MIN(MAX(0, _y), self.displayView.frame.size.height - recognizer.view.frame.size.height);
                
                tmpFrame.origin = CGPointMake(x, y);
                recognizer.view.frame = tmpFrame;
                break;
            case PanAtBottomRightCorner:
                tmpFrame.size = CGSizeMake(MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.width + translation.x), self.displayView.frame.size.width - tmpFrame.origin.x),
                                           MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.height + translation.y), self.displayView.frame.size.height - tmpFrame.origin.y));
                recognizer.view.frame = tmpFrame;
                break;
            case PanAtBottomLeftCorner:
                if (translation.x > 0 && tmpFrame.size.width == MINIMUM_WIDTH) {
                    return;
                }
                
                x = MIN(MAX(0, tmpFrame.origin.x + translation.x), tmpFrame.origin.x + tmpFrame.size.width - MINIMUM_WIDTH);
                y = tmpFrame.origin.y;
                width = tmpFrame.origin.x + tmpFrame.size.width - x;
                height = MIN(MAX(tmpFrame.size.height + translation.y, MINIMUM_WIDTH), self.displayView.frame.size.height - tmpFrame.origin.y);
                
                tmpFrame = CGRectMake(x, y, width, height);
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
                width =  MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.width + translation.x), self.displayView.frame.size.width - tmpFrame.origin.x);
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
                width = MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.width + translation.x), self.displayView.frame.size.width - tmpFrame.origin.x);
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
                height = MIN(MAX(MINIMUM_WIDTH, tmpFrame.size.height + translation.y), self.displayView.frame.size.height - tmpFrame.origin.y);
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
