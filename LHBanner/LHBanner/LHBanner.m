//
//  LHBanner.m
//  LHBanner
//
//  Created by 李允 on 15/9/9.
//  Copyright (c) 2015年 liyun. All rights reserved.
//

#import "LHBanner.h"
#import "LHBannerScrollView.h"

#import "UIView+AutoLayout.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"


#define SCREEN_WIDTH             ([[UIScreen mainScreen] bounds].size.width)
NSString *const LHStartRunNotification = @"LHStartRunNotification";
NSString *const LHStopRunNotification = @"LHStopRunNotification";

@interface LHBanner () <UIScrollViewDelegate>
@property (nonatomic, strong) LHBannerScrollView *rootScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL canChange;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,assign) BOOL isDragging;               //是否正在拖动
@end
@implementation LHBanner

- (void)setImages:(NSArray *)images {
    _images = images;
    
    [self.rootScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _currentIndex = 0;
    
    if (images.count == 0) {
        self.pageControl.hidden = YES;
        UIImageView *placeHolder = [[UIImageView alloc] init];
        [self.rootScrollView addSubview:placeHolder];
        placeHolder.image = self.placeHolder;
    } else if (images.count == 1) {
        self.pageControl.hidden = YES;
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.rootScrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:images.firstObject] placeholderImage:self.placeHolder];
    } else {
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = images.count;
        self.canChange = YES;
        [self.rootScrollView addSubview:self.imageView1];
        [self.rootScrollView addSubview:self.imageView2];
        [self.rootScrollView addSubview:self.imageView3];
        
        self.rootScrollView.contentSize = CGSizeMake(3*SCREEN_WIDTH, 0);
        self.rootScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [self loadDataWithIndex:_currentIndex];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRun) name:LHStartRunNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRun) name:LHStopRunNotification object:nil];
    }
}

- (void)startRun {
    [self.timer invalidate];
    self.timer = nil;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopRun {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self clickImageAt:_currentIndex];
}

- (void)clickImageAt:(NSInteger)index {
    if (self.images.count > 0 && [self.delegate respondsToSelector:@selector(bannerDidClickIndex:)]) {
        [self.delegate bannerDidClickIndex:index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.images.count <= 1) {
        return;
    }
    if (scrollView.contentOffset.x >= SCREEN_WIDTH*2 && self.canChange) {
        self.canChange = NO;
        self.currentIndex = _currentIndex + 1;
    }
    if (scrollView.contentOffset.x <= 0 && self.canChange) {
        self.canChange = NO;
        self.currentIndex = _currentIndex - 1;
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (currentIndex != _currentIndex) {
        if (currentIndex > (NSInteger)self.images.count-1) {
            _currentIndex = 0;
        } else if (currentIndex < 0) {
            _currentIndex = self.images.count - 1;
        } else {
            _currentIndex = currentIndex;
        }
        
        [self loadDataWithIndex:_currentIndex];
        self.pageControl.currentPage = _currentIndex;
        self.canChange = YES;
    }
}

- (void)loadDataWithIndex:(NSInteger)index {
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:self.images[index]] placeholderImage:self.placeHolder];
    if (index == 0) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:self.images.lastObject] placeholderImage:self.placeHolder];
    } else {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:self.images[index-1]] placeholderImage:self.placeHolder];
    }
    if (index == self.images.count - 1) {
        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:self.images.firstObject] placeholderImage:self.placeHolder];
    } else {
        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:self.images[index+1]] placeholderImage:self.placeHolder];
    }
    self.rootScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.rootScrollView.frame = self.bounds;
    self.imageView2.x = self.width;
    self.imageView3.x = self.width*2;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isDragging = NO;
}

- (void)timeToScroll {
    if (_isDragging == YES) {
        return ;
    }
    [self.rootScrollView setContentOffset:CGPointMake(2*SCREEN_WIDTH, 0) animated:YES];
}

#pragma mark lazy
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timeToScroll) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UIImageView *)imageView1 {
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] init];
        _imageView1.userInteractionEnabled = YES;
    }
    return _imageView1;
}

- (UIImageView *)imageView2 {
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] init];
        _imageView2.userInteractionEnabled = YES;
    }
    return _imageView2;
}

- (UIImageView *)imageView3 {
    if (!_imageView3) {
        _imageView3 = [[UIImageView alloc] init];
        _imageView3.userInteractionEnabled = YES;
    }
    return _imageView3;
}

- (UIScrollView *)rootScrollView {
    if (!_rootScrollView) {
        _rootScrollView = [[LHBannerScrollView alloc] init];
        [self addSubview:_rootScrollView];
        _rootScrollView.showsHorizontalScrollIndicator = NO;
        _rootScrollView.showsVerticalScrollIndicator = NO;
        _rootScrollView.alwaysBounceHorizontal = YES;
        _rootScrollView.alwaysBounceVertical = NO;
        _rootScrollView.pagingEnabled = YES;
        _rootScrollView.delegate = self;
        [_rootScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }
    return _rootScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        [self addSubview:_pageControl];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        
        [_pageControl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:5];
        [_pageControl autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
        [self sendSubviewToBack:self.rootScrollView];
    }
    return _pageControl;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
