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
        self.isManuallyRefreshing = YES;
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
    
//    if (self.isManuallyRefreshing) {
//        
//        self.scrollView.contentOffset = CGPointMake(0, -(self.sd_height + self.scrollView.contentInset.top));
//        
//        NSLog(@"---offset--(%@)--top(%f)", NSStringFromCGPoint(self.scrollView.contentOffset), self.scrollView.contentInset.top);
//        
//        if (SDRefreshViewMethodIOS7 && self.isEffectedByNavigationController) {
//            // 加入自定义的inset
//            //self.originalEdgeInsets = [self syntheticalEdgeInsetsWithEdgeInsets:self.scrollView.contentInset];
//            
//            // 加入navigationBar高度增加的inset
//            self.originalEdgeInsets = [self syntheticalEdgeInsetsWithEdgeInsets:UIEdgeInsetsMake(64 , 0, 0, 0)];
//            
//            NSLog(@"--insets--(%@)", NSStringFromUIEdgeInsets(self.originalEdgeInsets));
//        }
//    }
    
    self.center = CGPointMake(self.scrollView.sd_width * 0.5, [self yOfCenterPoint]);
    
     NSLog(@"----lay---(%@)", NSStringFromUIEdgeInsets(self.scrollView.contentInset));
    if (self.isManuallyRefreshing) {
        [self setRefreshState:SDRefreshViewStateRefreshing];
        self.isManuallyRefreshing = NO;
    }
}

- (void)didMoveToSuperview
{
    NSLog(@"----load---(%@)", NSStringFromUIEdgeInsets(self.scrollView.contentInset));
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
    
    // 只有在 y<=0 以及 scrollview的高度不为0 时才判断
    if ((y > 0) || (self.scrollView.bounds.size.height == 0)) return;
    
    if (y >= (-self.sd_height - self.scrollView.contentInset.top) && (self.refreshState == SDRefreshViewStateWillRefresh)) {
        [self setRefreshState:SDRefreshViewStateRefreshing];
    }
    
    if (y < (-self.sd_height - self.scrollView.contentInset.top) && (SDRefreshViewStateNormal == self.refreshState)) {
        [self setRefreshState:SDRefreshViewStateWillRefresh];
    }
    
    NSLog(@"---yyy--(%f)", y);

}

@end
