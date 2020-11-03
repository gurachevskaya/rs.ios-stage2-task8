//
//  ServerManager.h
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cat.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServerManager : NSObject

@property (strong, nonatomic, readonly) Cat* currentCat;

+ (ServerManager*) sharedManager;

//- (void)performGetRequestForUrl:(NSString *)stringUrl arguments:(NSDictionary *)arguments completion:(void(^)(NSDictionary *, NSError *))completion;
- (NSMutableURLRequest *)requestWithUrl:(NSString *)stringUrl arguments:(NSDictionary *)arguments;

- (void)performGetDataTaskWithRequest:request completion:(void(^)(NSDictionary *, NSError *))completion;
- (void)performHeadDataTaskWithRequest:request completion:(void(^)(NSInteger, NSError *))completion;

- (void)performNetworkEventRequestCallWithFileUpload :(UIImage *)image name:(NSString *)name forUrl:(NSString *)stringUrl completion:(void (^)(NSDictionary*, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
