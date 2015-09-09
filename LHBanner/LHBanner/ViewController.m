//
//  ViewController.m
//  LHBanner
//
//  Created by 李允 on 15/9/9.
//  Copyright (c) 2015年 liyun. All rights reserved.
//

#import "ViewController.h"
#import "LHBanner.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LHBanner *banner = [[LHBanner alloc] initWithFrame:CGRectMake(0, 64, 320, 300)];
    [self.view addSubview:banner];
    banner.placeHolder = [UIImage imageNamed:@"toy_detail_paw"];
    banner.images = @[@"http://img2.haitaobei.com/baobei/500x500/20130202/103323703.jpg",@"http://d01.res.meilishuo.net/pic/_o/2b/ef/adac3f5e0c9996d9e308a7670ef3_306_301.c1.jpg",@"http://img19.niuza.com/2014/01/09/a40fc0b74b86c2462427ce6597bcad03.jpg",@"http://img14.360buyimg.com/n1/g15/M02/05/13/rBEhWFIS0OgIAAAAAAIy4ySlBI8AACOqwK1GEYAAjL7567.jpg"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:LHStartRunNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:LHStopRunNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
