//
//  CatsCollectionViewController.m
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "CatsCollectionViewController.h"
#import "CatsPresenter.h"
#import "CatCollectionViewCell.h"
#import "Cat.h"
#import "UIImageView+LoadWithURL.h"
#import <Photos/Photos.h>
#import "PreviewViewController.h"

@interface CatsCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) CatsPresenter *presenter;
@property (copy, nonatomic) NSString *apiKey;
//4322d88c-f61c-431a-9880-2888a7f9d090

@end

@interface RandomCatsViewController : CatsCollectionViewController

@end

@interface MyCatsViewController : CatsCollectionViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation CatsCollectionViewController

static NSString * const reuseIdentifier = @"CellID";

- (void)startLoading {
    [NSException raise:NSInternalInconsistencyException
                format:@"You have not implemented %@ in %@", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

- (void)configureAppearance {
    [NSException raise:NSInternalInconsistencyException
    format:@"You have not implemented %@ in %@", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

- (instancetype)initWithType:(ViewControllerType)type {
    self = nil;
    
    if (type == RandomCats) {
        self = [[RandomCatsViewController alloc] initWithNibName:@"CatsCollectionViewController" bundle:nil];
    } else if (type == MyCats) {
        self = [[MyCatsViewController alloc] initWithNibName:@"CatsCollectionViewController" bundle:nil];
    }
    self.apiKey =  [[NSUserDefaults standardUserDefaults] objectForKey:@"API key"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.collectionView registerNib:[UINib nibWithNibName:@"CatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.presenter = [[CatsPresenter alloc] init];
    [self configureAppearance];
//    [self startLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startLoading];
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.presenter.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Cat *cat = self.presenter.catsArray[indexPath.item];

    [cell.activityIndicator startAnimating];

    [cell.imageView loadImageWithUrl:cat.imageURL andPlaceholder:[UIImage imageNamed:@"kitty"] completion:^(UIImage * image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageView setImage:image];
            [cell.activityIndicator stopAnimating];
        });
    }];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Cat *cat = self.presenter.catsArray[indexPath.item];
    [self presentViewController:[[PreviewViewController alloc] initWithCat:cat] animated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
    });
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(self.collectionView.frame.size.width , self.collectionView.frame.size.width);
}

#pragma mark - Private

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                            message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end


@implementation RandomCatsViewController

#pragma mark - CatsLoadingProtocol

- (void)configureAppearance {
    self.title = @"Random cats";
}

- (void)startLoading {
    [self.presenter getRandomCatsWithCompletion:^(NSArray *array, NSError * error){
        if (error) {
            [self showAlertWithMessage:error.localizedDescription];
            return;
        }
        [self.collectionView reloadData];
    }];
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.presenter.count > 1) {
        if(indexPath.row == self.presenter.count - 1) {
            [self.presenter getRandomCatsWithCompletion:^(NSArray *array, NSError * error) {
                if (error) {
                    [self showAlertWithMessage:error.localizedDescription];
                    return;
                }
                [self.collectionView reloadData];
            }];
        }
    }
}

@end


@implementation MyCatsViewController

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
                [self.collectionView reloadData];
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

