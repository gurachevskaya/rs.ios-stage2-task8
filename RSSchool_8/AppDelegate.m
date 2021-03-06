//
//  AppDelegate.m
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "AppDelegate.h"
#import "CatsCollectionViewController.h"
#import "OptionsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [UINavigationBar appearance].tintColor = [UIColor blackColor];
        OptionsViewController *vc = [[OptionsViewController alloc] initWithNibName:@"OptionsViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = navigationController;
        [self.window makeKeyAndVisible];;
        return YES;
}



@end
