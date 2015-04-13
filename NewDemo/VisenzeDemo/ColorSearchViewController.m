//
//  ColorSearchViewController.m
//  VisenzeDemo
//
//  Created by Yaoxuan on 6/4/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "ColorSearchViewController.h"
#import "ViSearchAPI.h"
#import "UIColor+UIColor_ToHex.h"
#import "ColorSearchResultCell.h"
#import "SearchClient.h"

@interface ColorSearchViewController ()

@end

@implementation ColorSearchViewController {
    UIActivityIndicatorView  *av;
    NSMutableDictionary *imageUrlCache;
    dispatch_queue_t imgLoadQ;
    BOOL colorOnTop;
}

#pragma mark LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.secondCollectionView.delegate = self;
    self.secondCollectionView.dataSource = self;
    
    if (!self.searchResults) {
        self.searchResults = [NSArray array];
    }
    imageUrlCache = [NSMutableDictionary dictionary];
    
    _state = DisplayColor;
    colorOnTop = YES;
    
    av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    av.frame = CGRectMake(0, 0, 25, 25);
    imgLoadQ = dispatch_queue_create("img_load", DISPATCH_QUEUE_CONCURRENT);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collection/datasouce delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    if (collectionView == self.collectionView) {
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"color_search_cell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell = [self.secondCollectionView dequeueReusableCellWithReuseIdentifier:@"color_search_result_cell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor grayColor];
        
        dispatch_async(imgLoadQ, ^{
            ImageResult *result = [self.searchResults objectAtIndex:indexPath.row];
            NSURL *url = [NSURL URLWithString:result.url];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *img = [self cropImage:[[UIImage alloc] initWithData:data]];
                
                UIImageView *view = [[UIImageView alloc] initWithImage:img];
                CGRect frame = cell.bounds;
                frame.origin = CGPointMake(0, 0);
                view.frame = frame;
                
                NSLog(@"%@", [NSValue valueWithCGRect:view.frame]);
                
                [cell addSubview:view];
            });
        });
    }
    return cell;
}

- (UIImage *)cropImage:(UIImage *)image {
    CGRect rect;
    if (image.size.width >= image.size.height) {
        rect = CGRectMake((image.size.width - image.size.height) / 2, 0 , image.size.height, image.size.height);
    } else {
        rect = CGRectMake(0, (image.size.height - image.size.width) / 2, image.size.width, image.size.width);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    // Create new cropped UIImage
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return croppedImage;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        av.center = cell.contentView.center;
        [cell addSubview:av];
        [av startAnimating];
        
        ColorSearchParams *param = [ColorSearchParams new];
        param.color = [UIColor toHexStringFrom:cell.backgroundColor];
        param.fl = @[@"im_url"];
        
        [[SearchClient sharedInstance] searchWithColor:param success:^(NSInteger statusCode, ViSearchResult *data, NSError *error) {
            _state = DisplayResults;
            self.searchResults = data.imageResultsArray;
            
            [av performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //ui switch and reload
                [self flip];
                [self.secondCollectionView reloadData];
            });
        } failure:^(NSInteger statusCode, ViSearchResult *data, NSError *error) {
            [av stopAnimating];
        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%d", collectionView.hidden == YES);
    return (collectionView == self.collectionView) ? self.colorList.count : self.searchResults.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)
collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;

    size = self.collectionView.frame.size;
    size.width = floor((size.width - 20) / 3);
    size.height = size.width;
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark IBActions
- (IBAction)backButtonClicked:(id)sender {
    if (self.state == DisplayColor) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        _state = DisplayColor;
        [self flip];
    }
}

#pragma mark - Private 

- (void)flip {
    [UIView transitionWithView:self.panelView
                      duration:1.0
                       options:(colorOnTop ? UIViewAnimationOptionTransitionFlipFromRight :
                                UIViewAnimationOptionTransitionFlipFromLeft)
                    animations: ^{
                        if (colorOnTop) {
                            self.collectionView.hidden = true;
                            self.secondCollectionView.hidden = false;
                        } else {
                            self.collectionView.hidden = false;
                            self.secondCollectionView.hidden = true;
                        }
                    }
                    completion:^(BOOL finished) {
                        if (finished) {
                            colorOnTop = !colorOnTop;
                        }
                    }];
}
@end
