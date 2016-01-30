//
//  ABCImageViewController.m
//  ABCImageViewController
//
//  Created by Adam Cooper on 1/30/16.
//  Copyright © 2016 Adam Cooper. All rights reserved.
//

#import "ABCImageViewController.h"

@interface ABCImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ABCImageViewController

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    
    [self addConstraints];

}

#pragma mark - UIScollview Delegate Methods

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


#pragma mark - Gesture Recognizers

- (void)imageDoubleTapped:(UITapGestureRecognizer *)recognizer
{
    
    if(self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    else
    {
        CGPoint pointInView = [recognizer locationInView:self.imageView];
        
        // 2
        CGFloat newZoomScale = self.scrollView.zoomScale * 2.5f;
        newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
        
        // 3
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (w / 2.0f);
        CGFloat y = pointInView.y - (h / 2.0f);
        
        CGRect rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        [self.scrollView zoomToRect:rectToZoomTo animated:YES];
    }
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer
{
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

#pragma mark - Properties

-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setBackgroundColor:[UIColor blackColor]];
        _scrollView.delegate = self;
        _scrollView.zoomScale = 1.0f;
        _scrollView.maximumZoomScale = 8.0f;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _scrollView.scrollEnabled = YES;
        _scrollView.clipsToBounds = YES;
        _scrollView.bounces = YES;
        
        [_scrollView addSubview:self.imageView];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDoubleTapped:)];
        doubleTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
        twoFingerTapRecognizer.numberOfTapsRequired = 1;
        twoFingerTapRecognizer.numberOfTouchesRequired = 2;
        [_scrollView addGestureRecognizer:twoFingerTapRecognizer];
        
    }
    return _scrollView;
}


-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.image];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        _imageView.isAccessibilityElement = NO;
        _imageView.clipsToBounds = YES;
        _imageView.layer.allowsEdgeAntialiasing = YES;
        _imageView.backgroundColor = [UIColor blackColor];
    }
    return _imageView;
}

#pragma mark - Constraints

-(void)addConstraints {
    
    //ScrollView Constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
}


@end
