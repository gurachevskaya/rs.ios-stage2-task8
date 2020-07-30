//
//  PreviewViewController.m
//  RSSchool_8
//
//  Created by Karina on 7/27/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "PreviewViewController.h"
#import "UIImageView+LoadWithURL.h"


@interface PreviewViewController ()
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UILabel *savedLabel;

@property (strong,  nonatomic) UIImageView *fullImageView;
@property (strong, nonatomic) Cat *cat;
@end

@implementation PreviewViewController


- (instancetype)initWithCat:(Cat *)cat {
    self = [super init];
    if (self) {
        _cat = cat;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureFullImageView];
    [self configureCloseButton];
    [self configureSaveButton];
    [self configureSavedLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.closeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
        [self.closeButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:10],
        [self.closeButton.widthAnchor constraintEqualToConstant:40],
        [self.closeButton.heightAnchor constraintEqualToConstant:40],
        
        [self.saveButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.saveButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:10],
        [self.saveButton.widthAnchor constraintEqualToConstant:40],
        [self.saveButton.heightAnchor constraintEqualToConstant:40],
        
        [self.fullImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.fullImageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:10],
        
        [self.fullImageView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:10],
        [self.fullImageView.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor constant:10],
        [self.fullImageView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor],
        [self.fullImageView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.bottomAnchor],
        
        [self.savedLabel.centerXAnchor constraintEqualToAnchor:self.fullImageView.centerXAnchor],
        [self.savedLabel.centerYAnchor constraintEqualToAnchor:self.fullImageView.centerYAnchor],
    ]];
}

#pragma mark - UI Setup

- (void)configureFullImageView {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.fullImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.fullImageView];
    self.fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    [self.fullImageView loadImageWithUrl:self.cat.imageURL andPlaceholder:[UIImage imageNamed:@"kitty"] completion:^(UIImage * image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.fullImageView setImage:image];
        });
    }];
    self.fullImageView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)configureSaveButton {
    self.saveButton = [[UIButton alloc] init];
    [self.saveButton setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
    self.saveButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)configureCloseButton {
    if (@available(iOS 13.0, *)) {
        self.closeButton = [UIButton buttonWithType:UIButtonTypeClose];
    } else {
        self.closeButton = [[UIButton alloc] init];
        self.closeButton.backgroundColor = [UIColor whiteColor];
        [self.closeButton setTitle:@"X" forState:UIControlStateNormal];
        [self.closeButton setBackgroundColor:[UIColor grayColor]];
        self.closeButton.layer.cornerRadius = 20;
    }
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)configureSavedLabel {
    self.savedLabel = [[UILabel alloc] init];
    self.savedLabel.text = @"Saved!";
    self.savedLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:30.0];
    self.savedLabel.textColor = [UIColor whiteColor];
    self.savedLabel.hidden = YES;
    [self.savedLabel sizeToFit];
    [self.view addSubview:self.savedLabel];
    self.savedLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - Actions

- (void)closeButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonTapped {
    UIImage *image = self.fullImageView.image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    self.savedLabel.hidden = NO;
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.savedLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.savedLabel.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            self.savedLabel.hidden = YES;
        }];
    }];
}

@end
