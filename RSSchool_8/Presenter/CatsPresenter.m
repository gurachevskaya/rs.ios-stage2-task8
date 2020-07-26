//
//  CatsPresenter.m
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "CatsPresenter.h"
#import "ServerManager.h"
#import "ImageDownloadOperation.h"


@interface CatsPresenter ()
@property (strong, nonatomic) ServerManager *serverManager;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSArray<NSOperation *> *> *operations;

@end

@implementation CatsPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _serverManager = [ServerManager sharedManager];
        _queue = [NSOperationQueue new];
        _operations = [NSMutableDictionary new];
    }
    return self;
}

- (void)getCatsFromPage:(NSInteger)page count:(NSInteger)count completion:(void(^)(NSArray *, NSError *))completion {
    NSMutableArray *array = [NSMutableArray array];
        
    [self.serverManager performGetRequestForUrl:@"https://api.thecatapi.com/v1/images/search" arguments:@{@"page" : [NSString stringWithFormat:@"%ld", page] ,@"limit" : [NSString stringWithFormat:@"%ld", count], @"order" : @"ASC"} completion:^(NSDictionary *dictionary, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(nil,error);
                NSLog(@"%@", [NSString stringWithFormat:@"Error: %@", error]);
                return;
            }
            for (NSDictionary* dict in dictionary) {
                Cat* cat = [[Cat alloc] initWithServerResponse:dict];
                [array addObject:cat];
            }
            completion(array, nil);
        });
    }];
}

- (void)loadImageForURL:(NSString *)url completion:(void (^)(UIImage *))completion {
    [self cancelDownloadingForUrl:url];
    ImageDownloadOperation *operation = [[ImageDownloadOperation alloc] initWithUrl:url];
    self.operations[url] = @[operation];
    operation.completion = ^(UIImage *image) {
        completion(image);
    };
    [self.queue addOperation:operation];
}

- (void)cancelDownloadingForUrl:(NSString *)url {
    NSArray<NSOperation *> *operations = self.operations[url];
    if (!operations) { return; }
    for (NSOperation *operation in operations) {
        [operation cancel];
    }
}

@end
