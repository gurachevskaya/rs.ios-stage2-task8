//
//  CatsPresenter.h
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface CatsPresenter : NSObject

- (void)getCatsFromPage:(NSInteger)page count:(NSInteger)count completion:(void(^)(NSArray *, NSError *))completion;
- (void)loadImageForURL:(NSString *)url completion:(void (^)(UIImage *))completion;
- (void)cancelDownloadingForUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
