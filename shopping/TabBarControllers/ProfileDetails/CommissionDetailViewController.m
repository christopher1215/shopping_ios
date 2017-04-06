//
//  CommissionDetailViewController.m
//  shopping
//
//  Created by Macbook on 17/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "CommissionDetailViewController.h"

@interface CommissionDetailViewController ()

@end

@implementation CommissionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提成详细";
    self.lblDirectInvite.text = _strDirectInvite;
    self.lblBuyerName.text = _strBuyerName;
    self.lblGoodsName.text = _strGoodsName;
    self.lblRegDate.text = _strRegDate;
    self.lblGoodsPrice.text = _strGoodsPrice;
    self.lblRate.text = _strRate;
    self.lblAmount.text = _strAmount;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
