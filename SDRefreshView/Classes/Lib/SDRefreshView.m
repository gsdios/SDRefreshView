//
//  SDRefreshView.m
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDRefreshView.h"
#import "UIView+SDExtension.h"


@implementation SDRefreshView
{
    UIImageView *_stateIndicatorView;
    UILabel *_textIndicator;
    UILabel *_timeIndicator;
    UIActivityIndicatorView *_activityIndicatorView;
    NSString *_lastRefreshingTimeString;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bounds = CGRectMake(0, 0, 320, 80);
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [activity startAnimating];
        [self addSubview:activity];
        _activityIndicatorView = activity;
        
        UIImageView *stateIndicator = [[UIImageView alloc] init];
        stateIndicator.image = [UIImage imageNamed:@"sdRefeshView_arrow"];
        [self addSubview:stateIndicator];
        _stateIndicatorView = stateIndicator;
        _stateIndicatorView.bounds = CGRectMake(0, 0, 15, 40);
        
        UILabel *textIndicator = [[UILabel alloc] init];
        textIndicator.bounds = CGRectMake(0, 0, 300, 30);
        textIndicator.textAlignment = NSTextAlignmentCenter;
        textIndicator.backgroundColor = [UIColor clearColor];
        textIndicator.font = [UIFont systemFontOfSize:14];
        textIndicator.textColor = [UIColor lightGrayColor];
        [self addSubview:textIndicator];
        _textIndicator = textIndicator;
        
        UILabel *timeIndicator = [[UILabel alloc] init];
        timeIndicator.bounds = CGRectMake(0, 0, 160, 16);;
        timeIndicator.textAlignment = NSTextAlignmentCenter;
        timeIndicator.textColor = [UIColor lightGrayColor];
        timeIndicator.font = [UIFont systemFontOfSize:14];
        [self addSubview:timeIndicator];
        _timeIndicator = timeIndicator;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _activityIndicatorView.hidden = !_isManuallyRefreshing;
    _activityIndicatorView.center = CGPointMake(50, self.sd_height * 0.5);
    _stateIndicatorView.center = _activityIndicatorView.center;
    
    _textIndicator.center = CGPointMake(self.sd_width * 0.5, _activityIndicatorView.sd_height * 0.5 + 30);
    _timeIndicator.center = CGPointMake(self.sd_width * 0.5, self.sd_height - _timeIndicator.sd_height * 0.5 - 20);
}

- (NSString *)lastRefreshingTimeString
{
    if (_lastRefreshingTimeString == nil) {
        return [self refreshingTimeString];
    }
    return _lastRefreshingTimeString;
}

- (void)addToScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    [_scrollView addSubview:self];
    [_scrollView addObserver:self forKeyPath:SDRefreshViewObservingkeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addToScrollView:(UIScrollView *)scrollView isEffectedByNavigationController:(BOOL)effectedByNavigationController
{
    [self addToScrollView:scrollView];
    _isEffectedByNavigationController = effectedByNavigationController;
    _originalEdgeInsets = scrollView.contentInset;
}

- (void)addTarget:(id)target refreshAction:(SEL)action
{
    _beginRefreshingTarget = target;
    _beginRefreshingAction = action;
}



- (UIEdgeInsets)syntheticalEdgeInsetsWithEdgeInsets:(UIEdgeInsets)edgeInsets
{
    return UIEdgeInsetsMake(_originalEdgeInsets.top + edgeInsets.top, _originalEdgeInsets.left + edgeInsets.left, _originalEdgeInsets.bottom + edgeInsets.bottom, _originalEdgeInsets.right + edgeInsets.right);
}

- (void)setRefreshState:(SDRefreshViewState)refreshState
{
    _refreshState = refreshState;
    
    switch (refreshState) {
        case SDRefreshViewStateRefreshing:
            {
                _originalEdgeInsets = self.scrollView.contentInset;
//                if (self.isManuallyRefreshing && SDRefreshViewMethodIOS7 && self.isEffectedByNavigationController) {
//                    _originalEdgeInsets = [self syntheticalEdgeInsetsWithEdgeInsets:UIEdgeInsetsMake(64 , 0, 0, 0)];
//                }
               
                _scrollView.contentInset = [self syntheticalEdgeInsetsWithEdgeInsets:self.scrollViewEdgeInsets];

                _stateIndicatorView.hidden = YES;
                _activityIndicatorView.hidden = NO;
                _lastRefreshingTimeString = [self refreshingTimeString];
                _textIndicator.text = @"正在加载最新数据,请稍候";
                
                if (self.beginRefreshingOperation) {
                    self.beginRefreshingOperation();
                } else if (self.beginRefreshingTarget) {
                    if ([self.beginRefreshingTarget respondsToSelector:self.beginRefreshingAction]) {
                        
// 屏蔽performSelector-leak警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        [self.beginRefreshingTarget performSelector:self.beginRefreshingAction];
                    }
                }
            }
            break;
            
        case SDRefreshViewStateWillRefresh:
            {
                _textIndicator.text = @"松开即可加载最新数据";
                [UIView animateWithDuration:0.5 animations:^{
                    _stateIndicatorView.transform = CGAffineTransformMakeRotation(self.stateIndicatorViewWillRefreshStateTransformAngle);
                }];
            }
            break;
            
        case SDRefreshViewStateNormal:
            _textIndicator.text = self.textForPullingState;
            _stateIndicatorView.transform = CGAffineTransformMakeRotation(self.stateIndicatorViewNormalTransformAngle);
            _timeIndicator.text = [NSString stringWithFormat:@"最后更新：%@", [self lastRefreshingTimeString]];
            _stateIndicatorView.hidden = NO;
            _activityIndicatorView.hidden = YES;
            break;
            
        default:
            break;
    }
}


- (void)endRefreshing
{
    [UIView animateWithDuration:0.6 animations:^{
        _scrollView.contentInset = _originalEdgeInsets;
    } completion:^(BOOL finished) {
        [self setRefreshState:SDRefreshViewStateNormal];
        if (self.isManuallyRefreshing) {
            _isManuallyRefreshing = NO;
        }
    }];
}

- (NSString *)refreshingTimeString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    return [formatter stringFromDate:date];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ;
}

- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
