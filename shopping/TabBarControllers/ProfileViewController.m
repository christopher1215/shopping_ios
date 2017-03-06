//
//  ProfileViewController.m
//  shopping
//
//  Created by Macbook on 2/13/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "ProfileViewController.h"
#import "LogInViewController.h"
#import "InfoViewController.h"
#import "ChangePwdViewController.h"
#import "MyNewsViewController.h"
#import "WithdrawViewController.h"
#import "MyReqFriendViewController.h"
#import "AboutUsViewController.h"
#import "ContactUsViewController.h"
#import "WalletViewController.h"

#import "DDKit.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGFloat tabWidth = [[UIScreen mainScreen] bounds].size.width / 3;
    CGFloat tabHeight = _tabBtnView.frame.size.height / 2;
    _cart_out.frame = CGRectMake(0, 0, tabWidth, tabHeight);
    _members.frame = CGRectMake(tabWidth, 0, tabWidth, tabHeight);
    _wallet.frame = CGRectMake(tabWidth * 2, 0, tabWidth, tabHeight);
    _lblCartOut.frame = CGRectMake(0, tabHeight, tabWidth, tabHeight);
    _lblMemberCnt.frame = CGRectMake(tabWidth, tabHeight, tabWidth, tabHeight);
    _lblWallet.frame = CGRectMake(tabWidth * 2, tabHeight, tabWidth, tabHeight);
    _tabSeparator1.frame = CGRectMake(tabWidth, 8, 0.5, _tabBtnView.frame.size.height - 16);
    _tabSeparator2.frame = CGRectMake(tabWidth * 2, 8, 0.5, _tabBtnView.frame.size.height - 16);
    
    self.btnLogout.layer.cornerRadius = 5.0f;
    self.btnLogout.layer.borderWidth = 1.0f;
    self.btnLogout.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnLogout.layer.masksToBounds = YES;

    self.imgFace.layer.cornerRadius = self.imgFace.frame.size.width / 2;
    self.imgFace.layer.borderWidth = 2.0f;
    self.imgFace.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgFace.layer.masksToBounds = YES;

    if([UserInfoKit sharedKit].userID > UNLOGIN_FLAG){
        self.lblPhone.text = [UserInfoKit sharedKit].phone;
        self.lblName.text = [UserInfoKit sharedKit].name;
        self.lblRecommender.text = [NSString stringWithFormat:@"推荐人：%@",[UserInfoKit sharedKit].parent_name];
        self.lblRemain.text = [NSString stringWithFormat:@"剩余购买次数：%d",[UserInfoKit sharedKit].reamin_buy_num];
        self.lblCartOut.text = [NSString stringWithFormat:@"%d/%d",[UserInfoKit sharedKit].buy_num, [UserInfoKit sharedKit].dividend_num];
        self.lblMemberCnt.text = [UserInfoKit sharedKit].level_str;
        self.lblWallet.text = [NSString stringWithFormat:@"%.02f元",[UserInfoKit sharedKit].current_money];
        [self.btnLogout setHidden:NO];
    } else {
        [self.btnLogout setHidden:YES];
        [self gotoLogin];
    }
}

- (void)gotoLogin {
    // Create the next view controller.
    LogInViewController *loginViewController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
    // Push the view controller.
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}
- (IBAction)onLogout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:STR_LOGOUT
                                                    message:STR_CONFIRM_LOGOUT
                                                   delegate:self
                                          cancelButtonTitle:STR_NO
                                          otherButtonTitles:STR_YES, nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //do something?
            break;
        case 1: //"Yes" pressed
            //here you pop the viewController
            [UserInfoKit sharedKit].userID = UNLOGIN_FLAG;
            [UserInfoKit sharedKit].userID = 0;
            [UserInfoKit sharedKit].name = @"";
            [UserInfoKit sharedKit].phone = @"";
            [UserInfoKit sharedKit].password = @"";
            [UserInfoKit sharedKit].parent_name = @"";
            [UserInfoKit sharedKit].current_money = 0;
            [UserInfoKit sharedKit].buy_num = 0;
            [UserInfoKit sharedKit].dividend_num = 0;
            [UserInfoKit sharedKit].level_str = @"";
            [UserInfoKit sharedKit].idcard_back_img = @"";
            [UserInfoKit sharedKit].idcard_back_img = @"";
            [UserInfoKit sharedKit].bank_account = @"";
            [UserInfoKit sharedKit].bank_cardid = @"";
            [UserInfoKit sharedKit].bank_name = @"";
            [UserInfoKit sharedKit].idcard_num = @"";
            
            [self.btnLogout setHidden:YES];
            [self gotoPreviousPage];
            break;
    }
}
-(void)gotoPreviousPage
{
    [self.tabBarController setSelectedIndex:0];
}
- (IBAction)onGotoWallet:(id)sender {
    WalletViewController *vc = [[WalletViewController alloc] initWithNibName:@"WalletViewController" bundle:nil];
    vc.title = STR_MYWALLET;
    // Push the view controller.
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)onMyInfo:(id)sender {
    InfoViewController *vc = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    vc.title = STR_MYINFO;
    // Push the view controller.
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onChangePassword:(id)sender {
    ChangePwdViewController *vc = [[ChangePwdViewController alloc] initWithNibName:@"ChangePwdViewController" bundle:nil];
    vc.title = STR_CHANGEPWD;
    // Push the view controller.
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)onMyNews:(id)sender {
    MyNewsViewController *vc = [[MyNewsViewController alloc] initWithNibName:@"MyNewsViewController" bundle:nil];
    vc.title = STR_MYNEWS;
    // Push the view controller.
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)onWithraw:(id)sender {
    WithdrawViewController *vc = [[WithdrawViewController alloc] initWithNibName:@"WithdrawViewController" bundle:nil];
    vc.title = STR_WTHDRAW;
    // Push the view controller.
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)onRecommendFriend:(id)sender {
    MyReqFriendViewController *vc = [[MyReqFriendViewController alloc] initWithNibName:@"MyReqFriendViewController" bundle:nil];
    vc.title = STR_REQFRIEND;
    // Push the view controller.
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onContact:(id)sender {
    ContactUsViewController *vc = [[ContactUsViewController alloc] initWithNibName:@"ContactUsViewController" bundle:nil];
    vc.title = STR_CONTACTUS;
    // Push the view controller.
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)onAboutUs:(id)sender {
    AboutUsViewController *vc = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    vc.title = STR_ABOUTUS;
    // Push the view controller.
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)onLoginWithManager:(id)sender {
    LogInViewController *loginViewController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
    // Push the view controller.
    loginViewController.fromType = 3;
    [self.navigationController pushViewController:loginViewController animated:YES];    
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
