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
  2. 如果需要一进入就自动加载一次数据，请调用[refreshHeader beginRefreshing];
  3. 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
   

    
