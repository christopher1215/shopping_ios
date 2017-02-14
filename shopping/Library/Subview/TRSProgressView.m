//
//  TRSProgressView.m
//  Tourongsu_2
//
//  Created by YunSI on 3/5/14.
//  Copyright (c) 2014 shenyang. All rights reserved.
//

#define RING_SIZE 60

#import "TRSProgressView.h"

@implementation TRSProgressView

static TRSProgressView *sharedInstance = nil;

+ (TRSProgressView *) sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[TRSProgressView alloc] init];
    }
    
    return sharedInstance;
}

- (void)setup
{
    //Set own background color
    self.backgroundColor = [UIColor clearColor];
    
    //Set defaut sizes
    _progressRingWidth = fmaxf(RING_SIZE * .2, 1.0);
    _progressRingWidthOverriden = NO;
    _segmentSeparationAngleOverriden = NO;
    
    progress = 0.0;
    _numberOfSegments = 8;
    _segmentSeparationAngle = M_PI / (5 * _numberOfSegments);
    
    [self updateAngles];
    
    //Set default colors
    backColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    primaryColor = [UIColor colorWithRed:81/255.0 green:204/255.0 blue:1.0 alpha:1.0];
    secondaryColor = [UIColor colorWithRed:127/255.0 green:128/255.0 blue:124/255.0 alpha:1.0];
    
    
    if(backgroundLayer != nil)
        [backgroundLayer removeFromSuperlayer];
    if(progressBackLayer != nil)
        [progressBackLayer removeFromSuperlayer];
    if(progressForeLayer != nil)
        [progressForeLayer removeFromSuperlayer];
    
    //Set up the background layer
    backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.fillColor = backColor.CGColor;
    [self.layer addSublayer:backgroundLayer];
    
    //Set up the progress layer
    progressBackLayer = [CAShapeLayer layer];
    progressBackLayer.fillColor = secondaryColor.CGColor;
    [self.layer addSublayer:progressBackLayer];
    progressForeLayer = [CAShapeLayer layer];
    progressForeLayer.fillColor = primaryColor.CGColor;
    [self.layer addSublayer:progressForeLayer];
    
    if(markView)
        [markView removeFromSuperview];
    markView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 30, 30)];
    markView.image = [UIImage imageNamed:@"warning_mark"];
    [markView setHidden:YES];
    [self addSubview:markView];
    
    //Set up the content label
    if(contentLabelView)
        [contentLabelView removeFromSuperview];
    contentLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [contentLabelView setText:@"hahahahahahahahahashah"];
    [contentLabelView setHighlighted:NO];
    [contentLabelView setTextAlignment:NSTextAlignmentCenter];
    [contentLabelView setBackgroundColor:[UIColor clearColor]];
    [contentLabelView setNumberOfLines:0];
    contentLabelView.textColor = [UIColor whiteColor];
    contentLabelView.font = [UIFont systemFontOfSize:14];
    [self addSubview:contentLabelView];
    
    //Set up the description label
    if(desLabelView)
        [desLabelView removeFromSuperview];
    desLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [desLabelView setText:@"hahahahahahahahahashah"];
    [desLabelView setHighlighted:NO];
    [desLabelView setTextAlignment:NSTextAlignmentCenter];
    [desLabelView setBackgroundColor:[UIColor clearColor]];
    desLabelView.textColor = [UIColor whiteColor];
    desLabelView.font = [UIFont systemFontOfSize:14];
    [self addSubview:desLabelView];
    
    
    switch (m_alertType)
    {
        case kAlertTypeWarnning:
            m_bShowProgress = NO;
            m_contentRect = CGRectMake(40, self.frame.size.height / 2.0 - 15, self.frame.size.width - 40, 30);
            markView.hidden = NO;
            break;
        case kAlertTypeInform:
            m_bShowProgress = NO;
            m_contentRect = CGRectMake(0, self.frame.size.height / 2.0 - 30, self.frame.size.width, 60);
            markView.hidden = YES;
            break;
        case kAlertTypeWaiting:
            m_bShowProgress = YES;
            m_contentRect = CGRectMake(0, self.frame.size.height / 2.0 + 30, self.frame.size.width, 30);
            markView.hidden = YES;
            m_RingCenter = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2.0 - RING_SIZE / 2 + 10);
            break;
        case kAlertTypeSuccess:
            break;
        case kAlertTypeSuccessDingzhi:
            m_bShowProgress = NO;
            m_contentRect = CGRectMake(40, 30, self.frame.size.width - 40, 30);
            m_desRect = CGRectMake(20, 90, self.frame.size.width - 40, 50);
            markView.hidden = NO;
            break;
        default:
            break;
    }
    
    if(m_bShowProgress)
    {
        if(m_progressTimer)
        {
            [m_progressTimer invalidate];
            m_progressTimer = nil;
        }
        m_progressTimer = [NSTimer scheduledTimerWithTimeInterval:(float)0.1 target:self selector:@selector(animateView:) userInfo:nil repeats:YES];
    }
}

-(void) animateView:(NSTimer *)timer
{
    progress += 0.125;
    
    if(progress > 1.0)
        progress = 0.125;
    
    [self setNeedsDisplay];
}

- (void)updateAngles
{
    //Calculate the outer ring angle for the progress segment.*/
    outerRingAngle = ((2.0 * M_PI) / (float)_numberOfSegments) - _segmentSeparationAngle;
    //Calculate the angle gap for the inner ring
    _segmentSeparationInnerAngle = 2.0 * asinf(((RING_SIZE / 2.0) * sinf(_segmentSeparationAngle / 2.0)) / ((RING_SIZE / 2.0) - _progressRingWidth));
    //Calculate the inner ring angle for the progress segment.*/
    innerRingAngle = ((2.0 * M_PI) / (float)_numberOfSegments) - _segmentSeparationInnerAngle;
}

