//
//  RecoverPwdViewController.m
//  youtu
//
//  Created by qqq on 12/28/15.
//  Copyright © 2015 Christopher sh. All rights reserved.
//

#import "RecoverPwdViewController.h"
#import "SignUpViewController.h"

@interface RecoverPwdViewController (){
	UITextField *currentTextField;
    NSTimer *updateTimer;
    int waitTime;
}

@end

@implementation RecoverPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = STR_RECOVER_PWD;
	
	self.txtPhoneNum.leftImgName = @"icon_phone.png";
	[self.txtPhoneNum changeLeftImage];
	self.txtSMS.leftImgName = @"ic_usersms.png";
	[self.txtSMS changeLeftImage];
	self.txtPwd.leftImgName = @"icon_pw.png";
	[self.txtPwd changeLeftImage];
	self.txtRePwd.leftImgName = @"icon_pw.png";
	[self.txtRePwd changeLeftImage];
		
	self.sendSMS.layer.cornerRadius = 5.0f;
	self.sendSMS.layer.borderWidth = 1.0f;
	self.sendSMS.layer.borderColor = [UIColor clearColor].CGColor;
	self.sendSMS.layer.masksToBounds = YES;
	
	self.nextBtn.layer.cornerRadius = 5.0f;
	self.nextBtn.layer.borderWidth = 1.0f;
	self.nextBtn.layer.borderColor = [UIColor clearColor].CGColor;
	self.nextBtn.layer.masksToBounds = YES;
	
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

- (IBAction)gotoRegist:(id)sender {
	// Create the next view controller.
	SignUpViewController *signUpViewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
	// Push the view controller.
	[self.navigationController pushViewController:signUpViewController animated:YES];

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
    else
    {
        [Common showProgress:self.view];	//Showing the progress message
        NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_RESET_PASSWORD];
        NSDictionary *data = @ {@"phone" : [NSString stringWithFormat:@"%@", self.txtPhoneNum.text],
            @"verify_code"  : [NSString stringWithFormat:@"%@", self.txtSMS.text],
            @"password"   : [NSString stringWithFormat:@"%@", self.txtPwd.text],
            @"confirmpw"   : [NSString stringWithFormat:@"%@", self.txtPwd.text]
        };
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:urlStr parameters:data
              success:^(AFHTTPRequestOperation *operation, id responseObject){
                  if([[responseObject objectForKey:@"errCode"] intValue] == 0)
                  {
                      [Common showMessage:@"重置密码成功"];
                      [UserInfoKit sharedKit].phone = self.txtPhoneNum.text;
                      [UserInfoKit sharedKit].password = self.txtPwd.text;
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                  else
                  {
                      [Common showMessage:[responseObject objectForKey:@"errMsg"]];
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

-(void) getSMS
{
    [Common showProgress:self.view];	//Showing the progress message
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GET_SMS2];
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
              } else {
                  [Common showMessage:[responseObject objectForKey:@"errMsg"]];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];	//Hiding the progress message
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
        [self.sendSMS setTitle:@"验证码" forState:UIControlStateNormal];
        [self.sendSMS setBackgroundColor:RGBA(236, 105, 65, 1)];

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
