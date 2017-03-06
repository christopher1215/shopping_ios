//
//  Common.h
//  4S-C
//
//  Created by R CJ on 1/5/13.
//  Copyright (c) 2013 PIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Base64Code.h"

#define MOVE_FROM_LEFT(ctrl)	CATransition *animation = [CATransition animation]; \
                                [animation setDuration:0.3]; \
                                [animation setType:kCATransitionPush]; \
                                [animation setSubtype:kCATransitionFromLeft]; \
                                [animation setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]]; \
                                [[ctrl.view.superview layer] addAnimation:animation forKey:@"SwitchToView"];

#define MOVE_FROM_RIGHT	CATransition *animation = [CATransition animation]; \
                        [animation setDuration:0.3]; \
                        [animation setType:kCATransitionPush]; \
                        [animation setSubtype:kCATransitionFromRight]; \
                        [animation setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]]; \
                        [[self.view.superview layer] addAnimation:animation forKey:@"SwitchToView"];


#define SHOW_VIEW(ctrl)     MOVE_FROM_RIGHT \
                            [self presentViewController:ctrl animated:NO completion:nil];

#define BACK_VIEW(ctrl)	 	MOVE_FROM_LEFT(ctrl) \
                            [ctrl dismissViewControllerAnimated:NO completion:nil];

#define MOVE_FROM_RIGHT_SUBVIEW	CATransition *animation = [CATransition animation]; \
[animation setDuration:0.3]; \
[animation setType:kCATransitionPush]; \
[animation setSubtype:kCATransitionFromRight]; \
[animation setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]]; \
[[self.superview layer] addAnimation:animation forKey:@"SwitchToView"];

#define SHOW_SUBVIEW(ctrl)  MOVE_FROM_RIGHT_SUBVIEW \
                            [self.superVC presentViewController:ctrl animated:NO completion:nil];


#define TEST_NETWORK_RETURN if ([CommManager hasConnectivity] == NO) { \
                                [DejalActivityView removeView]; \
                                [AutoMessageBox AutoMsgInView:self.view withText:@"没有网络连接" withSuccess:FALSE]; \
                                return; \
                            }

#define BACKGROUND_TEST_NETWORK_RETURN    if ([CommManager hasConnectivity] == NO) { \
                                                return; \
                                            }

//#define WEATEER_GET_MODE
#define PAGE_ITEMCOUNT  15

typedef NS_ENUM(NSInteger, DEVICE_KIND) {
    IPHONE4= 1,
    IPHONE5,
    IPAD,
};

@interface Common : NSObject {

}

+(NSInteger) calcDistance:(double)startLat startLong:(double)startLong endLat:(double)endLat endLong:(double)endLong;
+ (NSString*) deviceName;
+ (NSArray*)relationArray;
+ (NSString*)relationAtIndex:(NSInteger)index;
+ (NSInteger)intWithRelation:(NSString*)relation;
+ (NSString*)stringWithRelation:(NSString*)relation;
+ (NSString*)timeStringWithSecond:(NSInteger)second;
+ (NSString*)dateStringFromString:(NSString*)string;
+ (NSDateComponents*)dateComponentsFromString:(NSString*)string;

+ (UIImage*)resizeImageByCondForUpload:(UIImage *)image;
+ (UIImage*)resizeImage:(UIImage*)image withWidth:(int)width withHeight:(int)height;
+ (void) showProgress:(UIView *)target;
+ (void) showProgressWithText:(UIView *)target text:(NSString *)text;
+ (void) hideProgress;
+ (BOOL) isIOSVer7;
+(BOOL)isKeyBoardInDisplay;

+ (void) makeErrorWindow : (NSString *)content TopOffset:(NSInteger)topOffset BottomOffset:(NSInteger)bottomOffset View:(UIView *)view;

+ (void) setDeviceToken : (NSString*)newDeviceToken;
+ (NSString*) deviceToken;

+ (void) setReserveMode : (NSString*)rsrvMode;


+ (NSString*) getCurTime : (NSString*)fmt;

