//
//  AssetCell.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCConsole.h"
#import "ELCOverlayImageView.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"

@interface ELCAssetCell ()
{
    NSInteger imgWidth;
}
@property (nonatomic, strong) NSArray *rowAssets;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *overlayViewArray;

@property (nonatomic, strong) NSMutableArray *selButtonArray;

@end



@implementation ELCAssetCell

//Using auto synthesizers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];

    imgWidth = ([UIScreen mainScreen].bounds.size.width - 20) / 4;
	if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.imageViewArray = mutableArray;
        
        NSMutableArray *overlayArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.overlayViewArray = overlayArray;

        NSMutableArray *selButtonArray =[[NSMutableArray alloc] initWithCapacity:4];
        self.selButtonArray = selButtonArray;

        self.alignmentLeft = YES;
	}
	return self;
}

- (void)setAssets:(NSArray *)assets
{
    self.rowAssets = assets;
	for (UIImageView *view in _imageViewArray) {
        [view removeFromSuperview];
	}
    for (UIButton *view in _selButtonArray) {
        [view removeFromSuperview];
    }
//    for (ELCOverlayImageView *view in _overlayViewArray) {
//        [view removeFromSuperview];
//	}
    //set up a pointer here so we don't keep calling [UIImage imageNamed:] if creating overlays
   // UIImage *overlayImage = nil;
    for (int i = 0; i < [_rowAssets count]; ++i) {

        ELCAsset *asset = [_rowAssets objectAtIndex:i];

        if (i < [_imageViewArray count]) {
            UIImageView *imageView = [_imageViewArray objectAtIndex:i];
            imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.asset.thumbnail]];
            [_imageViewArray addObject:imageView];
        }

        if (i < [_selButtonArray count]) {
            UIButton *btn = [_selButtonArray objectAtIndex:i];
            if([asset selected])
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"chk_delete_selected"] forState:UIControlStateNormal];
            }
            else
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"chk_delete_normal"] forState:UIControlStateNormal];
            }
        } else {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20 * [[UIScreen mainScreen]bounds].size.width / 320, 20 * [[UIScreen mainScreen]bounds].size.width / 320)];
            if([asset selected])
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"chk_delete_selected"] forState:UIControlStateNormal];
            }
            else
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"chk_delete_normal"] forState:UIControlStateNormal];
            }
            [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectImg:)]];

            [_selButtonArray addObject:btn];
        }
    }
}

-(void) onSelectImg:(UITapGestureRecognizer *)tapRecognizer
{

    CGPoint point = [tapRecognizer locationInView:self];
    int c = (int32_t)self.rowAssets.count;
    CGFloat totalWidth = c * imgWidth + (c - 1) * 4;
    CGFloat startX;

    if (self.alignmentLeft) {
        startX = 4;
    }else {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }

    CGRect frame = CGRectMake(startX, 2, imgWidth, imgWidth);

    for (int i = 0; i < [_rowAssets count]; ++i) {
        if (CGRectContainsPoint(frame, point)) {
            ELCAsset *asset = [_rowAssets objectAtIndex:i];
            asset.selected = !asset.selected;
            UIButton *btn = [_selButtonArray objectAtIndex:i];
            if (asset.selected) {
                asset.index = [[ELCConsole mainConsole] numOfSelectedElements];
                [[ELCConsole mainConsole] addIndex:asset.index];
                [btn setBackgroundImage:[UIImage imageNamed:@"chk_delete_selected"] forState:UIControlStateNormal];
            }
            else
            {
                int lastElement = [[ELCConsole mainConsole] numOfSelectedElements] - 1;
                [[ELCConsole mainConsole] removeIndex:lastElement];
                [btn setBackgroundImage:[UIImage imageNamed:@"chk_delete_normal"] forState:UIControlStateNormal];
            }
            break;
        }
        frame.origin.x = frame.origin.x + frame.size.width + 4;
    }

}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint point = [tapRecognizer locationInView:self];
    int c = (int32_t)self.rowAssets.count;
    CGFloat totalWidth = c * imgWidth + (c - 1) * 4;
    CGFloat startX;

    if (self.alignmentLeft) {
        startX = 4;
    }else {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }

    CGRect frame = CGRectMake(startX, 2, imgWidth, imgWidth);

    for (int i = 0; i < [_rowAssets count]; ++i) {
        if (CGRectContainsPoint(frame, point)) {
            ELCAsset *asset = [_rowAssets objectAtIndex:i];
            UIImage* image = [UIImage imageWithCGImage:[[asset.asset defaultRepresentation] fullResolutionImage]];
            NSMutableArray *fbImgs = [[NSMutableArray alloc]init];
            [fbImgs addObject:[[FSBasicImage alloc] initWithImage:image]];
            FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:fbImgs];
            self.imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource imageIndex:0];

            _imageViewController.delegate = self;
            _imageViewController.baoVC = self;

            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_imageViewController];
                [self.parentView.navigationController presentViewController:navigationController animated:YES completion:nil];
                break;
            }
            else {
                [self.parentView.navigationController pushViewController:_imageViewController animated:YES];
                break;
            }
            break;
        }
        frame.origin.x = frame.origin.x + frame.size.width + 4;
    }
}

- (void)layoutSubviews
{
    int c = (int32_t)self.rowAssets.count;
    CGFloat totalWidth = c * imgWidth + (c - 1) * 4;
    CGFloat startX;
    
    if (self.alignmentLeft) {
        startX = 4;
    }else {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }
    
	CGRect frame = CGRectMake(startX, 2, imgWidth, imgWidth);
	
	for (int i = 0; i < [_rowAssets count]; ++i) {
		UIImageView *imageView = [_imageViewArray objectAtIndex:i];
		[imageView setFrame:frame];
		[self addSubview:imageView];

        UIButton *btn = [_selButtonArray objectAtIndex:i];
        [btn setFrame:CGRectMake(frame.origin.x + frame.size.width - 20 * [[UIScreen mainScreen]bounds].size.width / 320, frame.size.height - 20 * [[UIScreen mainScreen]bounds].size.width / 320, 20 * [[UIScreen mainScreen]bounds].size.width / 320, 20 * [[UIScreen mainScreen]bounds].size.width / 320)];
        [self addSubview:btn];
        
        frame.origin.x = frame.origin.x + frame.size.width + 4;
	}
}

@end
