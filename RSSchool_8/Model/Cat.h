//
//  Cat.h
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface Cat : NSObject

@property (strong, nonatomic) NSString* catId;
@property (strong, nonatomic) NSString* imageURL;

@property (strong, nonatomic) UIImage *image;

- (id)initWithServerResponse:(NSDictionary*) responseObject;

@end

NS_ASSUME_NONNULL_END
