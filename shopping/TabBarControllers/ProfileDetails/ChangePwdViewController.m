//
//  ChangePwdViewController.m
//  shopping
//
//  Created by Macbook on 28/02/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()
{
    UITextField *currentTextField;
}

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnOk.layer.cornerRadius = 5.0f;
    self.btnOk.layer.borderWidth = 1.0f;
    self.btnOk.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnOk.layer.masksToBounds = YES;
    
    [Common addDoneToolBarToKeyboard:self.txtPassword viewController:self];
    [Common addDoneToolBarToKeyboard:self.txtRepassword viewController:self];
    [Common registerNotifications:self];
}
- (IBAction)onChangePassword:(id)sender {
    if([self.txtPassword.text isEqualToString:@""])
    {
        [Common showMessage:@"密码不能为空，请输入新密码"];
    }
    else if([self.txtRepassword.text isEqualToString:@""])
    {
        [Common showMessage:@"请再输入一次密码"];
    }
    else if(![self.txtPassword.text isEqualToString:self.txtRepassword.text])
    {
        [Common showMessage:@"密码两次输入不一致"];
    }
    else
    {
        [Common showProgress:self.view];	//Showing the progress message
        NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_CHANGEPW];
        NSDictionary *data = @ {@"phone" : [NSString stringWithFormat:@"%@", [UserInfoKit sharedKit].phone],
            @"password"   : [NSString stringWithFormat:@"%@", self.txtPassword.text],
            @"confirmpw"   : [NSString stringWithFormat:@"%@", self.txtPassword.text]
        };
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:urlStr parameters:data
              success:^(AFHTTPRequestOperation *operation, id responseObject){
                  if([[responseObject objectForKey:@"errCode"] intValue] == 0)
                  {
                      [Common showMessage:@"新密码设置成功"];
                      [UserInfoKit sharedKit].password = self.txtPassword.text;
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
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [Common animateControl:self.view endRect:rect];
    }else if([currentTextField isFirstResponder] && [[UIScreen mainScreen] bounds].size.height <= 568) {
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [Common animateControl:self.view endRect:rect];
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if([currentTextField isFirstResponder] && [[UIScreen mainScreen] bounds].size.height <= 568) {
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [Common animateControl:self.view endRect:rect];
    }
}

-(void)doneButtonClickedDismissKeyboard
{
    [currentTextField resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL bFlag = YES;
    NSUInteger maxLength = 40;
    bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
    return bFlag;
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
