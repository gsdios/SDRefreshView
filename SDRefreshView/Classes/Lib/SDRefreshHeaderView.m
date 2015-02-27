//
//  SDRefreshHeaderView.m
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */


#import "SDRefreshHeaderView.h"
#import "UIView+SDExtension.h"

@implementation SDRefreshHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textForNormalState = @"下拉可以加载最新数据";
        self.stateIndicatorViewNormalTransformAngle = 0;
        self.stateIndicatorViewWillRefreshStateTransformAngle = M_PI;
        [self setRefreshState:SDRefreshViewStateNormal];
    }
    return self;
}

- (CGFloat)yOfCenterPoint
{
    if (self.isEffectedByNavigationController && SDRefreshViewMethodIOS7) {
        return - (self.sd_height * 0.5 + self.scrollView.contentInset.top - SDKNavigationBarHeight);
    }
    
    return - (self.sd_height * 0.5 + self.scrollView.contentInset.top);
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.scrollViewEdgeInsets = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.center = CGPointMake(self.scrollView.sd_width * 0.5, [self yOfCenterPoint]);
    
    // 手动刷新
    if (self.isManuallyRefreshing) {
        [self setRefreshState:SDRefreshViewStateRefreshing];
        self.isManuallyRefreshing = NO;
    }
}

- (void)beginRefreshing
{
    self.isManuallyRefreshing = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:SDRefreshViewObservingkeyPath]) return;
    
    CGFloat y = [change[@"new"] CGPointValue].y;
    
    // 只有在 y<=0 以及 scrollview的高度不为0 时才判断
    if ((y > 0) || (self.scrollView.bounds.size.height == 0)) return;
    
    // 触发SDRefreshViewStateRefreshing状态
    if (y >= (-self.sd_height - self.scrollView.contentInset.top) && (self.refreshState == SDRefreshViewStateWillRefresh)) {
        [self setRefreshState:SDRefreshViewStateRefreshing];
    }
    
    // 触发SDRefreshViewStateWillRefresh状态
    if (y < (-self.sd_height - self.scrollView.contentInset.top) && (SDRefreshViewStateNormal == self.refreshState)) {
        [self setRefreshState:SDRefreshViewStateWillRefresh];
    }
}

@end
