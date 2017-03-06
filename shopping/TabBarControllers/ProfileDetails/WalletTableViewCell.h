//
//  WalletTableViewCell.h
//  shopping
//
//  Created by Macbook on 02/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblBuyDate;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodsPrice;
@property (weak, nonatomic) IBOutlet UIView *viewRound;

@end
