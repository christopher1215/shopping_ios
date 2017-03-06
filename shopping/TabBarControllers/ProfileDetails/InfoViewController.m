//
//  InfoViewController.m
//  shopping
//
//  Created by Macbook on 27/02/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "InfoViewController.h"
#import "DDKit.h"

@interface InfoViewController ()
{
    FDTakeController *takeController;
    UITextField *currentTextField;
    short currentFrontBackFlag;
}
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnSave.layer.cornerRadius = 5.0f;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnSave.layer.masksToBounds = YES;

    self.txtName.text = [UserInfoKit sharedKit].name;
    self.txtPhone.text = [UserInfoKit sharedKit].phone;
    self.txtBankName.text = [UserInfoKit sharedKit].bank_name;
    self.txtBankCardid.text = [UserInfoKit sharedKit].bank_cardid;
    self.txtBankAccount.text = [UserInfoKit sharedKit].bank_account;
    [self.imgIDForward sd_setImageWithURL:[NSURL URLWithString:[UserInfoKit sharedKit].idcard_front_img] placeholderImageScale:[UIImage imageNamed:@"ID_Forward.png"]];
    [self.imgIDBack sd_setImageWithURL:[NSURL URLWithString:[UserInfoKit sharedKit].idcard_back_img] placeholderImageScale:[UIImage imageNamed:@"ID_Back.png"]];
    
    [Common addDoneToolBarToKeyboard:self.txtName viewController:self];
    [Common addDoneToolBarToKeyboard:self.txtPhone viewController:self];
    [Common addDoneToolBarToKeyboard:self.txtBankName viewController:self];
    [Common addDoneToolBarToKeyboard:self.txtBankCardid viewController:self];
    [Common addDoneToolBarToKeyboard:self.txtBankAccount viewController:self];
    [Common addDoneToolBarToKeyboard:self.txtIDCardNum viewController:self];
    [Common registerNotifications:self];
    
    //FD Takecontroller
    takeController = [[FDTakeController alloc] init];
    takeController.viewControllerForPresentingImagePickerController = self;
    takeController.delegate = self;
    takeController.allowsEditingPhoto = YES;

//    [self getInfo];
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
        CGRect rect = CGRectMake(0, -140, self.view.frame.size.width, self.view.frame.size.height);
        [Common animateControl:self.view endRect:rect];
    }else if([currentTextField isFirstResponder] && [[UIScreen mainScreen] bounds].size.height <= 568) {
        CGRect rect = CGRectMake(0, -60, self.view.frame.size.width, self.view.frame.size.height);
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
    if (textField == self.txtPhone) {
        NSUInteger maxLength = 11;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        if ([string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet].location != NSNotFound)
        {
            // BasicAlert(@"", @"This field accepts only numeric entries.");
            return NO;
        }
        
        return bFlag;
    } else if (textField == self.txtIDCardNum) {
        NSUInteger maxLength = 18;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        return bFlag;
    }else{
        NSUInteger maxLength = 20;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        return bFlag;
    }
    return bFlag;
}
- (void)getInfo
{
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GETBANKINFO];
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
                  [UserInfoKit sharedKit].name = [latestLoans objectForKey:@"name"];
                  [UserInfoKit sharedKit].bank_account = [latestLoans objectForKey:@"bank_account"];
                  [UserInfoKit sharedKit].bank_cardid = [latestLoans objectForKey:@"bank_cardid"];
                  [UserInfoKit sharedKit].bank_name = [latestLoans objectForKey:@"bank_name"];
                  [UserInfoKit sharedKit].idcard_back_img = [latestLoans objectForKey:@"idcard_back_img"];
                  [UserInfoKit sharedKit].idcard_front_img = [latestLoans objectForKey:@"idcard_front_img"];
                  [UserInfoKit sharedKit].idcard_num = [latestLoans objectForKey:@"idcard_num"];
                  
                  [self.navigationController popViewControllerAnimated:YES];
              }
              [Common hideProgress];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];
              //[Common showMessage:ERR_CONNECTION];
          }];
}

- (IBAction)onSave:(id)sender {
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_SAVEBANKINFO];
    NSDictionary *data = @ {
        @"user_id" : [NSString stringWithFormat:@"%ld", [UserInfoKit sharedKit].userID],
        @"name" : [NSString stringWithFormat:@"%@", self.txtName.text],
        @"bank_name" : [NSString stringWithFormat:@"%@", self.txtBankName.text],
        @"bank_cardid" : [NSString stringWithFormat:@"%@", self.txtBankCardid.text],
        @"bank_account" : [NSString stringWithFormat:@"%@", self.txtBankAccount.text],
        @"idcard_num" : [NSString stringWithFormat:@"%@", self.txtIDCardNum.text]
    };
    [Common showProgress:self.view];	//Showing the progress message
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              [Common hideProgress];
              NSDictionary *latestLoans = [Common fetchData:responseObject];
              if (latestLoans) {
                  [UserInfoKit sharedKit].name = self.txtName.text;
                  [UserInfoKit sharedKit].bank_account = self.txtBankAccount.text;
                  [UserInfoKit sharedKit].bank_cardid = self.txtBankCardid.text;
                  [UserInfoKit sharedKit].bank_name = self.txtBankName.text;
                  [UserInfoKit sharedKit].idcard_num = self.txtIDCardNum.text;

                  [Common showMessage:@"保存成功了！"];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];
              //[Common showMessage:ERR_CONNECTION];
          }];
}
- (IBAction)onUploadFrontIDImg:(id)sender {
    currentFrontBackFlag = 1;
    [takeController takePhotoOrChooseFromLibrary];
}
- (IBAction)onUploadBackIDimg:(id)sender {
    currentFrontBackFlag = 0;
    [takeController takePhotoOrChooseFromLibrary];
}
- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info {
    if (currentFrontBackFlag) {
        [Common uploadImages:photo protocolName:SVC_UP_CHARACTER_IMG viewController:self name:@"img_input_1" ind:@"1"];
    } else {
        [Common uploadImages:photo protocolName:SVC_UP_CHARACTER_IMG viewController:self name:@"img_input_2" ind:@"2"];
    }
}
- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt {
    
}

- (void)takeController:(FDTakeController *)controller didFailAfterAttempting:(BOOL)madeAttempt {
    [Common showMessage:ERR_FACEIMAGE_SETTING_FAIL];
}

- (void) postImgData:(NSString *) imgUrl image:(UIImage*)photo{
    if(photo != nil)
    {
        if (currentFrontBackFlag) {
            [self.imgIDForward setImage:photo];
        }else{
            [self.imgIDBack setImage:photo];
        }
        
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
