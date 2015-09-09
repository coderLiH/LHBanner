//
//  LHBanner.h
//  LHBanner
//
//  Created by 李允 on 15/9/9.
//  Copyright (c) 2015年 liyun. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const LHStartRunNotification;
UIKIT_EXTERN NSString *const LHStopRunNotification;

@class LHBanner;
@protocol LHBannerDelegate <NSObject>

- (void)bannerDidClickIndex:(NSInteger)index;

@end
@interface LHBanner : UIView

@property (nonatomic, strong) UIImage *placeHolder;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, weak) id<LHBannerDelegate> delegate;

@end
