//
//  NewsTableViewCell.m
//  shopping
//
//  Created by Macbook on 28/02/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.lblContent.layer.cornerRadius = 4.0f;
    self.lblContent.layer.borderWidth = 1.0f;
    self.lblContent.layer.borderColor = [UIColor clearColor].CGColor;
    self.lblContent.layer.masksToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
