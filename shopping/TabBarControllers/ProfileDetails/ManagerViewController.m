//
//  ManagerViewController.m
//  shopping
//
//  Created by Macbook on 17/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "ManagerViewController.h"
#import "MgrBonusHistoryViewController.h"

@interface ManagerViewController ()

@end

@implementation ManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"经理提成情况";
    self.btnLogout.layer.cornerRadius = 5.0f;
    self.btnLogout.layer.borderWidth = 1.0f;
    self.btnLogout.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnLogout.layer.masksToBounds = YES;

    [self getBaseInfo];
}
- (void)getBaseInfo
{
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GET_AGENT_TOT_COMMISSION];
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
                  _lblLevelStr.text = [NSString stringWithFormat:@"会员等级：%@", [latestLoans objectForKey:@"level_str"]];
                  _lblTotalUsers.text = [NSString stringWithFormat:@"%d", [[latestLoans objectForKey:@"tot_user"] intValue]];
                  _lblTotalBuyMoney.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"tot_buy_money"] floatValue]];
                  _lblCommission.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"commission"] floatValue]];
                  _lblTotalCommission.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"total_commission"] floatValue]];
                  _lblRatingCommissionMoney.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"rating_commission_money"] floatValue]];
                  _lblMonthComission.text = [NSString stringWithFormat:@"%.02f", [[latestLoans objectForKey:@"month_commission"] floatValue]];
              }
              [Common hideProgress];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];
              //[Common showMessage:ERR_CONNECTION];
          }];
}
- (IBAction)gotoDayCommission:(id)sender {
    MgrBonusHistoryViewController *vc = [[MgrBonusHistoryViewController alloc] initWithNibName:@"MgrBonusHistoryViewController" bundle:nil];
    // Push the view controller.
    vc.fromType = 25;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)gotoMonth:(id)sender {
    MgrBonusHistoryViewController *vc = [[MgrBonusHistoryViewController alloc] initWithNibName:@"MgrBonusHistoryViewController" bundle:nil];
    // Push the view controller.
    vc.fromType = 26;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)gotoAVG:(id)sender {
    MgrBonusHistoryViewController *vc = [[MgrBonusHistoryViewController alloc] initWithNibName:@"MgrBonusHistoryViewController" bundle:nil];
    // Push the view controller.
    vc.fromType = 27;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onLogout:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
