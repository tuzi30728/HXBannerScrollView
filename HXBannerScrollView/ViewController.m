//
//  ViewController.m
//  HXBannerScrollView
//
//  Created by HongXiangWen on 16/2/18.
//  Copyright © 2016年 can. All rights reserved.
//

#import "ViewController.h"
#import "HXBannerScrollView.h"

@interface ViewController () <HXBannerScrollViewDelegate>

@property (weak, nonatomic) IBOutlet HXBannerScrollView *bannerView1;

@property (weak, nonatomic) IBOutlet HXBannerScrollView *bannerView2;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bannerView1 startAutoScrolling];
    [self.bannerView2 startAutoScrolling];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.bannerView1 stopAutoScrolling];
    [self.bannerView2 stopAutoScrolling];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _bannerView1.imageArray = @[@"http://7xj243.com1.z0.glb.clouddn.com/cb17a04c-6ce6-4566-99aa-11533d8819e8.jpg",
                               @"http://7xj243.com1.z0.glb.clouddn.com/be0d76b5-1b44-4d00-9197-f6663e8e8424.jpg",
                               @"http://7xj243.com1.z0.glb.clouddn.com/a9f2ffe3-d25d-4bb6-a3a2-ed313c3e96d1.jpg",
                               @"http://7xj243.com1.z0.glb.clouddn.com/51dae941-3bee-488c-83f0-af90ef2a1219.jpg",
                               @"http://7xj243.com1.z0.glb.clouddn.com/fd43536c-cc60-4393-a1c5-7c975e07b690.jpg"];
    _bannerView1.delegate = self;

    
    _bannerView2.imageArray = @[[UIImage imageNamed:@"img_01"],
                               [UIImage imageNamed:@"img_02"],
                               [UIImage imageNamed:@"img_03"],
                               [UIImage imageNamed:@"img_04"],
                               [UIImage imageNamed:@"img_05"]];
    _bannerView2.delegate = self;

}

- (void)bannerScrollView:(HXBannerScrollView *)bannerScrollView scrollToIndex:(NSInteger)index
{
    NSLog(@"%ld",index);

}

- (void)bannerScrollView:(HXBannerScrollView *)bannerScrollView clickAtIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
