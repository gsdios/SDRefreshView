//
//  SDRefreshView.m
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDRefreshView.h"
#import "UIView+SDExtension.h"

typedef enum {
    SDRefreshViewStatePulling,
    SDRefreshViewStateWillRefresh,
    SDRefreshViewStateRefreshing,
    SDRefreshViewStateNormal
} SDRefreshViewState;

@implementation SDRefreshView
{
    BOOL _shouldRefresh;
    SDRefreshViewState _refreshState;
    UILabel *_indicatorLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [activity startAnimating];
        activity.center = CGPointMake(160, 40);
        [self addSubview:activity];
        
        UILabel *indicatorLabel = [[UILabel alloc] init];
        indicatorLabel.text = @"⬇️";
        indicatorLabel.frame = CGRectMake(20, 20, 50, 50);
        indicatorLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:indicatorLabel];
        _indicatorLabel = indicatorLabel;
    }
    return self;
}

- (void)setRefreshState:(SDRefreshViewState)refreshState
{
    _refreshState = refreshState;
    
    switch (refreshState) {
        case SDRefreshViewStateRefreshing:
            {
                _scrollView.contentInset = UIEdgeInsetsMake(self.sd_height, 0, 0, 0);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.6 animations:^{
                        _scrollView.contentInset = UIEdgeInsetsZero;
                    } completion:^(BOOL finished) {
                        [self setRefreshState:SDRefreshViewStateNormal];
                    }];
                });
            }
            break;
            
        case SDRefreshViewStateWillRefresh:
            _indicatorLabel.text = @"⬆️";
            break;
            
        case SDRefreshViewStateNormal:
            _indicatorLabel.text = @"⬇️";
            break;
            
        default:
            break;
    }
}

- (void)addToScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.delegate = self;
    
    //[_scrollView addSubview:self];
    [_scrollView insertSubview:self atIndex:3];
    self.frame = CGRectMake(0, -80, 320, 80);
    
    NSLog(@"---%@--", _scrollView.superview);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    if (scrollView.contentOffset.y > -self.sd_height && (_refreshState == SDRefreshViewStateWillRefresh)) {
        [self setRefreshState:SDRefreshViewStateRefreshing];
    }
    
    if (scrollView.contentOffset.y < -self.sd_height && (_refreshState != SDRefreshViewStateWillRefresh)) {
        if (_refreshState == SDRefreshViewStateRefreshing) return;
        [self setRefreshState:SDRefreshViewStateWillRefresh];
    }
    
    
    NSLog(@"---%f--", _scrollView.contentOffset.y);
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    [UIView animateWithDuration:0.5 animations:^{
//        scrollView.contentInset =UIEdgeInsetsMake(100, 0, 0, 0);
//    } completion:^(BOOL finished) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.6 animations:^{
//                scrollView.contentInset = UIEdgeInsetsZero;
//            }];
//        });
//    }];
}

@end
