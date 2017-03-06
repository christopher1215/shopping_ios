//
//  MyReqFriendViewController.m
//  shopping
//
//  Created by Macbook on 01/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "MyReqFriendViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface MyReqFriendViewController (){
    NSString *invite_code;
    NSString *invite_url;
}

@end

@implementation MyReqFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.codeView.layer.cornerRadius = 5.0f;
    self.codeView.layer.borderWidth = 1.0f;
    self.codeView.layer.borderColor = RGB(238, 80, 60).CGColor;
    self.codeView.layer.masksToBounds = YES;
    
    self.btnOk.layer.cornerRadius = 5.0f;
    self.btnOk.layer.borderWidth = 1.0f;
    self.btnOk.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnOk.layer.masksToBounds = YES;
    
    [self getInfo];
}

- (void)getInfo{
    [Common showProgress:self.view];	//Showing the progress message
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GET_INVITE_CODE];
    NSDictionary *data = @ {@"user_id" : [NSString stringWithFormat:@"%ld", [UserInfoKit sharedKit].userID]
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              [Common hideProgress];	//Hiding the progress message
              NSDictionary *latestLoans = [Common fetchData:responseObject];
              if (latestLoans) {
                  invite_code = [latestLoans objectForKey:@"invite_code"];
                  _lblCode.text = invite_code;
                  invite_url = [latestLoans objectForKey:@"invite_url"];
                  int user_agent2_invite_min = [[latestLoans objectForKey:@"user_agent2_invite_min"] intValue];
                  int agent2_md_agent1_invite_min = [[latestLoans objectForKey:@"agent2_md_agent1_invite_min"] intValue];
                  int agent2_agent1_invite_min = [[latestLoans objectForKey:@"agent2_agent1_invite_min"] intValue];
                  _lblCondition.text = [NSString stringWithFormat:@"直接推广%d人升级为部门经理， 直接推广%d人并且这%d人中有%d个 升级成为部门经理了，部门经理可自动升级为高级经理",user_agent2_invite_min,agent2_agent1_invite_min,agent2_agent1_invite_min,agent2_md_agent1_invite_min];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];	//Hiding the progress message
              //[Common showMessage:ERR_CONNECTION];		//Showing the message for "server-connection fail"
          }];

}
- (IBAction)onShare:(id)sender {
    UIImage *image = [UIImage imageNamed:@"logo.png"];
    
    NSArray* imageArray = @[image];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSURL *sharelink = [NSURL URLWithString:[NSString stringWithFormat:@"%@", invite_url]];
    [shareParams SSDKSetupShareParamsByText:@"最牛商城，问鼎商城欢迎您。"
                                     images:imageArray
                                        url:sharelink
                                      title:@"辽宁问鼎收藏品有限公司"
                                       type:SSDKContentTypeWebPage];
    [shareParams SSDKEnableUseClientShare];
    
    //NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    //进行分享
    [ShareSDK showShareActionSheet:self.view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                           
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                       //[theController showLoadingView:NO];
                       // [theController.tableView reloadData];
                   }
                   
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
