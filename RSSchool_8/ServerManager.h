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

//- (void) getCat:(NSString*) catID
//       onSuccess:(void(^)(Cat* cat)) success
//       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCatsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* cats)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)performGetRequestForUrl:(NSString *)stringUrl arguments:(NSDictionary *)arguments completion:(void(^)(NSDictionary *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
