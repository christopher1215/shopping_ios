//
//  LogInViewController.h
//  youtu
//
//  Created by princemac on 12/26/15.
//  Copyright © 2015 Christopher sh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftImageTextField.h"

@interface LogInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet LeftImageTextField *txtUserId;
@property (weak, nonatomic) IBOutlet LeftImageTextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogIn;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnRecoverPwd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnRecoverPwdWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnSignUpWidth;

@property (nonatomic,assign) NSInteger fromType;
@end
