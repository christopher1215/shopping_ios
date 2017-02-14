//
//  AssetCell.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSImageViewerViewController.h"

@interface ELCAssetCell : UITableViewCell
@property (nonatomic, assign) BOOL alignmentLeft;
@property(strong, nonatomic) FSImageViewerViewController *imageViewController;
@property (nonatomic, strong) UIViewController *parentView;
- (void)setAssets:(NSArray *)assets;

@end
