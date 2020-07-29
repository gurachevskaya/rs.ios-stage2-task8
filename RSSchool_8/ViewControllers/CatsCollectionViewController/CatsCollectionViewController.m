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
#import "UIImageView+LoadWithURL.h"
#import <Photos/Photos.h>
#import "PreviewViewController.h"

@interface CatsCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIActivityIndicatorView *indicatorview;
@property (strong, nonatomic) CatsPresenter *presenter;
@property (strong, nonatomic) NSMutableArray<Cat *> *catsArray;

@end

@interface RandomCatsViewController : CatsCollectionViewController

@end

@interface MyCatsViewController : CatsCollectionViewController

@end

@implementation CatsCollectionViewController

static NSInteger page = 0;
static NSInteger count = 20;
static NSString * const reuseIdentifier = @"CellID";

- (instancetype)initWithType:(ViewControllerType)type {
    self = nil;
    if (type == RandomCats) {
        self = [[RandomCatsViewController alloc] initWithNibName:@"CatsCollectionViewController" bundle:nil];
    } else if (type == MyCats) {
        self = [[MyCatsViewController alloc] initWithNibName:@"CatsCollectionViewController" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.collectionView registerNib:[UINib nibWithNibName:@"CatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.presenter = [[CatsPresenter alloc] init];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                   target:self
                                   action:@selector(add)];
//    [self configureAppearance];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
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
    
    [cell.imageView loadImageWithUrl:cat.imageURL andPlaceholder:[UIImage imageNamed:@"kitty"]];
    
//    __weak typeof(self) weakSelf = self;
//    [self.presenter loadImageForURL:cat.imageURL completion:^(UIImage *image) {
//           dispatch_async(dispatch_get_main_queue(), ^{
//               weakSelf.catsArray[indexPath.item].image = image;
//               [weakSelf.collectionView reloadData];
////              [self.activityIndicator stopAnimating];
//           });
//       }];
    
//    [cell configureWithItem:cat];
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

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Cat *cat = self.catsArray[indexPath.item];
  

    [self presentViewController:[[PreviewViewController alloc] initWithCat:cat] animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(self.collectionView.frame.size.width , self.collectionView.frame.size.width);
}


@end


@implementation RandomCatsViewController


@end

@implementation MyCatsViewController

- (void)configureAppearance {
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
}

@end
