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
@property (strong, nonatomic) NSMutableArray<Cat *> *catsArray;

@property (copy, nonatomic) NSString *apiKey;
//4322d88c-f61c-431a-9880-2888a7f9d090

@end

@interface RandomCatsViewController : CatsCollectionViewController

@end

@interface MyCatsViewController : CatsCollectionViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation CatsCollectionViewController

static NSInteger page = 0;
static NSInteger count = 20;
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
    [self startLoading];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.catsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Cat *cat = self.catsArray[indexPath.item];
    
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
    Cat *cat = self.catsArray[indexPath.item];
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


@end


@implementation RandomCatsViewController

#pragma mark - CatsLoadingProtocol

- (void)configureAppearance {
    self.title = @"RandomCats";
}

- (void)startLoading {
    [self.presenter getCatsFromPage:page count:count completion:^(NSArray *array, NSError *error) {
        self.catsArray = [array mutableCopy];
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.catsArray.count > 1) {
        if(indexPath.row == self.catsArray.count - 1){
            if (count == 100) {
                page = page + 1;
                count = 20;
            }
            count = count + 20;
            [self.presenter getCatsFromPage:page count:count completion:^(NSArray *array, NSError *error) {
                if (array) {
                    [self.catsArray addObjectsFromArray:array];
                    [self.collectionView reloadData];
                }
            }];
        }
    }
}

@end


@implementation MyCatsViewController

#pragma mark - CatsLoadingProtocol

- (void)configureAppearance {
    self.title = @"Cats loading";
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self
                                      action:@selector(addCat)];
}

- (void)startLoading {

    [self.presenter getUploadedCatsFromPage:page count:count completion:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"Error");
        } else {
        self.catsArray = [array mutableCopy];
        [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CatCollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [cell.successLabel setHidden:NO];
    return cell;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *url = info[UIImagePickerControllerImageURL];
    NSString *fileName = url.lastPathComponent;
    
    [self.presenter uploadImage:image withName:fileName completion:^(NSArray * array, NSError * error) {
        if (error){
            [self showAlert];
         }
        if (self.catsArray){
//        [self.catsArray addObjectsFromArray:array];
        self.catsArray = [array mutableCopy];
        } else {
        self.catsArray = [NSMutableArray array];
        [self.catsArray addObjectsFromArray:array];
        }
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

#pragma mark - Private

- (void)showAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed. Image was too big, did not contain a Cat, was inappropriate, or the wrong file type."
                                                            message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
