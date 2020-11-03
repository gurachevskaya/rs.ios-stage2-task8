//
//  ControllersFactory.h
//  RSSchool_8
//
//  Created by Karina on 9/14/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatsCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ViewControllerType) {
  RandomCats,
  MyCats
};


@interface ControllersFactory : NSObject

- (CatsCollectionViewController *)createControllerWithType:(ViewControllerType)type;

@end

NS_ASSUME_NONNULL_END
