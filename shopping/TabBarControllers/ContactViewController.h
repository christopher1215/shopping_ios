//
//  ContactViewController.h
//  shopping
//
//  Created by Macbook on 2/13/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) long user_id;
@property (assign, nonatomic) short detailFlag;

@end
