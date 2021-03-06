//
//  ViewController.m
//  SegmentViewController
//
//  Created by Alex on 16/5/27.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "ViewController.h"
#import "SegmentView.h"
#import "ContentViewController.h"
#import "Content1ViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define Screenheight [UIScreen mainScreen].bounds.size.height
#define TopViewHeight 44

@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet SegmentView *segmentView;
@property (strong,nonatomic) UIScrollView *scrollView;//滚动式视图,选中按钮时,会滚动
@property (strong, nonatomic) ContentViewController *untreatedOrderVC;
@property (strong, nonatomic)  Content1ViewController *dealOrderVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *titleArr = @[@"未处理",@"已处理"];
    [_segmentView setTitleArray:titleArr];
    [_segmentView segmentBlock:^(NSInteger index) {
        NSLog(@"点击了%ld",index);
        [self scrollViewScrollWithPage:index];
    }];
    
    [self createScrollView];
}

- (void)createScrollView
{
    //创建滚动视图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopViewHeight+64, ScreenWidth, Screenheight-TopViewHeight)];
    self.scrollView.pagingEnabled = YES;
    //设置滚动视图属性
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*2, Screenheight-TopViewHeight);
    self.scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _untreatedOrderVC = [[ContentViewController alloc]init];
    _untreatedOrderVC.view.frame = CGRectMake(0, 0, ScreenWidth, Screenheight-TopViewHeight);
    _untreatedOrderVC.view.backgroundColor = [UIColor greenColor];
    [_scrollView addSubview:_untreatedOrderVC.view];
    
    _dealOrderVC = [[Content1ViewController alloc]init];
    _dealOrderVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, Screenheight-TopViewHeight);
    _dealOrderVC.view.backgroundColor = [UIColor yellowColor];
    [_scrollView addSubview:_dealOrderVC.view];
}

- (void)scrollViewScrollWithPage:(NSInteger)page
{
    CGFloat x = self.scrollView.frame.size.width * page;
    [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

#pragma mark - <UIScrollViewDelegate>代理方法
//滚动视图时触发的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滚动视图的宽
    CGFloat width = scrollView.frame.size.width;
    
    //当前显示第几个视图
    NSInteger number = scrollView.contentOffset.x / width;
    
 
    [_segmentView setCurrentSelectedIndex:number];
    //滚动指示器视图
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
