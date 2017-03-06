//
//  ContactTableViewCell.m
//  shopping
//
//  Created by Macbook on 27/02/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat labelWidth = self.contentView.frame.size.width/3;
    CGFloat labelHeight = self.contentView.frame.size.height;
    [self.lblPhone setFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
    [self.lblName setFrame:CGRectMake(labelWidth + 40, 0, labelWidth-40, labelHeight)];
    [self.lblRegDate setFrame:CGRectMake(labelWidth * 2, 0, labelWidth, labelHeight)];
    [self.imgIcon setFrame:CGRectMake(labelWidth + 10, 10, 20, 20)];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
