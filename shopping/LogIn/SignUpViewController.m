//
//  SignUpViewController.m
//  youtu
//
//  Created by qqq on 12/28/15.
//  Copyright © 2015 Christopher sh. All rights reserved.
//

#import "SignUpViewController.h"
#import "RecoverPwdViewController.h"
#import "LogInViewController.h"
#import "JPUSHService.h"

@interface SignUpViewController (){
	UITextField *currentTextField;
    NSDateFormatter *dateFormatter;
    NSTimer *updateTimer;
    int waitTime;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = STR_SIGNUP;
    waitTime = 0;

	self.txtPhoneNum.leftImgName = @"icon_phone.png";
	[self.txtPhoneNum changeLeftImage];
	self.txtSMS.leftImgName = @"ic_usersms.png";
	[self.txtSMS changeLeftImage];
	self.txtPwd.leftImgName = @"icon_pw.png";
	[self.txtPwd changeLeftImage];
	self.txtRePwd.leftImgName = @"icon_pw.png";
	[self.txtRePwd changeLeftImage];
	
	self.backView.layer.cornerRadius = 5.0f;
	self.backView.layer.borderWidth = 1.0f;
	self.backView.layer.borderColor = [UIColor clearColor].CGColor;
	self.backView.layer.masksToBounds = YES;

	self.sendSMS.layer.cornerRadius = 5.0f;
	self.sendSMS.layer.borderWidth = 1.0f;
	self.sendSMS.layer.borderColor = [UIColor clearColor].CGColor;
	self.sendSMS.layer.masksToBounds = YES;
	
	self.nextBtn.layer.cornerRadius = 5.0f;
	self.nextBtn.layer.borderWidth = 1.0f;
	self.nextBtn.layer.borderColor = [UIColor clearColor].CGColor;
	self.nextBtn.layer.masksToBounds = YES;

    dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *chinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
    [dateFormatter setDateFormat:@"yyyy年 MM月 dd日"];
    [dateFormatter setLocale:chinaLocale];

	[Common addDoneToolBarToKeyboard:self.txtPhoneNum viewController:self];
	[Common addDoneToolBarToKeyboard:self.txtSMS viewController:self];
	[Common addDoneToolBarToKeyboard:self.txtPwd viewController:self];
	[Common addDoneToolBarToKeyboard:self.txtRePwd viewController:self];
	[Common registerNotifications:self];
    
