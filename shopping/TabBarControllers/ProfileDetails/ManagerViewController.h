//
//  ManagerViewController.h
//  shopping
//
//  Created by Macbook on 17/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTotalUsers;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalBuyMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblCommission;
@property (weak, nonatomic) IBOutlet UILabel *lblMonthComission;
@property (weak, nonatomic) IBOutlet UILabel *lblRatingCommissionMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCommission;
@property (weak, nonatomic) IBOutlet UILabel *lblLevelStr;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

@end
