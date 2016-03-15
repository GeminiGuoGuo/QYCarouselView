//
//  ViewController.m
//  lunbotuDemo
//
//  Created by guoqingyang on 16/3/15.
//  Copyright © 2016年 guoqingyang. All rights reserved.
//

#import "ViewController.h"
#import "QYCarouselView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *imgs = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg"];
    NSMutableArray *imgsArray = [NSMutableArray new];
    for (int i=0; i<imgs.count; i++) {
        UIImage *img = [UIImage imageNamed:imgs[i]];
        [imgsArray addObject:img];
    }
    QYCarouselView *view = [[QYCarouselView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [self.view addSubview:view];
    view.imgs = imgsArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