    //UI view background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg_login.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//keyboard dismiss
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if([currentTextField isFirstResponder])
		[currentTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	currentTextField = textField;
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    if([currentTextField isFirstResponder] && [[UIScreen mainScreen] bounds].size.height <= 568 && (currentTextField == self.txtPwd || currentTextField == self.txtRePwd)) {
        CGRect rect = CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height);
        [Common animateControl:self.view endRect:rect];
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if([currentTextField isFirstResponder] && [[UIScreen mainScreen] bounds].size.height <= 568 && (currentTextField == self.txtPwd || currentTextField == self.txtRePwd)) {
        CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
        [Common animateControl:self.view endRect:rect];
    }
}

-(void)doneButtonClickedDismissKeyboard
{
	[currentTextField resignFirstResponder];
}

- (IBAction)goRecoverPwd:(id)sender {
	// Create the next view controller.
	RecoverPwdViewController *recoverPwdViewController = [[RecoverPwdViewController alloc] initWithNibName:@"RecoverPwdViewController" bundle:nil];
	// Push the view controller.
	[self.navigationController pushViewController:recoverPwdViewController animated:YES];
}

- (IBAction)onVerifyCode:(id)sender {
    if([self.txtPhoneNum.text isEqualToString:@""])
    {
        [Common showMessage:@"请输入手机号码"];
    }
    else
    {
        [self getSMS];
    }
}

- (IBAction)onOkBtn:(id)sender {
    if([self.txtPhoneNum.text isEqualToString:@""])
    {
        [Common showMessage:@"手机号码不能为空，请输入手机号码"];
    }
    else if([self.txtSMS.text isEqualToString:@""])
    {
        [Common showMessage:@"验证码不能为空，请输入验证码"];
    }
    else if([self.txtPwd.text isEqualToString:@""])
    {
        [Common showMessage:@"密码不能为空，请输入验证码"];
    }
    else if([self.txtRePwd.text isEqualToString:@""])
    {
        [Common showMessage:@"请再输入一次密码"];
    }
    else if(![self.txtPwd.text isEqualToString:self.txtRePwd.text])
    {
        [Common showMessage:@"密码两次输入不一致"];
    }
    else if([self.txtRecommendCode.text isEqualToString:@""])
    {
        [Common showMessage:@"推荐码不能为空。如果没有推荐码的话，请输入00000。"];
    }
    else
    {
        [Common showProgress:self.view];	//Showing the progress message
        NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_SIGN_UP];
        NSDictionary *data = @ {@"phone" : [NSString stringWithFormat:@"%@", self.txtPhoneNum.text],
            @"verify_code"  : [NSString stringWithFormat:@"%@", self.txtSMS.text],
            @"password"   : [NSString stringWithFormat:@"%@", self.txtPwd.text],
            @"confirmpw"   : [NSString stringWithFormat:@"%@", self.txtPwd.text],
            @"invite_code" : [NSString stringWithFormat:@"%@", self.txtRecommendCode.text]
        };
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:urlStr parameters:data
              success:^(AFHTTPRequestOperation *operation, id responseObject){
                  NSDictionary *latestLoans = [Common fetchData:responseObject];
                  if (latestLoans) {
                      
                      [UserInfoKit sharedKit].userID = [[latestLoans objectForKey:@"user_id"] intValue];
                      [UserInfoKit sharedKit].phone = self.txtPhoneNum.text;
                      [UserInfoKit sharedKit].password = self.txtPwd.text;
                      
                      [UserInfoKit sharedKit].name = [latestLoans objectForKey:@"name"];
                      [UserInfoKit sharedKit].level = [[latestLoans objectForKey:@"level"] shortValue];
                      [UserInfoKit sharedKit].parent_name = [latestLoans objectForKey:@"parent_name"];
                      [UserInfoKit sharedKit].remain_buy_num = [[latestLoans objectForKey:@"remain_buy_num"] intValue];
                      [UserInfoKit sharedKit].dividend_num = [[latestLoans objectForKey:@"dividend_num"] intValue];
                      [UserInfoKit sharedKit].buy_num = [[latestLoans objectForKey:@"buy_num"] intValue];
                      [UserInfoKit sharedKit].level_str = [latestLoans objectForKey:@"level_str"];
                      [UserInfoKit sharedKit].current_money = [[latestLoans objectForKey:@"current_money"] floatValue];
                      [UserInfoKit sharedKit].buy_money = [[latestLoans objectForKey:@"buy_money"] floatValue];
                      [UserInfoKit sharedKit].invite_money = [[latestLoans objectForKey:@"invite_money"] floatValue];
                      [UserInfoKit sharedKit].total_commision = [[latestLoans objectForKey:@"total_commision"] floatValue];
                      
                      [UserInfoKit sharedKit].bank_account = [latestLoans objectForKey:@"bank_account"];
                      [UserInfoKit sharedKit].bank_cardid = [latestLoans objectForKey:@"bank_cardid"];
                      [UserInfoKit sharedKit].bank_name = [latestLoans objectForKey:@"bank_name"];
                      [UserInfoKit sharedKit].commission_percent = [[latestLoans objectForKey:@"commission_percent"] floatValue];
                      [UserInfoKit sharedKit].contact_phone = [latestLoans objectForKey:@"contact_phone"];
                      [UserInfoKit sharedKit].dividend_money = [[latestLoans objectForKey:@"dividend_money"] floatValue];
                      [UserInfoKit sharedKit].idcard_back_img = [latestLoans objectForKey:@"idcard_back_img"];
                      [UserInfoKit sharedKit].idcard_front_img = [latestLoans objectForKey:@"idcard_front_img"];
                      [UserInfoKit sharedKit].idcard_num = [latestLoans objectForKey:@"idcard_num"];
                      [UserInfoKit sharedKit].invite_code = [latestLoans objectForKey:@"invite_code"];
                      [UserInfoKit sharedKit].invite_num = [[latestLoans objectForKey:@"invite_num"] floatValue];
                      [UserInfoKit sharedKit].invite_qr_url = [latestLoans objectForKey:@"invite_qr_url"];
                      [UserInfoKit sharedKit].invite_users = [[latestLoans objectForKey:@"invite_users"] intValue];
                      [UserInfoKit sharedKit].jpush_alias_code = [latestLoans objectForKey:@"jpush_alias_code"];
                      [UserInfoKit sharedKit].mgr_id = [[latestLoans objectForKey:@"mgr_id"] intValue];
                      [UserInfoKit sharedKit].month_commission_percent = [[latestLoans objectForKey:@"month_commission_percent"] floatValue];
                      [UserInfoKit sharedKit].parent1_id = [[latestLoans objectForKey:@"parent1_id"] intValue];
                      [UserInfoKit sharedKit].parent2_id = [[latestLoans objectForKey:@"parent2_id"] intValue];
                      [UserInfoKit sharedKit].rating_commission_money = [[latestLoans objectForKey:@"rating_commission_money"] floatValue];
                      [UserInfoKit sharedKit].rating_commission_num = [[latestLoans objectForKey:@"rating_commission_num"] floatValue];
                      [UserInfoKit sharedKit].recommender_flag = [[latestLoans objectForKey:@"recommender_flag"] shortValue];
                      [UserInfoKit sharedKit].recomment_userid = [[latestLoans objectForKey:@"recomment_userid"] intValue];
                      [UserInfoKit sharedKit].reg_date = [latestLoans objectForKey:@"reg_date"];
                      [UserInfoKit sharedKit].withdraw_agent_money = [[latestLoans objectForKey:@"withdraw_agent_money"] floatValue];
                      [UserInfoKit sharedKit].withdraw_agent_num = [[latestLoans objectForKey:@"withdraw_agent_num"] intValue];
                      [UserInfoKit sharedKit].withdraw_money = [[latestLoans objectForKey:@"withdraw_money"] floatValue];
                      [UserInfoKit sharedKit].withdraw_num = [[latestLoans objectForKey:@"withdraw_num"] intValue];
                      
                      [JPUSHService setAlias:[UserInfoKit sharedKit].jpush_alias_code callbackSelector:nil
                                      object:self];
                      
                      [self backBeforeLogin];
                  }
                  [Common hideProgress];	//Hiding the progress message
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  [Common hideProgress];	//Hiding the progress message
                  //[Common showMessage:ERR_CONNECTION];		//Showing the message for "server-connection fail"
              }];
    }
}

