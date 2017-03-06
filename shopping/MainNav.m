//
//  MainNav.m
//  psychology
//
//  Created by 123 on 16/8/16.
//  Copyright © 2016年 Christopher sh. All rights reserved.
//

#import "MainNav.h"
#import "MyNewsViewController.h"

@implementation MainNav

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoSystemMsgPage:) name:@"gotoSystemMsgPage" object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [self setNeedsStatusBarAppearanceUpdate];

//    [[UINavigationBar appearance] setBarTintColor:RGB(238, 80, 60)];
//    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
    
    
}


-(void)gotoSystemMsgPage:(NSNotification *)noti
{
    MyNewsViewController *vc = [[MyNewsViewController alloc] initWithNibName:@"MyNewsViewController" bundle:nil];
    [self pushViewController:vc animated:YES];
}

@end
