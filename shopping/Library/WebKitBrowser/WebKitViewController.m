//
//  WebKitViewController.m
//  psychology
//
//  Created by 123 on 16/9/8.
//  Copyright © 2016年 Christopher sh. All rights reserved.
//

#import "WebKitViewController.h"

@interface WebKitViewController (){
    NSTimer *updateTimer;
    
}

@end

@implementation WebKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_browserWebKit loadRequest:urlRequest];
    updateTimer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                   target: self
                                                 selector:@selector(onTick:)
                                                 userInfo: nil repeats:YES];
    [Common showProgress:self.view];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController.navigationBar subviews].count>0) {
        for (UIView *subViews in [self.navigationController.navigationBar subviews]) {
            if ([subViews isKindOfClass:[UIImageView class]] && (subViews.tag == 1111)) {
                [subViews removeFromSuperview];
                break;
            }
        }
    }

    UIImage *img = [UIImage imageNamed:@"navbar_gen.png"];
    img = [img stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];

}
-(void) onTick:(NSTimer *)timer
{
    if (![_browserWebKit isLoading]) {
        [updateTimer invalidate];
        updateTimer = nil;
        [Common hideProgress];
    }
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
