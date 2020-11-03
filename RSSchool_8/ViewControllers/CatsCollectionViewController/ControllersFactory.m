//
//  ControllersFactory.m
//  RSSchool_8
//
//  Created by Karina on 9/14/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "ControllersFactory.h"
#import "MyCatsCollectionViewController.h"
#import "RandomCatsCollectionViewController.h"

@implementation ControllersFactory

- (CatsCollectionViewController *)createControllerWithType:(ViewControllerType)type {
    switch (type) {
        case RandomCats:
            return [[RandomCatsCollectionViewController alloc] initWithNibName:@"CatsCollectionViewController" bundle:nil];
            break;
        case MyCats:
            return [[MyCatsCollectionViewController alloc] initWithNibName:@"CatsCollectionViewController" bundle:nil];
            break;
    }
}


@end
