//
//  VideoViewController.m
//  psychology
//
//  Created by 123 on 9/21/16.
//  Copyright © 2016 Christopher sh. All rights reserved.
//

#import "VideoViewController.h"
@import AVFoundation;
@import AVKit;

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isPresented = YES; // Set it to true, when controller is initialised

    self.showsPlaybackControls = YES;
    // grab a local URL to our video
    NSURL *videoURL = [NSURL URLWithString:self.videoURL];
    
    // create an AVPlayer
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    
    // create a player view controller
    self.player = player;
    [player play];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, 0, 44, 44)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}
- (void)viewDidAppear:(BOOL)animated{
    self.isPresented = NO; // Set this flag to NO before dismissing controller, so that correct orientation will be chosen
}
-(void)viewWillDisappear:(BOOL)animated{
    self.isPresented = NO; // Set this flag to NO before dismissing controller, so that correct orientation will be chosen     
}
-(void) onBack
{
    self.isPresented = NO; // Set this flag to NO before dismissing controller, so that correct orientation will be chosen for the bottom controller
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
