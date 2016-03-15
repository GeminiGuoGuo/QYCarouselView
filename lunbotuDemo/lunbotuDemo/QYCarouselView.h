//
//  QYCarouselView.h
//  lunbotuDemo
//
//  Created by guoqingyang on 16/3/15.
//  Copyright © 2016年 guoqingyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYCarouselView : UIView

//轮播间隔时间,默认2.5秒
@property(nonatomic,assign)CGFloat duration;
@property(nonatomic,strong)NSArray *imgs;
@end
