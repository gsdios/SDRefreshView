//
//  SDRefreshView.h
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SDRefreshView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

- (void)addToScrollView:(UIScrollView *)scrollView;

@end
