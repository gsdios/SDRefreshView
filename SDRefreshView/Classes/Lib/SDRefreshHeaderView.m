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
{
    BOOL _hasLayoutedForManuallyRefreshing;
}

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
    return - (self.sd_height * 0.5);
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
    
    // 模拟手动刷新
    if (self.isManuallyRefreshing && !_hasLayoutedForManuallyRefreshing && self.scrollView.contentInset.top > 0) {
        self.activityIndicatorView.hidden = NO;
        
        // 模拟下拉操作7
        CGPoint temp = self.scrollView.contentOffset;
        temp.y -= self.sd_height * 2;
        self.scrollView.contentOffset = temp; // 触发准备刷新
        temp.y += self.sd_height;
        self.scrollView.contentOffset = temp; // 触发刷新
        
        _hasLayoutedForManuallyRefreshing = YES;
    } else {
        self.activityIndicatorView.hidden = !self.isManuallyRefreshing;
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
    CGFloat criticalY = -self.sd_height - self.scrollView.contentInset.top;
    
    // 只有在 y<=0 以及 scrollview的高度不为0 时才判断
    if ((y > 0) || (self.scrollView.bounds.size.height == 0)) return;
    
    // 触发SDRefreshViewStateRefreshing状态
    if (y >= criticalY && (self.refreshState == SDRefreshViewStateWillRefresh) && !self.scrollView.isDragging) {
        [self setRefreshState:SDRefreshViewStateRefreshing];
    }
    
    // 触发SDRefreshViewStateWillRefresh状态
    if (y < criticalY && (SDRefreshViewStateNormal == self.refreshState)) {
        [self setRefreshState:SDRefreshViewStateWillRefresh];
    } else if (y >= criticalY && self.scrollView.isDragging) {
        self.refreshState = SDRefreshViewStateNormal;
    }
    
    if (self.refreshState == SDRefreshViewStateNormal && self.scrollView.dragging) {
        CGFloat scale = (-y - self.scrollView.contentInset.top) / self.sd_height;
        if (self.normalStateOperationBlock) {
            self.normalStateOperationBlock(self, scale);
        }
    }
}

@end
