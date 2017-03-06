//
//  WalletViewController.m
//  shopping
//
//  Created by Macbook on 02/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "WalletViewController.h"
#import "WithdrawViewController.h"
#import "WalletTableViewCell.h"
#import "MJRefresh.h"
#import "BuyHistory.h"
#import "InfoViewController.h"

@interface WalletViewController ()
{
    NSMutableArray *histories;
}
@property (nonatomic) int last_id;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnReqWithdraw.layer.cornerRadius = 5.0f;
    self.btnReqWithdraw.layer.borderWidth = 1.0f;
    self.btnReqWithdraw.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnReqWithdraw.layer.masksToBounds = YES;
    [self getBaseInfo];
    
    histories = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"WalletTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self addFooter];
    [self addRefreshKit];

}
- (void)viewDidAppear:(BOOL)animated{
    self.historyBar.layer.shadowRadius  = 2.5f;
    self.historyBar.layer.shadowColor   = RGBA(0, 0, 0, 0.2).CGColor;
    self.historyBar.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.historyBar.layer.shadowOpacity = 0.7f;
    self.historyBar.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.0f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(CGRectMake(self.historyBar.frame.origin.x, self.historyBar.frame.origin.x, [[UIScreen mainScreen]bounds].size.width, self.historyBar.frame.size.height), shadowInsets)];
    self.historyBar.layer.shadowPath    = shadowPath.CGPath;
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
        [weakSelf getInfo:weakSelf.last_id];
    }];
    self.tableView.header.automaticallyChangeAlpha = YES;
    [self.tableView.header beginRefreshing];
    
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    self.tableView.footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getInfo:weakSelf.last_id];
    }];
}
- (void)getInfo:(int)last_id
{
    __weak typeof(self) weakSelf = self;
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GET_BUY_LIST];
    NSDictionary *data = @ {
        @"user_id":[NSString stringWithFormat:@"%ld", [UserInfoKit sharedKit].userID],
        @"last_id":[NSString stringWithFormat:@"%d", last_id],
        @"start":@"0",
        @"page_num":[NSString stringWithFormat:@"%d", RowsPerPage]
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              if (last_id == 0) {
                  [histories removeAllObjects];
              }
              
              NSDictionary *latestLoans = [Common fetchData:responseObject];
              if(latestLoans) {
                  NSArray *notificationlists = [latestLoans objectForKey:@"commodities"];
                  for (NSDictionary *items in notificationlists) {
                      BuyHistory *notiItem = [BuyHistory alloc];
                      notiItem.buy_date = [items objectForKey:@"buy_date"];
                      notiItem.goods_name = [items objectForKey:@"goods_name"];
                      notiItem.goods_price = [[items objectForKey:@"goods_price"] floatValue];
                      
                      [histories addObject:notiItem];
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
    if(histories.count == 0)
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
    return [histories count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row < [histories count]){
        BuyHistory *info = [BuyHistory alloc];
        info = [histories objectAtIndex:indexPath.row];
        cell.lblBuyDate.text = [NSString stringWithFormat:@"%@", info.buy_date];
        cell.lblGoodsName.text = [NSString stringWithFormat:@"%@", info.goods_name];
        cell.lblGoodsPrice.text = [NSString stringWithFormat:@"¥%.02f", info.goods_price];
    }
    return cell;
}
- (IBAction)onGotoWithdraw:(id)sender {
    if ([[UserInfoKit sharedKit].name isEqualToString:@""] ||
        [[UserInfoKit sharedKit].bank_account isEqualToString:@""] ||
        [[UserInfoKit sharedKit].bank_cardid isEqualToString:@""] ||
        [[UserInfoKit sharedKit].bank_name isEqualToString:@""] ||
        [[UserInfoKit sharedKit].idcard_back_img isEqualToString:@""] ||
        [[UserInfoKit sharedKit].idcard_front_img isEqualToString:@""] ||
        [[UserInfoKit sharedKit].idcard_num isEqualToString:@""]
        ) {
        InfoViewController *vc = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
        vc.title = STR_MYINFO;
        // Push the view controller.
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        WithdrawViewController *vc = [[WithdrawViewController alloc] initWithNibName:@"WithdrawViewController" bundle:nil];
        vc.title = STR_WTHDRAW;
        // Push the view controller.
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)getBaseInfo
{
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GET_WALLET_INFO];
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
                  _lblCurrentMoney.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"current_money"] floatValue]];
                  [UserInfoKit sharedKit].current_money = [[latestLoans objectForKey:@"current_money"] floatValue];
                  _lblInviteUsers.text = [NSString stringWithFormat:@"%d", [[latestLoans objectForKey:@"invite_users"] intValue]];
                  _lblBuyMoney.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"buy_money"] floatValue]];
                  _lblInviteMoney.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"invite_money"] floatValue]];
                  _lblTotalCommission.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"total_commision"] floatValue]];
                  if ([UserInfoKit sharedKit].current_money > 0) {
                      [_btnReqWithdraw setEnabled:YES];
                      [_btnReqWithdraw setAlpha:1];
                  } else {
                      [_btnReqWithdraw setEnabled:NO];
                      [_btnReqWithdraw setAlpha:0.5];
                  }
              }
              [Common hideProgress];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];
              //[Common showMessage:ERR_CONNECTION];
          }];
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
