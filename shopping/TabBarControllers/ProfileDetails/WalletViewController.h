//
//  WalletViewController.h
//  shopping
//
//  Created by Macbook on 02/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnReqWithdraw;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentMoney;
@property (weak, nonatomic) IBOutlet UIView *historyBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lblInviteUsers;
@property (weak, nonatomic) IBOutlet UILabel *lblBuyMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblInviteMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCommission;
@property (weak, nonatomic) IBOutlet UILabel *lblRatingCommissionMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblWaitRatingCommission;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessedMonthCommission;
@property (weak, nonatomic) IBOutlet UILabel *lblWaitMonthCommission;
@end
