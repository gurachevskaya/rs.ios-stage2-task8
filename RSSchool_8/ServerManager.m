//
//  ServerManager.m
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "ServerManager.h"

@interface ServerManager ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ServerManager


+ (ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (void) getCatsWithOffset:(NSInteger) offset count:(NSInteger) count onSuccess:(void(^)(NSArray* cats)) success onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
}


- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configutation = [NSURLSessionConfiguration defaultSessionConfiguration];

//        configutation.HTTPAdditionalHeaders = @{
//            @"Content-Type": @"application/json",
//            @"Accept": @"application/json",
//            @"User-Agent": @"iPhone 11 Pro Simulator, iOS 13.5.1"
//        };

        _session = [NSURLSession sessionWithConfiguration:configutation];
    }
    return _session;
}

- (void)performGetRequestForUrl:(NSString *)stringUrl arguments:(NSDictionary *)arguments completion:(void(^)(NSDictionary *, NSError *))completion {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:stringUrl];

        if (arguments) {
            NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray new];
            for(NSString *key in arguments.allKeys) {
                [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:arguments[key]]];
            }
            urlComponents.queryItems = [queryItems copy];
        }

        NSURL *url = urlComponents.URL;
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                completion(nil, error);
                return;
            }

            NSError *parsingError;
            NSDictionary *dictionary = [self parseJSONDAta:data error:&parsingError];

            if (parsingError) {
                completion(nil, parsingError);
                return;
            }

            completion(dictionary, nil);
        }];
        [dataTask resume];
    }

#pragma mark - Private methods

- (NSDictionary *)parseJSONDAta:(NSData *)data error:(NSError **)error {
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
}


@end
