//
//  ProfileViewController.h
//  shopping
//
//  Created by Macbook on 2/13/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *tabBtnView;
@property (weak, nonatomic) IBOutlet UIView *tabSeparator1;
@property (weak, nonatomic) IBOutlet UIView *tabSeparator2;
@property (weak, nonatomic) IBOutlet UILabel *cart_out;
@property (weak, nonatomic) IBOutlet UILabel *members;
@property (weak, nonatomic) IBOutlet UILabel *wallet;
@property (weak, nonatomic) IBOutlet UILabel *lblCartOut;
@property (weak, nonatomic) IBOutlet UILabel *lblMemberCnt;
@property (weak, nonatomic) IBOutlet UILabel *lblWallet;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblRecommender;
@property (weak, nonatomic) IBOutlet UILabel *lblRemain;
@property (weak, nonatomic) IBOutlet UIImageView *imgFace;

@end
