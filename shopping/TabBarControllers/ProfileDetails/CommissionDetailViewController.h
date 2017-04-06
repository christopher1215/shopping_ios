//
//  CommissionDetailViewController.h
//  shopping
//
//  Created by Macbook on 17/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommissionDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblDirectInvite;
@property (weak, nonatomic) IBOutlet UILabel *lblBuyerName;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *lblRegDate;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;

@property (strong, nonatomic) NSString *strDirectInvite;
@property (strong, nonatomic) NSString *strBuyerName;
@property (strong, nonatomic) NSString *strGoodsName;
@property (strong, nonatomic) NSString *strRegDate;
@property (strong, nonatomic) NSString *strGoodsPrice;
@property (strong, nonatomic) NSString *strRate;
@property (strong, nonatomic) NSString *strAmount;

@end
