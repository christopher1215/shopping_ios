//
//  RecoverPwdViewController.h
//  youtu
//
//  Created by qqq on 12/28/15.
//  Copyright © 2015 Christopher sh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftImageTextField.h"

@interface RecoverPwdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *sendSMS;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet LeftImageTextField *txtPhoneNum;
@property (weak, nonatomic) IBOutlet LeftImageTextField *txtSMS;
@property (weak, nonatomic) IBOutlet LeftImageTextField *txtPwd;
@property (weak, nonatomic) IBOutlet LeftImageTextField *txtRePwd;

@end
