//
//  QYCarouselView.m
//  lunbotuDemo
//
//  Created by guoqingyang on 16/3/15.
//  Copyright © 2016年 guoqingyang. All rights reserved.
//

#import "QYCarouselView.h"

#define kWidth self.bounds.size.width
#define kHeigth self.bounds.size.height
@interface QYCarouselView ()<UIScrollViewDelegate>
{
    UIScrollView *scrollview;
    UIPageControl *pageController;
    NSTimer *timer;
}
@property (nonatomic, assign) NSInteger index;//记录数组的下标
@end

@implementation QYCarouselView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.duration = 2.5;
        self.index = 0;
        [self drawScrollview];
    }
    return self;
}
//scrollview
-(void)drawScrollview{
    scrollview = [[UIScrollView alloc]initWithFrame:self.frame];
    [self addSubview:scrollview];
    scrollview.delegate = self;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
   scrollview.contentSize = CGSizeMake(kWidth * 3, 0);//设置可滑尺寸
   scrollview.contentOffset = CGPointMake(kWidth, 0);//设置初始偏移量
}
//pageController
-(void)drawPageController{
    pageController = [[UIPageControl alloc]initWithFrame:CGRectMake(kWidth - 100, kHeigth - 50, 100, 50)];
    pageController.numberOfPages = _imgs.count;//圆点个数
    pageController.currentPage = 0;//初始选中第一个圆点
    pageController.pageIndicatorTintColor = [UIColor whiteColor];//圆点颜色
    pageController.currentPageIndicatorTintColor = [UIColor greenColor];//当前圆点颜色
    pageController.enabled = NO;//由于后面要添加计时器,所以此处取消圆点选中事件
    [self addSubview:pageController];
}
-(void)setImgs:(NSArray *)imgs{
    if (_imgs != imgs) {
        _imgs = imgs;
    }
    [self drawPageController];
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth * i, 0, kWidth, kHeigth)];
        imgView.tag = 1000 + i;//添加标记,方便后面找到
        if (i == 0) {
            imgView.image = imgs.lastObject;
        }
        if (i == 1) {
            imgView.image = imgs.firstObject;
        }
        if (i == 2) {
            imgView.image = imgs[1];
        }
        imgView.contentMode = UIViewContentModeScaleToFill;
        [scrollview addSubview:imgView];
    }
    [self initTimer];
}
//scrollView结束减速时执行
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x >= kWidth) {
        //根据偏移量是向左还是右分别控制index的值
        if (self.index == self.imgs.count - 1) {
            self.index = 0;
        }else{
            self.index ++;
        }
    }else{
        if (self.index == 0) {
            self.index = self.imgs.count -1;
        }else{
            self.index --;
        }
    }
    //调整好index的值之后重新设置下偏移量以及当前选中的圆点
    [scrollview setContentOffset:CGPointMake(kWidth, 0) animated:NO];
    pageController.currentPage = self.index;
    //让中间的imgView始终显示index位置的图片(中心思想)
    [self addImage:self.index];
}
// 改变imageView显示的图片名称
- (void)addImage:(NSInteger)index{
    //找到添加到scrollView上的imgView
    UIImageView *imageView1 = (UIImageView *)[scrollview viewWithTag:1000];
    UIImageView *imageView2 = (UIImageView *)[scrollview viewWithTag:1001];
    UIImageView *imageView3 = (UIImageView *)[scrollview viewWithTag:1002];
    if (index == self.imgs.count - 1){
        imageView1.image = self.imgs[index-1];
        imageView2.image = self.imgs[index];
        imageView3.image = self.imgs[0];
    }
    else if (index == 0){
        imageView1.image = self.imgs.lastObject;
        imageView2.image = self.imgs[index];
        imageView3.image = self.imgs[1+index];
    }
    else{
        imageView1.image = self.imgs [index-1];
        imageView2.image = self.imgs[index];
        imageView3.image = self.imgs[index+1];
    }
}
//创建计时器
- (void)initTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(loadScrollViewImage) userInfo:nil repeats:YES];
    //防止在滑动tableview的时候timer停止
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
//计时器要执行的方法:每次执行改变偏移量
- (void)loadScrollViewImage{
    [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x + kWidth, 0) animated:YES] ;
}

//偏移量改变并且有滚动动画才会执行该方法,内部代码与上面结束减速(scrollViewDidEndDecelerating:)要执行的代码相同
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x >= kWidth) {
        //根据偏移量是向左还是右分别控制index的值
        if (self.index == self.imgs.count - 1) {
            self.index = 0;
        }else{
            self.index ++;
        }
    }else{
        if (self.index == 0) {
            self.index = self.imgs.count -1;
        }else{
            self.index --;
        }
    }
    //调整好index的值之后重新设置下偏移量以及当前选中的圆点
    [scrollview setContentOffset:CGPointMake(kWidth, 0) animated:NO];
    pageController.currentPage = self.index;
    //让中间的imgView始终显示index位置的图片(中心思想)
    [self addImage:self.index];
}

//防止计时器与拖动手势冲突
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [timer invalidate] ;
    timer = nil ;
}
//拖拽结束时开启一个新的计时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self initTimer] ;
}

@end
