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
    CatsCollectionViewController *catsVC = [[CatsCollectionViewController alloc] initWithType:RandomCats apiKey:@""];
    
    [self.navigationController pushViewController:catsVC animated:YES];
}

- (IBAction)myCatsButtonTapped:(id)sender {
    
    if (![[NSBundle mainBundle] objectForInfoDictionaryKey:@"API key"]) {
        // Create UIAlertController instance
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter API key"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        // Configure text field
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"API key...";
        }];
        
        // Configure Done action
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
            NSString *enteredText = alertController.textFields.firstObject.text;
            if (enteredText.length > 0) {
//                [[NSBundle mainBundle] setValue:enteredText forKey:@"API key"];
                
                CatsCollectionViewController *catsVC = [[CatsCollectionViewController alloc] initWithType:MyCats apiKey:enteredText];
                [self.navigationController pushViewController:catsVC animated:YES];
            }
        }];
        
        // Configure Cancel action
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        // Add actions into alert controller
        [alertController addAction:doneAction];
        [alertController addAction:cancelAction];
        
        // Present alert controller
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
   
}
@end
