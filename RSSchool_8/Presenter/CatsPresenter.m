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

@end

@implementation CatsPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _serverManager = [ServerManager sharedManager];
    }
    return self;
}

- (void)getCatsFromPage:(NSInteger)page count:(NSInteger)count completion:(void(^)(NSArray *, NSError *))completion {
    NSMutableArray *array = [NSMutableArray array];
        
    [self.serverManager performRequestWithMethod:@"GET" forUrl:@"https://api.thecatapi.com/v1/images/search" arguments:@{@"page" : [NSString stringWithFormat:@"%ld", page] ,@"limit" : [NSString stringWithFormat:@"%ld", count], @"order" : @"ASC"} completion:^(NSDictionary *dictionary, NSError *error) {
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

- (void)getUploadedCatsFromPage:(NSInteger)page count:(NSInteger)count completion:(void(^)(NSArray *, NSError *))completion {
    NSMutableArray *array = [NSMutableArray array];
    NSString *pageForRequest = [NSString stringWithFormat:@"%ld", page];
    NSString *limitForRequest = [NSString stringWithFormat:@"%ld", count];

    [self.serverManager performRequestWithMethod:@"GET" forUrl:@"https://api.thecatapi.com/v1/images/upload" arguments:@{@"page" : pageForRequest,@"limit" : limitForRequest, @"order" : @"ASC"} completion:^(NSDictionary *dictionary, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(nil,error);
                NSLog(@"%@", [NSString stringWithFormat:@"Error: %@", error]);
                return;
            }
            
            NSNumber *message = dictionary[@"message"];
            if (message) {
                NSLog(@"%@", message);
                completion(nil, error);
            } else {
            for (NSDictionary* dict in dictionary) {
                Cat* cat = [[Cat alloc] initWithServerResponse:dict];
                [array addObject:cat];
            }
            completion(array, nil);
            }
        });
    }];
}

- (void)uploadImage:(UIImage *)image withName:(NSString *)name completion:(void(^)(NSArray *, NSError *))completion {
    
    [self.serverManager performNetworkEventRequestCallWithFileUpload:image name:name forUrl:@"https://api.thecatapi.com/v1/images/upload" completion:^(NSDictionary *dictionary, NSError * error) {
        NSMutableArray *array = [NSMutableArray array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(nil,error);
                NSLog(@"%@", [NSString stringWithFormat:@"Error: %@", error]);
                return;
            }
            NSNumber *message = dictionary[@"message"];
            if (message) {
                NSLog(@"%@", message);
                completion(nil, error);
            } else {
                Cat* cat = [[Cat alloc] initWithServerResponse:dictionary];
                [array addObject:cat];
            }
            completion(array, nil);
        });
    }];
}

@end
