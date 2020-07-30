//
//  CatCollectionViewCell.h
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cat.h"

NS_ASSUME_NONNULL_BEGIN

@interface CatCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (void)configureWithItem:(Cat *)cat;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@end

NS_ASSUME_NONNULL_END
