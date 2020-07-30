//
//  UIImageView+LoadWithURL.h
//  RSSchool_8
//
//  Created by Karina on 7/27/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (LoadWithURL)

- (void) loadImageWithUrl:(NSURL*)url andPlaceholder:(UIImage*)placeholder completion:(void(^)(UIImage *))completion;

@end

NS_ASSUME_NONNULL_END
