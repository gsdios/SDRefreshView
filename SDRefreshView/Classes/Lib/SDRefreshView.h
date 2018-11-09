//
//  SDRefreshView.h
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

#import <UIKit/UIKit.h>
typedef enum {
    SDRefreshViewStateWillRefresh,
    SDRefreshViewStateRefreshing,
    SDRefreshViewStateNormal
} SDRefreshViewState;

#define SDRefreshViewMethodIOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define SDRefreshViewObservingkeyPath @"contentOffset"
#define SDKNavigationBarHeight 64


// ---------------------------配置----------------------------------

@interface SDRefreshView : UIView

@property (nonatomic, copy) void(^beginRefreshingOperation)(void);
@property (nonatomic, weak) id beginRefreshingTarget;
@property (nonatomic, assign) SEL beginRefreshingAction;
@property (nonatomic, assign) BOOL isEffectedByNavigationController;

+ (instancetype)refreshView;

- (void)addToScrollView:(UIScrollView *)scrollView;
- (void)addToScrollView:(UIScrollView *)scrollView isEffectedByNavigationController:(BOOL)effectedByNavigationController;

- (void)addTarget:(id)target refreshAction:(SEL)action;
- (void)endRefreshing;


@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) SDRefreshViewState refreshState;
@property (nonatomic, copy) NSString *textForNormalState;
@property (nonatomic, copy) NSString *textForRefreshingState;
@property (nonatomic, copy) NSString *textForWillRefreshState;
@property (nonatomic, assign) BOOL isHiddenTimeIndicator;

@property (nonatomic, assign) UIFont* textFont;
@property (nonatomic, assign) UIColor* textColor;
@property (nonatomic, copy) UIImage* stateImage;
@property (nonatomic, assign) CGSize stateSize;

// 子类自定义位置使用
@property (nonatomic, assign) UIEdgeInsets scrollViewEdgeInsets;

@property (nonatomic, assign) CGFloat stateIndicatorViewNormalTransformAngle;
@property (nonatomic, assign) CGFloat stateIndicatorViewWillRefreshStateTransformAngle;

// 记录原始contentEdgeInsets
@property (nonatomic, assign) UIEdgeInsets originalEdgeInsets;
// 加载指示器
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) BOOL isManuallyRefreshing;

- (UIEdgeInsets)syntheticalEdgeInsetsWithEdgeInsets:(UIEdgeInsets)edgeInsets;

@end
