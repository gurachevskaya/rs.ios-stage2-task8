//
//  CatsCollectionViewController.h
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatsPresenter.h"
#import "CatCollectionViewCell.h"


NS_ASSUME_NONNULL_BEGIN

@protocol CatsLoadingProtocol
- (void)startLoading;
- (void)configureAppearance;
@end

@interface CatsCollectionViewController : UICollectionViewController

@property (strong, nonatomic) CatsPresenter *presenter;
- (void)showAlertWithMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
