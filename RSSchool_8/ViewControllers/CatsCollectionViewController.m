//
//  CatsCollectionViewController.m
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "CatsCollectionViewController.h"
#import "CatsPresenter.h"
#import "CatCollectionViewCell.h"
#import "Cat.h"

@interface CatsCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIActivityIndicatorView *indicatorview;
@property (strong, nonatomic) CatsPresenter *presenter;
@property (strong, nonatomic) NSMutableArray<Cat *> *catsArray;

@end

@implementation CatsCollectionViewController

static NSInteger page = 0;
static NSInteger count = 20;

static NSString * const reuseIdentifier = @"CellID";

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.collectionView registerNib:[UINib nibWithNibName:@"CatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.presenter = [[CatsPresenter alloc] init];
    [self.presenter getCatsFromPage:page count:count completion:^(NSArray *array, NSError *error) {
        self.catsArray = [array mutableCopy];
        [self.collectionView reloadData];
    }];

}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.catsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    Cat *cat = self.catsArray[indexPath.item];
    
    __weak typeof(self) weakSelf = self;
    [self.presenter loadImageForURL:cat.imageURL completion:^(UIImage *image) {
           dispatch_async(dispatch_get_main_queue(), ^{
               weakSelf.catsArray[indexPath.item].image = image;
               [weakSelf.collectionView reloadData];
//              [self.activityIndicator stopAnimating];
           });
       }];
    
    [cell configureWithItem:cat];
//
//    if (indexPath.item == self.catsArray.count) {
//        page ++;
//
//        [self.presenter getCatsFromPage:page count:count completion:^(NSArray * array, NSError * error) {
//            [self.catsArray addObjectsFromArray:array];
//        }];
//    }
//
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width * 1.173);

//    return  CGSizeMake(self.collectionView.frame.size.width , self.collectionView.frame.size.width);
}


@end
