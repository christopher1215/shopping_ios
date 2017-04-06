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
#import "CommissionDetailViewController.h"

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
    self.title = @"经理提成详细";
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
    NSString * urlStr;
    switch (_fromType) {
        case 25:
            urlStr = [SERVER_URL stringByAppendingString:SVC_GET_AGENT_DAY_COM_LIST];
            break;
        case 26:
            urlStr = [SERVER_URL stringByAppendingString:SVC_GET_AGENT_MONTH_COM_LIST];
            break;
        case 27:
            urlStr = [SERVER_URL stringByAppendingString:SVC_GET_AGENT_RATING_COM_LIST];
            break;
            
        default:
            break;
    }
    
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
                  _lblDayBonus.text = [NSString stringWithFormat:@"%@次",[latestLoans objectForKey:@"tot_buy_num"]];
                  _lblMonthBonus.text = [NSString stringWithFormat:@"%@元",[latestLoans objectForKey:@"tot_buy_money"]];
                  _lblTotalBonus.text = [NSString stringWithFormat:@"%@元",[latestLoans objectForKey:@"tot_commission"]];
                  NSArray *notificationlists = [latestLoans objectForKey:@"commodities"];
                  for (NSDictionary *items in notificationlists) {
                      AgentCommission *notiItem = [AgentCommission alloc];
                      notiItem.reg_date = [items objectForKey:@"reg_date"];
                      notiItem.amount = [[items objectForKey:@"amount"] floatValue];
                      notiItem.buyer_id = [[items objectForKey:@"buyer_id"] longValue];
                      notiItem.buyer_name = [items objectForKey:@"buyer_name"];
                      notiItem.direct_invite = [items objectForKey:@"direct_invite"];
                      notiItem.goods_name = [items objectForKey:@"goods_name"];
                      notiItem.goods_price = [[items objectForKey:@"goods_price"] floatValue];
                      notiItem.Commission_id = [[items objectForKey:@"id"] longValue];
                      notiItem.invite_id = [[items objectForKey:@"invite_id"] longValue];
                      notiItem.rate = [[items objectForKey:@"rate"] intValue];
                      notiItem.user_id = [[items objectForKey:@"user_id"] longValue];
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
        cell.lblCommission.text = [NSString stringWithFormat:@"%.02f元", info.amount];
        if (cell.gestureRecognizers.count == 0)
        {
            [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)]];
        }
    }
    return cell;
}
- (void)tapCell:(UITapGestureRecognizer *)inGestureRecognizer
{
    NSIndexPath *theIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)inGestureRecognizer.view];
    if (theIndexPath.row < [commissions count]){// && self.detailFlag != DETAIL_ABLE_FLAG){
        AgentCommission *info = [commissions objectAtIndex:theIndexPath.row];
        //goto nib of story board
        CommissionDetailViewController *vc = [[CommissionDetailViewController alloc] initWithNibName:@"CommissionDetailViewController" bundle:nil];
        // Push the view controller.
        vc.strDirectInvite = [NSString stringWithFormat:@"直接推荐：%@", info.direct_invite];
        vc.strBuyerName = [NSString stringWithFormat:@"客户姓名：%@", info.buyer_name];
        vc.strGoodsName = [NSString stringWithFormat:@"商品名称：%@", info.goods_name];
        vc.strRegDate = [NSString stringWithFormat:@"购买日期：%@", info.reg_date];
        vc.strGoodsPrice = [NSString stringWithFormat:@"购买金额：%.02f元", info.goods_price];
        vc.strRate = [NSString stringWithFormat:@"提成率：%d%%", info.rate];
        vc.strAmount = [NSString stringWithFormat:@"提成金额：%.02f元", info.amount];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
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