- (NSInteger)numberOfFullSegments
{
    return (NSInteger)floorf(progress * _numberOfSegments);
}

- (void)drawRect:(CGRect)rect
{
    [self drawBackground];
    
    if(m_bShowProgress)
    {
        [self drawProgress];
    }
    
    [self drawContent];
}

- (void)drawBackground
{
    //Create the path ref that all the paths will be appended
    CGMutablePathRef backPathRef = CGPathCreateMutable();
    
    int cornerRadius = 0;
    if(m_bBackRounded)
    {
        cornerRadius = 8.0;
    }
    
    UIBezierPath *backPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) cornerRadius:cornerRadius];
    [backPath closePath];
    CGPathAddPath(backPathRef, NULL, backPath.CGPath);
    backgroundLayer.path = backPathRef;
}

- (void)drawProgress
{
    //Create parameters to draw background
    //The background segments are drawn counterclockwise, start with the outer ring, add an arc counterclockwise.  Then add the coresponding arc for the inner ring clockwise. Then close the path. The line connecting the two arcs is not needed. From tests it seems to be created automatically.
    CGFloat outerStartAngle = - M_PI_2;
    //Skip half of a separation angle, since the first separation will be centered upward.
    outerStartAngle -= (_segmentSeparationAngle / 2.0);
    //Calculate the inner start angle position
    CGFloat innerStartAngle = - M_PI_2;
    innerStartAngle -= (_segmentSeparationInnerAngle / 2.0) + innerRingAngle;
    
    CGMutablePathRef pathProgBackRef = CGPathCreateMutable();
    CGMutablePathRef pathProgForeRef = CGPathCreateMutable();
    
    //Create each segment
    int nowSegmentIndex = [self numberOfFullSegments] - 1;
    
    CGPoint center = m_RingCenter;
    for (int i = _numberOfSegments - 1; i >= 0; i--) {
        //Create the outer ring segment
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:(RING_SIZE / 2.0) startAngle:outerStartAngle endAngle:(outerStartAngle - outerRingAngle) clockwise:NO];
        //Create the inner ring segment
    
        [path addArcWithCenter:center radius:(RING_SIZE / 2.0) - _progressRingWidth startAngle:innerStartAngle endAngle:innerStartAngle + innerRingAngle clockwise:YES];
        
        [path closePath];
        
        //Add the segment to the path
        if(i == nowSegmentIndex)
        {
            CGPathAddPath(pathProgForeRef, NULL, path.CGPath);
        }
        else
        {
            CGPathAddPath(pathProgBackRef, NULL, path.CGPath);
        }
        
        //Setup for the next segment
        outerStartAngle -= (outerRingAngle + _segmentSeparationAngle);
        innerStartAngle -= (innerRingAngle + _segmentSeparationInnerAngle);
    }
     
    //Set the path
    progressBackLayer.path = pathProgBackRef;
    progressForeLayer.path = pathProgForeRef;
}

-(void)drawContent
{
    
    [contentLabelView setFrame:m_contentRect];
    [contentLabelView setText:m_strContent];
    
    //[descriptionLayer setFrame:m_desRect];
    //[descriptionLayer setWrapped:YES];
    [desLabelView setFrame:m_desRect];
    [desLabelView setText:m_strDescription];
    //descriptionLayer.truncationMode = kCATruncationEnd;
    //[descriptionLayer setString:m_strDescription];
}

- (void)presentWithText:(NSString *)text withType:(int)alertType inFrame:(CGRect)frame withDescription:(NSString*)description
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(afterFadeOut) object:nil];
    
    [self removeFromSuperview];
    
    m_strContent = text;
    m_strDescription = description;
    m_bBackRounded = YES;
    
    if ([[[UIApplication sharedApplication] windows] count] > 0)
    {
        //UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] lastObject]; // Nav Mode
        
        self.frame = frame;
        [mainWindow addSubview:self];
        self.alpha = 0.78f;
        self.hidden = NO;
        
        showTime = [NSDate date];
        m_alertType = alertType;
        
    }
    
    [self setup];
    [self setNeedsDisplay];
}

- (void)presentWithText:(NSString *)text withType:(int)alertType withDescription:(NSString*)description
{
    [self presentWithText:text withType:alertType inFrame:CGRectMake(0, 20, 320, 548) withDescription:description];
}

- (void)dismiss
{
    if ([[NSDate date] timeIntervalSinceDate:showTime] < 1.0f)
    {
        [self performSelector:@selector(doDismiss) withObject:nil afterDelay:2.0f];
    }
    else
    {
        [self doDismiss];
    }
}

- (void)doDismiss
{
    [self fadeOut];
    [self performSelector:@selector(afterFadeOut) withObject:nil afterDelay:0.5];
}

- (void)afterFadeOut
{
    [self removeFromSuperview];
    self.hidden = YES;
}

- (void)presentWithText:(NSString *)text forSeconds:(int)second
{
    [self presentWithText:text withType:kAlertTypeInform withDescription:@""];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:second];
}

- (void)presentWithText:(NSString *)text forSeconds:(int)second inFrame:(CGRect)frame withType:(int)alertType withDescription:(NSString*)description
{
    [self presentWithText:text withType:alertType inFrame:frame withDescription:description];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:second];
}

- (void) fadeIn
{
	//CGContextRef context = UIGraphicsGetCurrentContext();
    self.hidden=NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
	[self setAlpha:1.0f];
	[UIView commitAnimations];
}

- (void) fadeOut
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
	[self setAlpha:0.0f];
	[UIView commitAnimations];
}

@end
