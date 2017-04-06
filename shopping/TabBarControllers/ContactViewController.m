//
//  ContactViewController.m
//  shopping
//
//  Created by Macbook on 2/13/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "ContactViewController.h"
#import "LogInViewController.h"
#import "ContactTableViewCell.h"

#import "ContactWith.h"

@interface ContactViewController ()
{
    NSMutableArray *contacts;
    NSString *parent_name;
}
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    contacts = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    _lblParent.text = [NSString stringWithFormat:@"上级客户：%@", _strParent_Name];
    if(self.detailFlag != DETAIL_ABLE_FLAG) _tblTop.constant = 0;
    else  _tblTop.constant = 40;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([UserInfoKit sharedKit].userID > UNLOGIN_FLAG){
        [self getInfo];
    } else {
        [self gotoLogin];
    }
}
- (void)gotoLogin {
    // Create the next view controller.
    LogInViewController *loginViewController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
    // Push the view controller.
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}
- (void)getInfo
{
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_RELATIONSHIP];
    NSDictionary *data = @ {@"user_id" : [NSString stringWithFormat:@"%ld", self.user_id?self.user_id:[UserInfoKit sharedKit].userID]
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [Common showProgress:self.view];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              [contacts removeAllObjects];
              NSDictionary *tempDic = [Common fetchData:responseObject];
              if(tempDic){
                  parent_name = [tempDic objectForKey:@"parent_name"];
                  
                  NSArray *latestLoans = [tempDic objectForKey:@"commodities"];
                  if (latestLoans.count > 0) {
                      for (NSDictionary *latestloan in latestLoans) {
                          ContactWith *info = [ContactWith alloc];
                          info.user_id = [[latestloan objectForKey:@"user_id"] longValue];
                          if ([[latestloan objectForKey:@"phone"] isKindOfClass:[NSNull class]]) {
                              info.phone = @"";
                          } else {
                              info.phone = [latestloan objectForKey:@"phone"];
                          }
                          if ([[latestloan objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
                              info.name = @"";
                          } else {
                              info.name = [latestloan objectForKey:@"name"];
                          }
                          if ([[latestloan objectForKey:@"reg_date"] isKindOfClass:[NSNull class]]) {
                              info.reg_date = @"";
                          } else {
                              info.reg_date = [latestloan objectForKey:@"reg_date"];
                          }
                          info.level = [[latestloan objectForKey:@"level"] shortValue];

                          [contacts addObject:info];
                      }
                  }
              }
              [self.tableView reloadData];
              [Common hideProgress];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];
              //[Common showMessage:ERR_CONNECTION];
          }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(contacts.count == 0)
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
    return [contacts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactCell"];
    }
    if (indexPath.row < [contacts count]){
        if (indexPath.row % 2) {
            cell.contentView.backgroundColor = RGB(255, 255, 255);
        } else {
            cell.contentView.backgroundColor = RGB(230, 230, 230);
        }
        ContactWith *info = [ContactWith alloc];
        info = [contacts objectAtIndex:indexPath.row];
        [cell.lblPhone setText:info.phone];
        cell.lblName.text = info.name;
        cell.lblRegDate.text = info.reg_date;
        switch (info.level) {
            case 0:
                [cell.imgIcon setImage:[UIImage imageNamed:@"greenIcon.png"]];
                break;
            case 1:
                [cell.imgIcon setImage:[UIImage imageNamed:@"blueIcon.png"]];
                break;
            case 2:
                [cell.imgIcon setImage:[UIImage imageNamed:@"redIcon.png"]];
                break;
                
            default:
                break;
        }
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
    if (theIndexPath.row < [contacts count]){// && self.detailFlag != DETAIL_ABLE_FLAG){
        ContactWith *info = [contacts objectAtIndex:theIndexPath.row];
        //goto nib of story board
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContactViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ContactDetail"];
        vc.user_id = info.user_id;
        if(self.detailFlag != DETAIL_ABLE_FLAG) vc.title = STR_DETAIL_CONTACT;
        vc.detailFlag = DETAIL_ABLE_FLAG;
        vc.strParent_Name = parent_name;
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
