//
//  RandomCatsCollectionViewController.m
//  RSSchool_8
//
//  Created by Karina on 9/14/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "RandomCatsCollectionViewController.h"

@interface RandomCatsCollectionViewController () 
@end


@implementation RandomCatsCollectionViewController

#pragma mark - CatsLoadingProtocol

- (void)configureAppearance {
    self.title = @"Random cats";
}

- (void)startLoading {
    [self.presenter getRandomCatsWithCompletion:^(NSArray *array, NSError * error){
        if (error) {
            [self showAlertWithMessage:error.localizedDescription];
            return;
        }
        [self.collectionView reloadData];
    }];
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.presenter.count - 1) {
        [self.presenter getRandomCatsWithCompletion:^(NSArray *array, NSError * error) {
            if (error) {
                [self showAlertWithMessage:error.localizedDescription];
                return;
            }
            [self.collectionView reloadData];
        }];
    }
}

@end