-(void) backBeforeLogin{
    NSArray *viewControllers = self.navigationController.viewControllers;
    BOOL loginFlag = NO;
    UIViewController *backVC;
    for (UIViewController *vc in viewControllers)
    {
        if (loginFlag) {
            [self.navigationController popToViewController:backVC animated:YES];
            break;
        }
        if([vc isKindOfClass:[LogInViewController class]])
        {
            loginFlag = YES;
            
        } else {
            backVC = vc;
        }
    }

}
-(void) getSMS
{
    [Common showProgress:self.view];	//Showing the progress message
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GET_SMS];
    NSDictionary *data = @ {@"phone" : [NSString stringWithFormat:@"%@", self.txtPhoneNum.text]
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              [Common hideProgress];	//Hiding the progress message
              if([[responseObject objectForKey:@"errCode"] intValue] == 0)
              {
                  updateTimer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                                 target: self
                                                               selector:@selector(onTick:)
                                                               userInfo: nil repeats:YES];
                  [self.sendSMS setEnabled:NO];
                  [self.sendSMS setBackgroundColor:RGBA(137, 106, 241, 0.6)];

                  if (IS_SHOW_SMS_MESG) {
                      [Common showMessage:[[responseObject objectForKey:@"datalist"] objectForKey:@"verify_code"]];
                  }
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];                    //Hiding the progress message
              //[Common showMessage:ERR_CONNECTION];		//Showing the message for "server-connection fail"
          }];
}
-(void) onTick:(NSTimer *)timer
{
    int litmitTime = 60;
    waitTime++;
    if(waitTime < litmitTime)
    {
        [self.sendSMS.titleLabel setText:[NSString stringWithFormat:@"%d(s)", litmitTime-waitTime]];
        [self.sendSMS setEnabled:NO];
        [self.sendSMS setTitle:[NSString stringWithFormat:@"%d(s)", litmitTime-waitTime] forState:UIControlStateDisabled];
    } else {
        waitTime = 0;
        [updateTimer invalidate];
        updateTimer = nil;
        //[self.sendSMS setTitle:@"验证码" forState:UIControlStateDisabled];
        //[self.sendSMS.titleLabel setText:@"验证码"];
        [self.sendSMS setEnabled:YES];
        [self.sendSMS setTitle:STR_SEND_SMS forState:UIControlStateNormal];
        [self.sendSMS setBackgroundColor:RGBA(137, 106, 241, 1)];

    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL bFlag = YES;
    if (textField == self.txtPhoneNum) {
        NSUInteger maxLength = 11;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        return bFlag;
    } else if (textField == self.txtSMS) {
        NSUInteger maxLength = 10;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        return bFlag;
    } else if (textField == self.txtPwd) {
        NSUInteger maxLength = 40;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        return bFlag;
    } else if (textField == self.txtRePwd) {
        NSUInteger maxLength = 40;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        return bFlag;
    } else if (textField == self.txtRecommendCode) {
        NSUInteger maxLength = 5;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        return bFlag;
    }
    return bFlag;
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
