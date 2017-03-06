//
//  WithdrawViewController.m
//  shopping
//
//  Created by Macbook on 28/02/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "WithdrawViewController.h"

@interface WithdrawViewController ()

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnOk.layer.cornerRadius = 5.0f;
    self.btnOk.layer.borderWidth = 1.0f;
    self.btnOk.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnOk.layer.masksToBounds = YES;

    _lblCurrentMoney.text = [NSString stringWithFormat:@"%.02f", [UserInfoKit sharedKit].current_money];
    
}
- (IBAction)onRequestMoney:(id)sender {
    [Common showProgress:self.view];	//Showing the progress message
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_REQUEST_MONEY];
    NSDictionary *data = @ {@"user_id" : [NSString stringWithFormat:@"%ld", [UserInfoKit sharedKit].userID],
        @"req_money"   : [NSString stringWithFormat:@"%@", self.txtReqMoney.text]
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              [Common hideProgress];	//Hiding the progress message
              NSDictionary *latestLoans = [Common fetchData:responseObject];
              if (latestLoans) {
                  [UserInfoKit sharedKit].current_money = [[latestLoans objectForKey:@"current_money"] floatValue];
                  _lblCurrentMoney.text = [NSString stringWithFormat:@"%.02f", [UserInfoKit sharedKit].current_money];
                  [Common showMessage:@"提款申请成功!"];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];	//Hiding the progress message
              //[Common showMessage:ERR_CONNECTION];		//Showing the message for "server-connection fail"
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
