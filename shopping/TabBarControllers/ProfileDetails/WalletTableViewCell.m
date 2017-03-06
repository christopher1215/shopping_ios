//
//  WalletTableViewCell.m
//  shopping
//
//  Created by Macbook on 02/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "WalletTableViewCell.h"

@implementation WalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.viewRound.layer.cornerRadius = 4.0f;
    self.viewRound.layer.borderWidth = 1.0f;
    self.viewRound.layer.borderColor = [UIColor clearColor].CGColor;
    self.viewRound.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