+ (NSInteger) MAXLENGTH;

+ (NSInteger) phoneType;

+ (NSString *)getRealImagePath :(NSString *)path :(NSString *)rate :(NSString *)size;
+ (NSString *)getBackImagePath :(NSString *)path :(NSString *)rate :(NSString *)size;

+ (NSString*)base64forData:(NSData*)theData;
+ (NSData*)base64forString:(NSString*)theString;

+ (NSString *)appNameAndVersionNumberDisplayString;

+ (NSString *)weatherUrl;
+ (NSArray *)provinceArray;
+ (NSArray *)cityArray :(NSString *)province;
+ (NSString *)getRegionCodeFromCarNumber :(NSString *)carNum;

+ (NSArray *)getBookContentArray :(NSString *)carBrand;

+ (NSString *)getCarBrandImage :(NSString *)carBrand;
+ (NSArray *)getCarBrandArray;

+ (NSArray *)getCarProvinceArray;
+ (NSArray *)getCarCityArray;
+ (NSArray *)getCarNumberArray;
+ (NSArray *)getCarTypeValArray;
+ (NSArray *)getCarTypeKeyArray;

+ (NSString*) getPhoneNumber;
+ (NSString *) configFilePath;
+ (NSString *) configFilePathWithFileName:(NSString *)fileName;
+ (NSString*) numberString:(NSString *)anyString;

+ (void)showNotImplemented;
+ (void)showMessage : (NSString *)message;
+ (void)addDoneToolBarToKeyboard:(UITextField *)textField viewController:(UIViewController*)vc;
+ (void)addDoneToolBarToKeyboardToView:(UITextView *)textView viewController:(UIViewController*)vc;
+ (void)registerNotifications1 :(UIViewController*)vc;
+ (void)registerNotifications :(UIViewController*)vc;
+ (void)animateControl:(UIView*)target endRect:(CGRect)endRect;
+ (void)animateConstant:(NSLayoutConstraint*)target endConstant:(CGFloat)endConstant;
+ (void) uploadImages:(UIImage *)img protocolName:(NSString *)protocol viewController:(UIViewController*)vc name:(NSString *)name ind:(NSString *)ind;
+ (void)setStatusBarBackgroundColor:(UIColor *)color;

+ (NSDictionary *)fetchData:(NSDictionary *)response;
+ (NSArray *)fetchArray:(NSData *)response;
+ (NSArray *)fetchArrayFromCarInfo:(NSDictionary *)response;
+ (NSArray *)fetchArrayFromMsg:(NSDictionary *)response;

+ (NSString*)getBMIOpinin:(CGFloat)bmi;
+ (NSString*)getWaistOpinin:(CGFloat)sex waist:(CGFloat)waist;
+ (NSString*)getWaistOpininSetting:(CGFloat)sex waist:(CGFloat)waist;
+ (NSString*)getBodyfatOpininSetting:(CGFloat)sex bodyfat:(CGFloat)bodyfat;
+ (NSString*)getHiplineOpininSetting:(CGFloat)sex hipline:(CGFloat)hipline;
+ (NSString*)getPhysiologyOpinion:(NSInteger)sex high_blood:(NSInteger)high_blood low_blood:(NSInteger)low_blood blood_sugar:(NSInteger)blood_sugar empty:(BOOL)empty high_cholesterol:(NSInteger)high_cholesterol low_cholesterol:(NSInteger)low_cholesterol glyceride:(NSInteger)glyceride;
+ (NSString*)getBMITypeString:(CGFloat)bmi;
+ (NSString*)getBMIStyleString:(CGFloat)bmi;

+ (void)setSliderOrigin:(UIView*)slidingView width:(CGFloat)width;

//file read or write
+ (void) writeToTextFile:(NSString*) val fileName:fName;
+ (NSString *) getContentFromFile:(NSString *)fName;

+(BOOL)convertWAV:(NSString *)wavFilePath
            toAMR:(NSString *)amrFilePath;

@end
