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

- (void)performRequestWithMethod:(NSString *)method forUrl:(NSString *)stringUrl arguments:(NSDictionary *)arguments completion:(void(^)(NSDictionary *, NSError *))completion;

- (void)performNetworkEventRequestCallWithFileUpload :(UIImage *)image name:(NSString *)name forUrl:(NSString *)stringUrl completion:(void (^)(NSDictionary*, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
