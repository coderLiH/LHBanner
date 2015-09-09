//
//  LHBannerScrollView.m
//  LHBanner
//
//  Created by 李允 on 15/9/9.
//  Copyright (c) 2015年 liyun. All rights reserved.
//

#import "LHBannerScrollView.h"
#import "UIView+Frame.h"

@implementation LHBannerScrollView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIView *child = self.subviews[i];
        child.size = self.bounds.size;
    }
}

@end
