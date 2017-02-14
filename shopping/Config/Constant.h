
#ifndef Constant_h
#define Constant_h

#define 	UNLOGIN_FLAG            -1
#define     IS_SHOW_SMS_MESG        YES
#define		RowsPerPage             10
#define     IMG_SEL_MAX_CNT         1
#define     _AUTO_SCROLL_ENABLED    1
#define     _AUTO_SCROLL_DISABLED   0


#define     RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]
#define     RGBA(r, g, b, a) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:a]
#define 	TimeStamp [NSString stringWithFormat:@"%ld",[[NSDate date] timeIntervalSince1970]]

#endif /* Constant_h */
