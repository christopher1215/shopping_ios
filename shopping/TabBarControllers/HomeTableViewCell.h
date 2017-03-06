//
//  HomeTableViewCell.h
//  shopping
//
//  Created by Macbook on 2/14/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;
@property (weak, nonatomic) IBOutlet UIImageView *imgBuyState;

@end
