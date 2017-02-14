//
//  TabBarViewController.m
//  psychology
//
//  Created by 123 on 8/5/16.
//  Copyright © 2016 Christopher sh. All rights reserved.
//

#import "TabBarViewController.h"
#import "RecommendViewController.h"

@implementation TabBarViewController{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDelegate:self];
    self.title=STR_HOME;
    [[UITabBar appearance] setTintColor:RGB(238, 80, 60)];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    
    self.tabBar.layer.shadowRadius  = 2.5f;
    self.tabBar.layer.shadowColor   = RGBA(0, 0, 0, 0.3).CGColor;
    self.tabBar.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.tabBar.layer.shadowOpacity = 0.7f;
    self.tabBar.layer.masksToBounds = NO;

}
-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //Write your code here
    self.title = viewController.title;
    if ([viewController isKindOfClass:[RecommendViewController class]]) {
        
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem = nil;
//        self.navigationItem.leftBarButtonItem.enabled = NO;
//        self.navigationItem.leftBarButtonItem = nil;
    }
}


@end
