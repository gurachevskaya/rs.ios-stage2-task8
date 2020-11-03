//
//  CatsPresenter.h
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Cat.h"

NS_ASSUME_NONNULL_BEGIN

@interface CatsPresenter : NSObject
@property (strong, nonatomic) NSMutableArray<Cat *> *catsArray;
@property (assign, nonatomic) NSInteger count;

@property (assign, nonatomic) NSInteger page;


- (void)getCatsFromPage:(NSInteger)page completion:(void(^)(NSArray *, NSError *))completion;

- (void)getUploadedCatsFromPage:(NSInteger)page completion:(void(^)(NSArray *, NSError *))completion;

- (void)uploadImage:(UIImage *)image withName:(NSString *)name completion:(void(^)(NSArray *, NSError *))completion;

- (void)getUploadedCatsWithCompletion:(void(^)(NSArray *, NSError *))completion;
- (void)getRandomCatsWithCompletion:(void(^)(NSArray *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
