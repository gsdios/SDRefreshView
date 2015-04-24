# SDRefreshView

 ![](http://cc.cocimg.com/bbs/attachment/Fid_19/19_441660_3546442c2f2486c.gif)


简单易用的上拉和下拉刷新（多版本细节适配）

  
1.导入主头文件

    #import "SDRefresh.h"

2.创建并设置 （只需3步）
    
    （1）SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];

    
     (2)实现自定义动画代理

     // normal状态执行的操作
     - (void)refreshView:(SDRefreshView *)refreshView didBecomeNormalStateWithMovingProgress:(CGFloat)progress
     {
     }

     // willRefresh状态执行的操作
     - (void)refreshView:(SDRefreshView *)refreshView didBecomeWillRefreshStateWithMovingProgress:(CGFloat)progress
     {
     }

     // refreshing状态执行的操作
     - (void)refreshView:(SDRefreshView *)refreshView didBecomeRefreshingStateWithMovingProgress:(CGFloat)progress
     {
     }
     
     （因为此版为完全开放接口版本，所有动画设置均由使用此框架者完成，如需把demo效果完全复制到你的项目中，请把demo中此三个block里面的代码一起复制过去）

    
    （3）[refreshHeader addTarget: refreshAction:加载内容的方法] 或者 refreshHeader.beginRefreshingOperation = ^{} 任选其中一种即可
    
    (具体步骤请参照demo)
----------------------------------------------------------------------------------------------------------------
  PS： 
  1. 加载数据完成后调用 [refreshHeader endRefreshing];
  2. 如果需要一进入就自动加载一次数据，请调用[refreshHeader beginRefreshing];
  3. 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
   

    
