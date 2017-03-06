//
//  RecommendViewController.m
//  shopping
//
//  Created by Macbook on 2/13/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "RecommendViewController.h"
#import "LogInViewController.h"

#import "DDKit.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface RecommendViewController (){
    NSString *invite_code;
    NSString *invite_url;
    NSString *invite_qr_url;
}

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, 0, 44, 44)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.tabBarController.navigationItem setRightBarButtonItem:rightBtnItem];
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
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_INVITE_FRIENDS];
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
                  
                  invite_code = [latestLoans objectForKey:@"invite_code"];
                  invite_url = [latestLoans objectForKey:@"invite_url"];
                  invite_qr_url = [latestLoans objectForKey:@"invite_qr_url"];
                  [self.imgQr sd_setImageWithURL:[NSURL URLWithString:invite_qr_url] placeholderImageScale:[UIImage imageNamed:@"noImage.jpg"]];
              }
              [Common hideProgress];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];
              //[Common showMessage:ERR_CONNECTION];
          }];
}
- (void)rightBtnClick{
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
