//
//  ViewController.m
//  蜻蜓FM
//
//  Created by 侯玉昆 on 15/12/15.
//  Copyright © 2015年 侯玉昆. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,weak) UIPageControl *pageControl;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,weak) UIScrollView *scrollViewTop;

@end

@implementation ViewController
- (NSArray *)array{
    _array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"qingtingFM.plist" ofType:nil]];
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSUInteger  countRow = 3;
    CGFloat margin = 10;
    CGFloat viewWidth = 110;
    CGFloat viewheigth =160;
    CGFloat marginRow = (self.view.frame.size.width - 2*margin-countRow*viewWidth)/(countRow-1);
    CGFloat tempY = 0;
    //创建图片轮播
    UIScrollView *scorllViewTop = [UIScrollView new];
    self.scrollViewTop = scorllViewTop;
    CGFloat scorllViewTopW = self.view.frame.size.width;
    CGFloat scorllViewTopH = scorllViewTopW/2.2;
    CGFloat scorllViewTopX = 0;
    CGFloat scorllViewTopY = 0;
    scorllViewTop.frame = CGRectMake(scorllViewTopX, scorllViewTopY, scorllViewTopW, scorllViewTopH);
    [self.scrollView addSubview:scorllViewTop];
    NSUInteger imageCount = 6;
    for (int i=0; i<imageCount; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(i*scorllViewTopW, scorllViewTopY, scorllViewTopW, scorllViewTopH);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"s_%d",i]];
        [scorllViewTop addSubview:imageView];
    }
    
    
    //设置滚动尺寸
    scorllViewTop.contentSize=CGSizeMake(imageCount*scorllViewTopW, 0);
    //去掉弹簧效果
    scorllViewTop.bounces = NO;
    //不要下面的滚动条
    scorllViewTop.showsHorizontalScrollIndicator = NO;
    //让每一页显示一张图片
    scorllViewTop.pagingEnabled = YES;
    //添加页面控制
    UIPageControl *pageControl = [UIPageControl new];
    self.pageControl = pageControl;
    pageControl.numberOfPages = imageCount;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    
    CGFloat W = self.view.frame.size.width;
    CGFloat H = 30;
    CGFloat X = 0;
    CGFloat Y = scorllViewTopY+scorllViewTopH-H-margin;
    pageControl.frame = CGRectMake(X, Y, W, H);
    [self.scrollView addSubview:pageControl];
    //设置代理
    scorllViewTop.delegate=self;
    //设置计时器
    self.timer =[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoScroll)  userInfo:nil repeats:YES];
    //修改计时器优先权为等同
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    //创建接下来对象
    for (int i=0; i<self.array.count/2; i++) {
        UIView *view = [UIView new];
        CGFloat viewX =(i%countRow)*(viewWidth + marginRow)+margin;
        CGFloat viewY =(i/countRow)*(viewheigth + margin)+(viewheigth-viewWidth)/2+margin+scorllViewTopH;
        view.frame = CGRectMake(viewX, viewY, viewWidth, viewheigth);
        [self.scrollView addSubview:view];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnWidth = viewWidth;
        CGFloat btnHeigth = btnWidth;
        CGFloat btnX = 0;
        CGFloat btnY =0;
        btn.frame = CGRectMake(btnX, btnY, btnWidth ,btnHeigth);
        [btn setBackgroundImage:[UIImage imageNamed:self.array[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        UILabel *label = [UILabel new];
        CGFloat labelW = viewWidth;
        CGFloat labelH = (viewheigth-btnHeigth)*0.7;
        CGFloat labelX = 0;
        CGFloat labelY = btnHeigth;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.text =self.array[21+i];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:12];
        [view addSubview:label];
        tempY = viewY;
        UIButton *btnTop = [UIButton new];
        CGFloat btnTopW = scorllViewTopW;
        CGFloat btnTopH =labelH;
        CGFloat btnTopX =0;
        CGFloat btnTopY =scorllViewTopH+margin+(i/countRow)*(viewheigth+margin);
        btnTop.frame = CGRectMake(btnTopX, btnTopY, btnTopW, btnTopH);
       btnTop.backgroundColor= [UIColor purpleColor];
        [btnTop setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tite%02d",i]] forState:UIControlStateNormal];
        [self.scrollView addSubview:btnTop];
    }
    CGFloat scrollViewH = margin +tempY+viewheigth;
    self.scrollView.contentSize = CGSizeMake(0, scrollViewH);
    self.scrollView.contentOffset = CGPointMake(0, -72);
    self.scrollView.contentInset = UIEdgeInsetsMake(72, 0, 72, 0);
}
//代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = (int)((scrollView.contentOffset.x+scrollView.frame.size.width/2)/scrollView.frame.size.width);
    self.pageControl.currentPage = index;
}
- (void)autoScroll{
    NSInteger index = self.pageControl.currentPage;
    index =(++index == self.pageControl.numberOfPages)?0:index;
    CGFloat w = self.scrollViewTop.frame.size.width;
    [self.scrollViewTop setContentOffset:CGPointMake(index*w,0) animated:YES];
}
// 开始拽的时候要停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}
//停止拽的时候再开启计时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)test{
    NSLog(@"点我啊");
}
@end
