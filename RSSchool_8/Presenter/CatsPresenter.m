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

NSInteger limit = 100;

@interface CatsPresenter ()

@property (strong, nonatomic) ServerManager *serverManager;

@end

@implementation CatsPresenter


- (instancetype)init {
    self = [super init];
    if (self) {
        _serverManager = [ServerManager sharedManager];
        _catsArray = [NSMutableArray array];
    }
    return self;
}


- (void)getCatsFromPage:(NSInteger)page completion:(void(^)(NSArray *, NSError *))completion {
    NSMutableArray *array = [NSMutableArray array];
    
    
    NSURLRequest *request = [self.serverManager requestWithUrl:@"https://api.thecatapi.com/v1/images/search" arguments:@{@"page" : [NSString stringWithFormat:@"%ld", page] ,@"limit" : [NSString stringWithFormat:@"%ld", limit], @"order" : @"ASC"}];
    
    [self.serverManager performGetDataTaskWithRequest:request completion:^(NSDictionary * dictionary, NSError * error) {
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
};


//- (void)getLimitWithPage:(NSInteger)page completion:(void(^)(NSInteger))completion {
//    NSURLRequest *request = [self.serverManager requestWithUrl:@"https://api.thecatapi.com/v1/images/search" arguments:@{@"page" : [NSString stringWithFormat:@"%ld", page] ,@"limit" : [NSString stringWithFormat:@"%ld", limit], @"order" : @"ASC"}];
//    
//    [self.serverManager performHeadDataTaskWithRequest:request completion:^(NSInteger responseLimit, NSError * error) {
//                
//        if (responseLimit < limit) {
//            completion(responseLimit);
//        } else {
//            completion(limit);
//        }
//    }];
//}


- (void)getUploadedCatsFromPage:(NSInteger)page completion:(void(^)(NSArray *, NSError *))completion {
    NSMutableArray *array = [NSMutableArray array];
    NSString *pageForRequest = [NSString stringWithFormat:@"%ld", page];
    
    NSURLRequest *request = [self.serverManager requestWithUrl:@"https://api.thecatapi.com/v1/images" arguments:@{@"page" : pageForRequest,@"limit" : [@(limit) stringValue], @"order" : @"DESC"}];
    
    [self.serverManager performGetDataTaskWithRequest:request completion:^(NSDictionary * dictionary, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(nil, error);
                return;
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
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:message forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"animal" code:200 userInfo:details];
                completion(nil, error);
                
            } else {
                Cat* cat = [[Cat alloc] initWithServerResponse:dictionary];
                [array addObject:cat];
                completion(array, nil);
            }
        });
    }];
}

- (NSInteger)count {
    return self.catsArray.count;
}

- (void)getUploadedCatsWithCompletion:(void(^)(NSArray *, NSError *))completion {
    [self updatePage];
    [self getUploadedCatsFromPage:self.page completion:^(NSArray *array, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        completion(array, nil);
    }];
}

- (void)getRandomCatsWithCompletion:(void(^)(NSArray *, NSError *))completion {
    [self updatePage];
    [self getCatsFromPage:self.page completion:^(NSArray *array, NSError *error) {
        if (error) {
            completion (nil, error);
            return;
        }
        [self fillCatsArrayWithArray:array];
        completion(array, nil);
    }];
}

- (void)fillCatsArrayWithArray:(NSArray *)array {
    if (array) {
        if (array.count == limit) {
            [self.catsArray addObjectsFromArray:array];
        } else {
            self.catsArray = [array mutableCopy];
        }
    }
}

- (void)updatePage {
        self.page = self.page + 1;
}

@end


