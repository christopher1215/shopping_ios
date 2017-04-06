//
//  MgrBonusHistoryViewController.h
//  shopping
//
//  Created by Macbook on 01/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDownDatePicker.h"

@interface MgrBonusHistoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblDayBonus;
@property (weak, nonatomic) IBOutlet UILabel *lblMonthBonus;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalBonus;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnReqCommission;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIDownDatePicker *pickerStartDate;
@property (weak, nonatomic) IBOutlet UIDownDatePicker *pickerEndDate;
@property (assign, nonatomic) short fromType;

@end
