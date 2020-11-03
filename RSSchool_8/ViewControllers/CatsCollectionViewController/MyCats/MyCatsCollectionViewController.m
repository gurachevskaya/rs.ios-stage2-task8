//
//  MyCatsCollectionViewController.m
//  RSSchool_8
//
//  Created by Karina on 9/14/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "MyCatsCollectionViewController.h"

@interface MyCatsCollectionViewController () 

@end

@implementation MyCatsCollectionViewController

#pragma mark - CatsLoadingProtocol

- (void)configureAppearance {
    self.title = @"My cats";
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    
     UIBarButtonItem *plusItem = [[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self
                                      action:@selector(addCat)];
    UIBarButtonItem *preferencesItem = [[UIBarButtonItem alloc]
    initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain
                         target:self
                         action:@selector(showApiKeyAlert)];
    
    self.navigationItem.rightBarButtonItems = @[plusItem, preferencesItem];
}

- (void)startLoading {
    [self.presenter getUploadedCatsWithCompletion:^(NSArray *array, NSError * error){
        if (error) {
            [self showAlertWithMessage:error.localizedDescription];
            return;
        }
        [self.collectionView reloadData];
    }];
}


#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CatCollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [cell.successLabel setHidden:NO];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.presenter.count > 1) {
        if(indexPath.row == self.presenter.count - 1) {
            [self.presenter getUploadedCatsWithCompletion:^(NSArray *array, NSError * error){
                if (error) {
                    [self showAlertWithMessage:error.localizedDescription];
                    return;
                }
            }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *url = info[UIImagePickerControllerImageURL];
    NSString *fileName = url.lastPathComponent;
    
    [self.presenter uploadImage:image withName:fileName completion:^(NSArray * array, NSError * error) {
        if (error){
            [self showAlertWithMessage:error.localizedDescription];
            return;
        }
        if (!self.presenter.catsArray){
            self.presenter.catsArray = [NSMutableArray new];
        }
        [self.presenter.catsArray insertObject:array[0] atIndex:0];
        [self.collectionView reloadData];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)addCat {
    UIImagePickerController *imagePickController = [[UIImagePickerController alloc]init];
    imagePickController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickController.delegate = self;
    imagePickController.allowsEditing = NO;
    [self presentViewController:imagePickController animated:YES completion:nil];
}


- (void)showApiKeyAlert {
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"API key"];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Api-key editing" message:[NSString stringWithFormat:@"Current API key: %@", string] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter new Api-key";
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *key = alert.textFields[0].text;
        NSString *oldKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"API key"];
        if (key.length != 0 && ![key isEqualToString:oldKey]) {
        [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"API key"];
            self.presenter = [CatsPresenter new];
            [self startLoading];
            [self.collectionView reloadData];
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
