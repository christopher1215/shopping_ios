//
//  WebKitViewController.h
//  psychology
//
//  Created by 123 on 16/9/8.
//  Copyright © 2016年 Christopher sh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebKitViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *browserWebKit;
@property (weak, nonatomic) NSString *urlString;

@end
