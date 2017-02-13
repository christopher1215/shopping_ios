//
//  MainNav.m
//  psychology
//
//  Created by 123 on 16/8/16.
//  Copyright © 2016年 Christopher sh. All rights reserved.
//

#import "MainNav.h"
#import "NewsViewController.h"

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

    [[UINavigationBar appearance] setBarTintColor:RGB(238, 80, 60)];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    
    /* UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
     initWithTitle: @""
     style: UIBarButtonItemStylePlain
     target: nil action: nil];
     
     [self.navigationItem setBackBarButtonItem: backButton];*/
    
}

-(void) onBack
{
//    if(self.fromType == 1)
//    {
//        NSArray *viewControllers = self.navigationController.viewControllers;
//        for (UIViewController *vc in viewControllers)
//        {
//            if([vc isKindOfClass:[WoDeViewController class]])
//            {
//                [self.navigationController popToViewController:vc animated:YES];
//                break;
//            }
//        }
//    }
//    else
//        [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)gotoSystemMsgPage:(NSNotification *)noti
{
    NewsViewController *vc = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
    [self pushViewController:vc animated:YES];
}

@end
