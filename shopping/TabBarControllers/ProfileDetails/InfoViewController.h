//
//  InfoViewController.h
//  shopping
//
//  Created by Macbook on 27/02/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDTakeController.h"

@interface InfoViewController : UIViewController<FDTakeDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgIDForward;
@property (weak, nonatomic) IBOutlet UIImageView *imgIDBack;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtBankName;
@property (weak, nonatomic) IBOutlet UITextField *txtBankCardid;
@property (weak, nonatomic) IBOutlet UITextField *txtBankAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtIDCardNum;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@end
