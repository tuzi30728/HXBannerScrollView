//
//  HXBannerScrollView.m
//  HXBannerScrollViewDemo
//
//  Created by HongXiangWen on 15/11/30.
//  Copyright © 2015年 HongXiangWen. All rights reserved.
//

#import "HXBannerScrollView.h"
#import <UIImageView+WebCache.h>

// 时间间隔
#define kTimeInterval 2

@interface HXBannerScrollView () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;

/**
 *  存放imageView的数组
 */
@property (nonatomic,strong) NSMutableArray *imageViews;

/**
 *  当前页面的索引
 */
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation HXBannerScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.pageControl.numberOfPages = 3;
    [self addSubview:self.pageControl];
    
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(autoChangeThePage) userInfo:nil repeats:YES];
    [self.scrollTimer setFireDate:[NSDate distantFuture]];
}

- (NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    self.pageControl.numberOfPages = _imageArray.count;
    [self updateImages];
    [self setNeedsLayout];
}

- (void)updateImages
{
    for (int i = 0; i < 3; i ++) {
        NSInteger index = [self indexWithCurrentIndex:self.currentIndex+i-1];
        UIImageView *imageView = [[UIImageView alloc] init];
                
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction)];
        [imageView addGestureRecognizer:tap];
        
        id imageObj = self.imageArray[index];
        if ([imageObj isKindOfClass:[UIImage class]]) {
            imageView.image = (UIImage *)imageObj;
        } else if ([imageObj isKindOfClass:[NSString class]]) {
            NSURL *url = [NSURL URLWithString:(NSString *)imageObj];
            [imageView sd_setImageWithURL:url];
        }
        
        [self.scrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    self.pageControl.frame = CGRectMake(self.frame.size.width - 80, CGRectGetHeight(self.frame)-20, 60, 8);
    if (self.imageArray.count) {
        for (int i = 0 ; i < self.imageViews.count; i ++) {
            UIImageView *imageView = (UIImageView *)self.imageViews[i];
            imageView.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
        }
    }
}

- (NSInteger)indexWithCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex < 0) {
        currentIndex = self.imageArray.count - 1;
    } else if (currentIndex > self.imageArray.count - 1) {
        currentIndex = 0;
    }
    return currentIndex;
}

- (void)updateScrollView:(UIScrollView *)scrollView
{
    BOOL shouldUpdate = NO;
    if (scrollView.contentOffset.x <= 0) {
        self.currentIndex = [self indexWithCurrentIndex:self.currentIndex-1];
        shouldUpdate = YES;
    } else if (scrollView.contentOffset.x >= CGRectGetWidth(scrollView.bounds)*2) {
        self.currentIndex = [self indexWithCurrentIndex:self.currentIndex+1];
        shouldUpdate = YES;
    }
    if (!shouldUpdate) {
        return;
    }
    if (self.imageArray.count) {
        for (int i = 0; i < 3; i ++) {
            UIImageView *imageView = (UIImageView *)self.imageViews[i];
            NSInteger index = [self indexWithCurrentIndex:self.currentIndex+i-1];
            id imageObj = self.imageArray[index];
            if ([imageObj isKindOfClass:[UIImage class]]) {
                imageView.image = (UIImage *)imageObj;
            } else if ([imageObj isKindOfClass:[NSString class]]) {
                NSURL *url = [NSURL URLWithString:(NSString *)imageObj];
                [imageView sd_setImageWithURL:url];
            }
        }
    }
    [self.pageControl setCurrentPage:self.currentIndex];
    [self resumeScrollView:scrollView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerScrollView:scrollToIndex:)]) {
        [self.delegate bannerScrollView:self scrollToIndex:self.currentIndex];
    }
}

- (void)resumeScrollView:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.bounds), 0) animated:NO];
}

- (void)imageTapAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerScrollView:clickAtIndex:)]) {
        [self.delegate bannerScrollView:self clickAtIndex:self.currentIndex];
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateScrollView:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAutoScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startAutoScrolling];
}

- (void)autoChangeThePage
{
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * 2, 0) animated:YES];
}

- (void)startAutoScrolling
{
    if (self.imageArray) {
        [self.scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kTimeInterval]];
    }
}

- (void)stopAutoScrolling
{
    if (self.imageArray) {
        [self.scrollTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)dealloc
{
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

@end
