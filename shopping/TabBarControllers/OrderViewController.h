//
//  OrderViewController.h
//  shopping
//
//  Created by Macbook on 06/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNum;
@property (weak, nonatomic) IBOutlet UILabel *lblCost;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (assign, nonatomic) long goods_id;
@end
