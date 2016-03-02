//
//  HXBannerScrollView.h
//  HXBannerScrollViewDemo
//
//  Created by HongXiangWen on 15/11/30.
//  Copyright © 2015年 HongXiangWen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXBannerScrollView;

@protocol HXBannerScrollViewDelegate <NSObject>

/**
 *  每次滚动调用此方法
 *
 *  @param bannerScrollView bannerScrollView的对象
 *  @param index            当前页数
 */
- (void)bannerScrollView:(HXBannerScrollView *)bannerScrollView scrollToIndex:(NSInteger)index;

/**
 *  点击调用此方法
 *
 *  @param bannerScrollView bannerScrollView的对象
 *  @param index            当前页数
 */
- (void)bannerScrollView:(HXBannerScrollView *)bannerScrollView clickAtIndex:(NSInteger)index;

@end

@interface HXBannerScrollView : UIView

/**
 *  自动滚动的timer
 */
@property (nonatomic,strong) NSTimer *scrollTimer;

/**
 *  图片数组
 */
@property (nonatomic,strong) NSArray *imageArray;

/**
 *  HXBannerScrollViewDelegate代理
 */
@property (nonatomic,assign) id<HXBannerScrollViewDelegate> delegate;

/**
 *  开始自动滚动
 */
- (void)startAutoScrolling;

/**
 *  停止自动滚动
 */
- (void)stopAutoScrolling;

@end
