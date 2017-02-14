//
//  VideoViewController.h
//  psychology
//
//  Created by 123 on 9/21/16.
//  Copyright © 2016 Christopher sh. All rights reserved.
//

#import <AVKit/AVKit.h>

@interface VideoViewController : AVPlayerViewController
@property(strong,nonatomic) NSString *videoURL;
@property (nonatomic) BOOL isPresented; // This property is very important
@end
