//
//  OptionsViewController.m
//  RSSchool_8
//
//  Created by Karina on 7/29/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "OptionsViewController.h"
#import "CatsCollectionViewController.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)randomCatsButtonTapped:(id)sender {
    
    CatsCollectionViewController *catsVC = [[CatsCollectionViewController alloc] initWithType:RandomCats];
    [self.navigationController pushViewController:catsVC animated:YES];
    
}

- (IBAction)myCatsButtonTapped:(id)sender {
    
    CatsCollectionViewController *catsVC = [[CatsCollectionViewController alloc] initWithType:MyCats];
      [self.navigationController pushViewController:catsVC animated:YES];
    
}
@end
