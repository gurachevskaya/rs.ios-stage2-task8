//
//  UIImageView+LoadWithURL.m
//  RSSchool_8
//
//  Created by Karina on 7/27/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "UIImageView+LoadWithURL.h"


@implementation UIImageView (LoadWithURL)

- (void)loadImageWithUrl:(NSURL *)url andPlaceholder:(UIImage *)placeholder {
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLCache* cache = [NSURLCache sharedURLCache];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSCachedURLResponse *cachedResponse = [cache cachedResponseForRequest:request];
        if (cachedResponse) {
            UIImage *image = [UIImage imageWithData:cachedResponse.data];
            [weakSelf setImageInMain:image];
        } else {
            [weakSelf setImageInMain:placeholder];
            
            NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    return;
                }
                NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
                [cache storeCachedResponse:cachedResponse forRequest:request];
                UIImage *image = [UIImage imageWithData:data];
                [weakSelf setImageInMain:image];
            }];
            [dataTask resume];
        }
    });
}

- (void) setImageInMain:(UIImage*)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImage:image];
    });
}

@end
