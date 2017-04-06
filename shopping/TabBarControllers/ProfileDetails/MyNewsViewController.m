//
//  MyNewsViewController.m
//  shopping
//
//  Created by Macbook on 28/02/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "MyNewsViewController.h"
#import "NewsTableViewCell.h"

#import "MJRefresh.h"
#import "Notification.h"

@interface MyNewsViewController ()
{
    NSMutableArray *notifications;
}
@property (nonatomic) int last_id;

@end

@implementation MyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    notifications = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    
    [self addFooter];
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
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GET_MESSAGE_LIST];
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
                  [notifications removeAllObjects];
              }
              
              NSDictionary *latestLoans = [Common fetchData:responseObject];
              if(latestLoans) {
                  NSArray *notificationlists = [latestLoans objectForKey:@"commodities"];
                  for (NSDictionary *items in notificationlists) {
                      Notification *notiItem = [Notification alloc];
                      notiItem.notification_id = [[items objectForKey:@"id"] integerValue];
                      notiItem.message_type = [items objectForKey:@"message_type"];
                      if ([[items objectForKey:@"content"] isKindOfClass:[NSNull class]]) {
                          notiItem.content = @"";
                      } else {
                          notiItem.content = [items objectForKey:@"content"];
                      }
                      notiItem.reg_date = [items objectForKey:@"reg_date"];

                      [notifications addObject:notiItem];
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
    if(notifications.count == 0)
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
    return [notifications count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsCell"];
    }
    if (indexPath.row < [notifications count]){
        Notification *info = [Notification alloc];
        info = [notifications objectAtIndex:indexPath.row];
        cell.lblContent.text = [NSString stringWithFormat:@"  %@", info.content];
        cell.lblKind.text = [NSString stringWithFormat:@"  %@", info.message_type];
        cell.lblTime.text = [NSString stringWithFormat:@"  %@", info.reg_date];
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
