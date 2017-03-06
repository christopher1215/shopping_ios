//
//  HomeTableViewCell.m
//  shopping
//
//  Created by Macbook on 2/14/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.btnCart.layer.cornerRadius = 4.0f;
    self.btnCart.layer.borderWidth = 1.0f;
    self.btnCart.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnCart.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
