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
