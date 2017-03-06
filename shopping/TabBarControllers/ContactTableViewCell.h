//
//  ContactTableViewCell.h
//  shopping
//
//  Created by Macbook on 27/02/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblRegDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@end
