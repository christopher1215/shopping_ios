//
//   DownPicker.h
// --------------------------------------------------------
//      Lightweight DropDownList/ComboBox control for iOS
//
// by Darkseal, 2013-2015 - MIT License
//
// Website: http://www.ryadel.com/
// GitHub:  http://www.ryadel.com/
//

#import <UIKit/UIKit.h>

@interface DownDatePicker : UIControl<UITextFieldDelegate>
{
    UIDatePicker* datePicker;
    IBOutlet UITextField* textField;
    NSMutableArray* dataArray;
    NSString* placeholder;
    NSString* placeholderWhileSelecting;
	NSString* toolbarDoneButtonText;
    NSString* toolbarCancelButtonText;
	UIBarStyle toolbarStyle;
}

@property (nonatomic) NSString* text;
@property (nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

-(id)initWithTextField:(UITextField *)tf;
-(id)initWithTextField:(UITextField *)tf withData:(NSMutableArray*) data;

/**
 Sets an alternative image to be show to the right part of the textbox (assuming that showArrowImage is set to TRUE).
 @param image
 A valid UIImage
 */
-(void) setArrowImage:(UIImage*)image;

-(void) setPlaceholder:(NSString*)str;
-(void) setPlaceholderWhileSelecting:(NSString*)str;
-(void) setToolbarDoneButtonText:(NSString*)str;
-(void) setToolbarCancelButtonText:(NSString*)str;
-(void) setToolbarStyle:(UIBarStyle)style;

/**
 TRUE to show the rightmost arrow image, FALSE to hide it.
 @param b
 TRUE to show the rightmost arrow image, FALSE to hide it.
 */
-(void) showArrowImage:(BOOL)b;

@end
