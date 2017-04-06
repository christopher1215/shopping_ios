//
//  SignUpViewController.h
//  youtu
//
//  Created by qqq on 12/28/15.
//  Copyright © 2015 Christopher sh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftImageTextField.h"

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *sendSMS;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet LeftImageTextField *txtPhoneNum;
@property (weak, nonatomic) IBOutlet LeftImageTextField *txtSMS;
@property (weak, nonatomic) IBOutlet LeftImageTextField *txtPwd;
@property (weak, nonatomic) IBOutlet LeftImageTextField *txtRePwd;
@property (weak, nonatomic) IBOutlet LeftImageTextField *txtRecommendCode;

@property (nonatomic,assign) UIViewController *parentView;
@end
