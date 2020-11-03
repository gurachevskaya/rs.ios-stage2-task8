//
//  OptionsViewController.m
//  RSSchool_8
//
//  Created by Karina on 7/29/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "OptionsViewController.h"
#import "CatsCollectionViewController.h"
#import "ControllersFactory.h"

@interface OptionsViewController ()

@property (strong, nonatomic) ControllersFactory *factory;

@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.factory = [ControllersFactory new];
}

- (IBAction)randomCatsButtonTapped:(id)sender {
    CatsCollectionViewController *catsVC = [self.factory createControllerWithType: RandomCats];
    [self.navigationController pushViewController:catsVC animated:YES];
}

- (IBAction)myCatsButtonTapped:(id)sender {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"API key"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter API key"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"API key...";
        }];
        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
            NSString *enteredText = alertController.textFields.firstObject.text;
            if (enteredText.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:enteredText forKey:@"API key"];
                
            }
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:doneAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    CatsCollectionViewController *catsVC = [self.factory createControllerWithType:MyCats];
    [self.navigationController pushViewController:catsVC animated:YES];
}
@end
