//
//  ColorSearchViewController.h
//  VisenzeDemo
//
//  Created by Yaoxuan on 6/4/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DisplayColor,
    DisplayResults
} ColorSearchState;

@interface ColorSearchViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *panelView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *secondCollectionView;
@property NSArray *colorList;
@property NSArray *searchResults;
@property (readonly) ColorSearchState state;

- (IBAction)backButtonClicked:(id)sender;
@end
