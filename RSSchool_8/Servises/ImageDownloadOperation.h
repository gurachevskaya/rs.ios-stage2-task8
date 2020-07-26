//
//  ImageDownloadOperation.h
//  RSSchool_8
//
//  Created by Karina on 7/26/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageDownloadOperation : NSOperation

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void(^completion)(UIImage *);

- (instancetype)initWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
