//
//  AFAFZoomedPhotoViewController.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-24.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFZoomedPhotoViewController.h"

@interface AFZoomedPhotoViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation AFZoomedPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.scrollView.maximumZoomScale = 4.0f;
        self.scrollView.delegate = self;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.scrollView.alwaysBounceHorizontal = YES;
        self.scrollView.alwaysBounceVertical = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
    
    [self.scrollView addSubview:self.imageView];
    self.imageView.frame = self.scrollView.bounds;
    self.imageView.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y - 32);
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

-(UIImage *)image
{
    return self.imageView.image;
}

@end
