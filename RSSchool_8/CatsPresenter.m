//
//  CatsPresenter.m
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "CatsPresenter.h"
#import "ServerManager.h"

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

- (void)getCats {
    
//    [self.serverManager performGetRequestForUrl:@"https://api.thecatapi.com/images/search" arguments:@{@"limit" : @10, } completion:<#^(NSDictionary * _Nonnull, NSError * _Nonnull)completion#>]
}



@end
