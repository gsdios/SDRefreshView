//
//  SDRefreshHeaderView.m
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDRefreshHeaderView.h"
#import "UIView+SDExtension.h"

@implementation SDRefreshHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textForPullingState = @"下拉可以加载最新数据";
        self.stateIndicatorViewNormalTransformAngle = 0;
        self.stateIndicatorViewWillRefreshStateTransformAngle = M_PI;
        [self setRefreshState:SDRefreshViewStateNormal];
        
        self.scrollViewEdgeInsets = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
    }
    return self;
}

- (CGFloat)yOfCenterPoint
{
    if (self.isEffectedByNavigationController) {
        if (SDRefreshViewMethodIOS7) {
            return - (self.sd_height * 0.5 + self.scrollView.contentInset.top - 64);
        }
    }
    
    return - (self.sd_height * 0.5 + self.scrollView.contentInset.top);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
//    if (self.isManuallyRefreshing && SDRefreshViewMethodIOS7) {
//        self.scrollView.contentInset = [self syntheticalEdgeInsetsWithEdgeInsets:self.scrollViewEdgeInsets];
//        if (self.isEffectedByNavigationController) {
//            self.scrollView.contentOffset = CGPointMake(0, -(self.sd_y + 64 + self.scrollView.contentInset.top));
//        } else {
//            self.scrollView.contentOffset = CGPointMake(0, -(self.sd_y + self.scrollView.contentInset.top));
//        }
//    }
    
    if (self.isManuallyRefreshing) {
        self.originalEdgeInsets = UIEdgeInsetsMake(64 , 0, 0, 0);
        self.scrollView.contentOffset = CGPointMake(0, -(self.sd_height + self.scrollView.contentInset.top));
        NSLog(@"--off--(%@)", NSStringFromCGPoint(self.scrollView.contentOffset));
    }
    
    self.center = CGPointMake(self.scrollView.sd_width * 0.5, [self yOfCenterPoint]);
    
//    if (self.isManuallyRefreshing) {
//        self.sd_y += self.scrollViewEdgeInsets.top;
//    }
    
    NSLog(@"--h(%f)--top-(%f)", self.sd_height, self.scrollView.contentInset.top);
    NSLog(@"--lay--center-(%@)", NSStringFromCGPoint(self.center));
}

- (void)beginRefreshing
{
    self.isManuallyRefreshing = YES;
    [self setRefreshState:SDRefreshViewStateRefreshing];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:SDRefreshViewObservingkeyPath]) return;
    
    CGFloat y = [change[@"new"] CGPointValue].y;
    if ((y > 0) || (self.scrollView.bounds.size.height == 0)) return;
    
    if (y >= (-self.sd_height - self.scrollView.contentInset.top) && (self.refreshState == SDRefreshViewStateWillRefresh)) {
        [self setRefreshState:SDRefreshViewStateRefreshing];
    }
    
    if (y < (-self.sd_height - self.scrollView.contentInset.top) && (SDRefreshViewStateNormal == self.refreshState)) {
        [self setRefreshState:SDRefreshViewStateWillRefresh];
    }
    
    NSLog(@"----(%f)-", y);
}

@end
