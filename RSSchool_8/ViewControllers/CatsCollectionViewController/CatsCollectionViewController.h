//
//  CatsCollectionViewController.h
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, ViewControllerType) {
  RandomCats,
  MyCats
};


@protocol CatsLoadingProtocol

- (void)startLoading;
- (void)configureAppearance;

@end

@interface CatsCollectionViewController : UICollectionViewController <CatsLoadingProtocol>

- (instancetype)initWithType:(ViewControllerType)type;

@end

NS_ASSUME_NONNULL_END
