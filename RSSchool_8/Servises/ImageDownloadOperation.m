//
//  ImageDownloadOperation.m
//  RSSchool_8
//
//  Created by Karina on 7/26/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "ImageDownloadOperation.h"

@interface ImageDownloadOperation ()

@property (nonatomic, copy) NSString *url;

@end

@implementation ImageDownloadOperation

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)main {
    __weak typeof(self) weakSelf = self;
    if (self.isCancelled) { return; }
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]
                                      dataTaskWithURL:url
                                      completionHandler:^(NSData *data,
                                                          NSURLResponse *response,
                                                          NSError * error) {
        if (weakSelf.isCancelled) { return; }
        if (!data) { return; }
        UIImage *image = [UIImage imageWithData:data];
        weakSelf.image = image;
        if (self.completion) {
            self.completion(image);
        }
    }];

    if (self.isCancelled) { return; }
    [dataTask resume];
}

@end
