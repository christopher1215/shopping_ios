//
//  MgrBonusHistoryViewController.m
//  shopping
//
//  Created by Macbook on 01/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "MgrBonusHistoryViewController.h"
#import "WithdrawViewController.h"
#import "MgrBonusTableViewCell.h"

#import "MJRefresh.h"
#import "DownDatePicker.h"
#import "AgentCommission.h"

@interface MgrBonusHistoryViewController ()
{
    NSMutableArray *commissions;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *formatter;
}
@property (strong, nonatomic) DownDatePicker *startDatePicker;
@property (strong, nonatomic) DownDatePicker *endDatePicker;
@property (nonatomic) int last_id;

@end

@implementation MgrBonusHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnReqCommission.layer.cornerRadius = 5.0f;
    self.btnReqCommission.layer.borderWidth = 1.0f;
    self.btnReqCommission.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnReqCommission.layer.masksToBounds = YES;

    self.btnSearch.layer.cornerRadius = 5.0f;
    self.btnSearch.layer.borderWidth = 1.0f;
    self.btnSearch.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnSearch.layer.masksToBounds = YES;
    
    self.startDatePicker = [[DownDatePicker alloc] initWithTextField:self.pickerStartDate];
    self.endDatePicker = [[DownDatePicker alloc] initWithTextField:self.pickerEndDate];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MgrBonusTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self getInfo];

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *chinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
    [dateFormatter setDateFormat:@"yyyy年 MM月 dd日"];
    [dateFormatter setLocale:chinaLocale];

    _pickerStartDate.text = [dateFormatter stringFromDate:[formatter dateFromString:@"2017-02-27"]];
    _pickerEndDate.text = [dateFormatter stringFromDate:[NSDate date]];
    commissions = [[NSMutableArray alloc] init];
    [self addFooter];
    [self addRefreshKit];
}

- (void)getInfo
{
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GET_AGENT_COMMISSION];
    NSDictionary *data = @ {@"user_id" : [NSString stringWithFormat:@"%ld", [UserInfoKit sharedKit].userID]
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [Common showProgress:self.view];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              NSDictionary *latestLoans = [Common fetchData:responseObject];
              if (latestLoans) {
                  _lblDayBonus.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"commission"] floatValue]];
                  _lblMonthBonus.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"month_commission"] floatValue]];
                  _lblTotalBonus.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"total_commission"] floatValue]];
                  _lblTotalUsers.text = [NSString stringWithFormat:@"客户总数：%d", [[latestLoans objectForKey:@"tot_user"] intValue]];
                  _lblTotalBuyMoney.text = [NSString stringWithFormat:@"购买总额：%.02f", [[latestLoans objectForKey:@"tot_buy_money"] floatValue]];
              }
              [Common hideProgress];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];
              //[Common showMessage:ERR_CONNECTION];
          }];
}
- (IBAction)onGotoReqWithdraw:(id)sender {
    WithdrawViewController *vc = [[WithdrawViewController alloc] initWithNibName:@"WithdrawViewController" bundle:nil];
    vc.title = STR_WTHDRAW;
    // Push the view controller.
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onSearch:(id)sender {
    [self addRefreshKit];
}
#pragma mark - Custom Methods

- (void)addRefreshKit
{
    if([self.tableView.header isRefreshing]){
        [self.tableView.header endRefreshing];
    }
    if([self.tableView.footer isRefreshing]){
        [self.tableView.footer endRefreshing];
    }
    
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.last_id = 0;
        [weakSelf getAgentCommission:weakSelf.last_id];
    }];
    self.tableView.header.automaticallyChangeAlpha = YES;
    [self.tableView.header beginRefreshing];
    
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    self.tableView.footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getAgentCommission:weakSelf.last_id];
    }];
}
- (void)getAgentCommission:(int)last_id
{
    __weak typeof(self) weakSelf = self;
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GET_AGENT_COMMISSION];
    
    
    NSDictionary *data = @ {
        @"user_id":[NSString stringWithFormat:@"%ld", [UserInfoKit sharedKit].userID],
        @"last_id":[NSString stringWithFormat:@"%d", last_id],
        @"start_date":[NSString stringWithFormat:@"%@", [formatter stringFromDate:[dateFormatter dateFromString:_pickerStartDate.text]]],
        @"end_date":[NSString stringWithFormat:@"%@", [formatter stringFromDate:[dateFormatter dateFromString:_pickerEndDate.text]]],
        @"start":@"0",
        @"page_num":[NSString stringWithFormat:@"%d", RowsPerPage]
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              if (last_id == 0) {
                  [commissions removeAllObjects];
              }
              
              NSDictionary *latestLoans = [Common fetchData:responseObject];
              if(latestLoans) {
                  NSArray *notificationlists = [latestLoans objectForKey:@"commodities"];
                  for (NSDictionary *items in notificationlists) {
                      AgentCommission *notiItem = [AgentCommission alloc];
                      notiItem.reg_date = [items objectForKey:@"reg_date"];
                      notiItem.amount = [[items objectForKey:@"amount"] floatValue];
                      [commissions addObject:notiItem];
                  }
                  weakSelf.last_id = [[latestLoans objectForKey:@"last_id"] intValue];
                  
              }else{
                  
                  weakSelf.tableView.footer.hidden = YES;
              }
              [weakSelf.tableView reloadData];
              
              if([weakSelf.tableView.header isRefreshing]){
                  [weakSelf.tableView.header endRefreshing];
              } else {
                  [weakSelf.tableView.footer endRefreshing];
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if([weakSelf.tableView.header isRefreshing]){
                  [weakSelf.tableView.header endRefreshing];
              } else {
                  [weakSelf.tableView.footer endRefreshing];
              }
              [Common showMessage:ERR_CONNECTION];
          }];
    
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(commissions.count == 0)
    {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = STR_NO_DATA_PULL;
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:18];
        [messageLabel sizeToFit];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundView = messageLabel;
    }
    else
    {
        tableView.backgroundView = nil;
    }
    return [commissions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MgrBonusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MgrBonusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row < [commissions count]){
        AgentCommission *info = [AgentCommission alloc];
        info = [commissions objectAtIndex:indexPath.row];
        cell.lblDate.text = [NSString stringWithFormat:@"%@", info.reg_date];
        cell.lblCommission.text = [NSString stringWithFormat:@"%d", info.amount];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
