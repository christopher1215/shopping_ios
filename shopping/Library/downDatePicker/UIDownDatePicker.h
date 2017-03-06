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

#import <Foundation/Foundation.h>
#import "DownDatePicker.h"

@interface UIDownDatePicker : UITextField

@property (strong, nonatomic) DownDatePicker *DownDatePicker;

-(id)initWithData:(NSMutableArray*)data;

@end
