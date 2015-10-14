# SDRefreshView

 ![](http://cc.cocimg.com/bbs/attachment/Fid_19/19_441660_d132ac6db15bcac.gif)


简单易用的上拉和下拉刷新（多版本细节适配）

  
1.导入主头文件

    #import "SDRefresh.h"

2.创建并设置 （只需3步）
    
    （1）SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    （2）[refreshHeader addToScrollView:目标tableview];  //加入到目标tableview，默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    
    （3）[refreshHeader addTarget: refreshAction:加载内容的方法] 或者 refreshHeader.beginRefreshingOperation = ^{} 任选其中一种即可
    
----------------------------------------------------------------------------------------------------------------
  PS： 
  1. 加载数据完成后调用 [refreshHeader endRefreshing];
  2. 如果需要一进入就自动加载一次数据，请调用[refreshHeader autoRefreshWhenViewDidAppear];
  3. 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
 

![](http://cc.cocimg.com/bbs/attachment/Fid_19/19_441660_3546442c2f2486c.gif)

仿京东动画刷新版本

https://github.com/gsdios/SDRefreshView/tree/%E4%BB%BF%E4%BA%AC%E4%B8%9C%E4%B8%8B%E6%8B%89%E5%88%B7%E6%96%B0%EF%BC%88%E5%BC%80%E6%94%BE%E6%8E%A5%E5%8F%A3%E5%8F%AF%E8%87%AA%E5%AE%9A%E4%B9%89%E5%8A%A8%E7%94%BB%EF%BC%89
