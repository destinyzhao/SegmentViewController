//
//  ViewController.m
//  SegmentViewController
//
//  Created by Alex on 16/5/27.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "ViewController.h"
#import "SegmentView.h"
#import "ContentTableViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define Screenheight [UIScreen mainScreen].bounds.size.height
#define TopViewHeight 44

@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet SegmentView *segmentView;
@property (strong,nonatomic) UIScrollView *scrollView;//滚动式视图,选中按钮时,会滚动
@property (strong, nonatomic) NSMutableArray *typeArray;

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
    
    _typeArray = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    [self setupChildController];
    [self setupScrollView];
}

#pragma mark --private Method--初始化子控制器
-(void)setupChildController {
    for (NSInteger i = 0; i<2; i++) {
        ContentTableViewController *viewController = [[ContentTableViewController alloc] init];
        viewController.channelType = [_typeArray[i] integerValue];
        [self addChildViewController:viewController];
    }
}


- (void)setupScrollView
{
    //创建滚动视图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopViewHeight+64, ScreenWidth, Screenheight-TopViewHeight)];
    self.scrollView.pagingEnabled = YES;
    //设置滚动视图属性
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*2, Screenheight-TopViewHeight);
    self.scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    [self scrollViewDidEndScrollingAnimation:_scrollView];
}

- (void)scrollViewScrollWithPage:(NSInteger)page
{
    CGFloat x = self.scrollView.frame.size.width * page;
    [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

#pragma mark - <UIScrollViewDelegate>代理方法

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //滚动视图的宽
    CGFloat width = scrollView.frame.size.width;
    //当前显示第几个视图
    NSInteger number = scrollView.contentOffset.x / width;

    [_segmentView setCurrentSelectedIndex:number];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x/self.scrollView.frame.size.width;
        ContentTableViewController *vc = self.childViewControllers[index];
        vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [scrollView addSubview:vc.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
