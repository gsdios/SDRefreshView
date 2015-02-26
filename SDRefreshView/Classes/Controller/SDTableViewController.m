//
//  SDTableViewController.m
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDTableViewController.h"
#import "SDRefreshHeaderView.h"
#import "SDRefreshFooterView.h"

@interface SDTableViewController ()

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, assign) NSInteger totalRowCount;

@end

@implementation SDTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"上拉和下拉刷新";
        self.tableView.rowHeight = 60.0f;
        self.tableView.separatorColor = [UIColor whiteColor];
        _totalRowCount = 3;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    SDRefreshHeaderView *refreshHeader = [[SDRefreshHeaderView alloc] init];
    [refreshHeader addToScrollView:self.tableView isEffectedByNavigationController:YES];
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.totalRowCount += 2;
            [self.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    [refreshHeader beginRefreshing];
    
    SDRefreshFooterView *refreshFooter = [[SDRefreshFooterView alloc] init];
    [refreshFooter addToScrollView:self.tableView isEffectedByNavigationController:YES];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
    
    //[refreshHeader beginRefreshing];
}



- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.totalRowCount += 2;
        [self.tableView reloadData];
        [self.refreshFooter endRefreshing];
    });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totalRowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundView = nil;
        cell.textLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.95f];
    }
    
    cell.backgroundColor = [self randomColor];
    cell.textLabel.text = [NSString stringWithFormat:@"------第%d行--共%d行----", indexPath.row + 1, self.totalRowCount];
    
    return cell;
}

- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(255);
    CGFloat g = arc4random_uniform(255);
    CGFloat b = arc4random_uniform(255);
    
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:0.25f];
}

@end
