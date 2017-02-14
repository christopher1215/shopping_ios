//
//  LeftImageTextField.m
//  youtu
//
//  Created by princemac on 12/26/15.
//  Copyright © 2015 Christopher sh. All rights reserved.
//

#import "LeftImageTextField.h"
#import <QuartzCore/QuartzCore.h>
@implementation LeftImageTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)changeLeftImage{
    self.clipsToBounds = YES;
    [self setLeftViewMode:UITextFieldViewModeAlways];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_leftImgName]];
    imageView.frame = CGRectMake(5, 5, 20, 20);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.leftView = imageView;
    
}
- (CGRect) leftViewRectForBounds:(CGRect)bounds {
    
    CGRect textRect = [super leftViewRectForBounds:bounds];
    textRect.origin.x += 10;
    return textRect;
}
@end
