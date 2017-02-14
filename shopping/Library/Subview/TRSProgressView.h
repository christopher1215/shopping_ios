//
//  TRSProgressView.h
//  Tourongsu_2
//
//  Created by YunSI on 3/5/14.
//  Copyright (c) 2014 shenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	kAlertTypeWarnning,
    kAlertTypeInform,
    kAlertTypeWaiting,
    kAlertTypeSuccess,
    kAlertTypeSuccessDingzhi
} AlertType;

@interface TRSProgressView : UIControl
{
    CGFloat progress;
    
    NSInteger _numberOfSegments;
    CGFloat _progressRingWidth;
    BOOL _progressRingWidthOverriden;
    BOOL _segmentSeparationAngleOverriden;
    
    UIColor *backColor;
    UIColor *primaryColor;
    UIColor *secondaryColor;
    CAShapeLayer *backgroundLayer;
    CAShapeLayer *progressBackLayer;
    CAShapeLayer *progressForeLayer;
    UIImageView  *markView;
    UILabel      *contentLabelView;
    UILabel      *desLabelView;
    
    CGFloat outerRingAngle;
    CGFloat innerRingAngle;
    CGFloat _segmentSeparationInnerAngle;
    
    NSString *m_strContent;
    NSString *m_strDescription;
    CGPoint  m_RingCenter;
    
    NSTimer *m_progressTimer;
    BOOL    m_bShowProgress;
    BOOL    m_bBackRounded;
    
    NSDate *showTime;

    CGRect m_contentRect;
    CGRect m_desRect;
    int     m_alertType;
}

@property (nonatomic, assign) CGFloat segmentSeparationAngle;

+ (TRSProgressView *) sharedInstance;
- (void)presentWithText:(NSString *)text withType:(int)alertType withDescription:(NSString*)description;
- (void)presentWithText:(NSString *)text withType:(int)alertType inFrame:(CGRect)frame withDescription:(NSString*)description;
- (void)presentWithText:(NSString *)text forSeconds:(int)second;
- (void)presentWithText:(NSString *)text forSeconds:(int)second inFrame:(CGRect)frame withType:(int)alertType withDescription:(NSString*)description;

- (void)dismiss;

@end
