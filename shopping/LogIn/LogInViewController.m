//
//  LogInViewController.m
//  youtu
//
//  Created by princemac on 12/26/15.
//  Copyright © 2015 Christopher sh. All rights reserved.
//

#import "LogInViewController.h"
#import "SignUpViewController.h"
#import "RecoverPwdViewController.h"
#import "ManagerViewController.h"

#import "JPUSHService.h"

@interface LogInViewController ()
{
    UITextField *currentTextField;
}

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.title = STR_LOGIN;
    
    self.txtUserId.leftImgName = @"icon_phone.png";
    [self.txtUserId changeLeftImage];
    self.txtPassword.leftImgName = @"icon_pw.png";
    [self.txtPassword changeLeftImage];
    
    self.btnLogIn.layer.cornerRadius = 5.0f;
    self.btnLogIn.layer.borderWidth = 1.0f;
    self.btnLogIn.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnLogIn.layer.masksToBounds = YES;
    

    [Common addDoneToolBarToKeyboard:self.txtUserId viewController:self];
    [Common addDoneToolBarToKeyboard:self.txtPassword viewController:self];
	[Common registerNotifications:self];
   
	if([[UIScreen mainScreen] bounds].size.width > 320){
		self.btnSignUpWidth.constant = 157;
		self.btnRecoverPwdWidth.constant = 157;
		//		[self.btnSignUp setFrame:CGRectMake(0, 0, 130, 40)];
		//		[self.btnRecoverPwd setFrame:CGRectMake(0, 0, 130, 40)];
	}
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
	if([currentTextField isFirstResponder] && [[UIScreen mainScreen] bounds].size.height <= 480) {
		CGRect rect = CGRectMake(0, -15, self.view.frame.size.width, self.view.frame.size.height);
		[Common animateControl:self.view endRect:rect];
	}
	
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
	if([currentTextField isFirstResponder] && [[UIScreen mainScreen] bounds].size.height <= 480) {
		CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
		[Common animateControl:self.view endRect:rect];
	}
}

-(void)doneButtonClickedDismissKeyboard
{
    [currentTextField resignFirstResponder];
}

- (IBAction)onLogin:(id)sender {
	if ([self.txtUserId.text isEqual:@""]) {
		[Common showMessage:ERR_PHONE_EMPTY];
	} else if([self.txtPassword.text isEqual:@""]) {
		[Common showMessage:ERR_PASSWORD_EMPTY];
	} else {
		[Common showProgress:self.view];
		[self loginAction];
	}
}

- (void)loginAction
{
    NSString * urlStr = [SERVER_URL stringByAppendingString:_fromType == 3?SVC_AGENT_LOGIN: SVC_LOGIN];
	NSDictionary *data = @ {@"phone" : [NSString stringWithFormat:@"%@", self.txtUserId.text],
        @"password" : [NSString stringWithFormat:@"%@", self.txtPassword.text]
    };
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[Common showProgress:self.view];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
	[manager POST:urlStr parameters:data
		  success:^(AFHTTPRequestOperation *operation, id responseObject){
			  NSDictionary *latestLoans = [Common fetchData:responseObject];
			  if (latestLoans) {
                  if (_fromType == 3) {
                      
                      ManagerViewController *vc = [[ManagerViewController alloc] initWithNibName:@"ManagerViewController" bundle:nil];
                      // Push the view controller.
                      [self.navigationController pushViewController:vc animated:YES];
                  } else {
                      
                      [UserInfoKit sharedKit].userID = [[latestLoans objectForKey:@"user_id"] intValue];
                      [UserInfoKit sharedKit].phone = self.txtUserId.text;
                      [UserInfoKit sharedKit].password = self.txtPassword.text;
                      
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
                      [UserInfoKit sharedKit].contact_qq = [latestLoans objectForKey:@"contact_qq"];
                      
                      [JPUSHService setAlias:[UserInfoKit sharedKit].jpush_alias_code callbackSelector:nil
                                      object:self];
                      [self.navigationController popViewControllerAnimated:YES];
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


- (IBAction)goSignUp:(id)sender {
	// Create the next view controller.
	SignUpViewController *signUpViewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    signUpViewController.parentView = self;
	// Push the view controller.
	[self.navigationController pushViewController:signUpViewController animated:YES];
}

- (IBAction)goRecoverPwd:(id)sender {
	// Create the next view controller.
	RecoverPwdViewController *recoverPwdViewController = [[RecoverPwdViewController alloc] initWithNibName:@"RecoverPwdViewController" bundle:nil];
	// Push the view controller.
	[self.navigationController pushViewController:recoverPwdViewController animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL bFlag = YES;
    if (textField == self.txtUserId) {
        NSUInteger maxLength = 11;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        return bFlag;
    } else if (textField == self.txtPassword) {
        NSUInteger maxLength = 40;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        return bFlag;
    }
    return bFlag;
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.txtUserId.text = [UserInfoKit sharedKit].phone;
    self.txtPassword.text = _fromType==3?@"":[UserInfoKit sharedKit].password;
    if (_fromType != 3) {
        if (!([self.txtUserId.text isEqualToString:@""] || [self.txtPassword.text isEqualToString:@""])) {
            [self loginAction];
        }
    } else {
        [_btnSignUp setHidden:YES];
        [_btnRecoverPwd setHidden:YES];

    }
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        if(self.fromType == 1)
        {
            NSArray *viewControllers = self.navigationController.viewControllers;
            for (UIViewController *vc in viewControllers)
            {
//                if([vc isKindOfClass:[HomeViewController class]])
//                {
//                    [self.navigationController popToViewController:vc animated:NO];
//                    break;
//                }
            }
        }
    }
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
