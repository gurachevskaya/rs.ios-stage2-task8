//
//  CatCollectionViewCell.m
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "CatCollectionViewCell.h"

@implementation CatCollectionViewCell

- (void)configureWithItem:(Cat *)cat {
    self.imageView.image = cat.image;
}

@end
