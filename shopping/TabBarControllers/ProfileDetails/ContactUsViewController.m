//
//  ContactUsViewController.m
//  shopping
//
//  Created by Macbook on 01/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lblContactQQ.text = [NSString stringWithFormat:@"QQ：%@", [UserInfoKit sharedKit].contact_qq];
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
