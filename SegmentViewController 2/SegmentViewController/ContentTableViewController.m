//
//  ContentTableViewController.m
//  SegmentViewController
//
//  Created by Alex on 16/5/27.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "ContentTableViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface ContentTableViewController ()

@property (assign, nonatomic) NSInteger pageNum;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation ContentTableViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self requestData];
    [self setUpMJRefresh];
}

/**
 *  初始化MJRefresh
 */
- (void)setUpMJRefresh
{
    __weak UITableView *tableView = self.tableView;
    __weak __block typeof(self) selfBlock = self;
    
    // 下拉刷新
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        selfBlock.pageNum = 0;
        NSLog(@"pageNum:%zd",selfBlock.pageNum);
        [self requestData];
        // 结束刷新
        [tableView.mj_header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = NO;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        selfBlock.pageNum += 1;
        NSLog(@"pageNum:%zd",selfBlock.pageNum);
        [self requestData];
        // 结束刷新
        [tableView.mj_footer endRefreshing];
    }];
}

- (void)loadData
{
    if (_channelType == 0) {
        [self.dataArray addObject:@""];
    }
}

-(void)loadMoreData {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (_channelType == 1) {
        cell.textLabel.text = @"dddddd";
    }
    else
    {
        cell.textLabel.text = @"ffffff";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)requestData
{
    if (_channelType == 1) {
        NSLog(@"未处理");
    }
    else
    {
        NSLog(@"已处理");
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
