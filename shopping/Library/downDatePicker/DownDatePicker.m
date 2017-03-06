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


#import "DownDatePicker.h"


@implementation DownDatePicker
{
    NSString* _previousSelectedString;
}
@synthesize dateFormatter;

-(id)initWithTextField:(UITextField *)tf
{
    return [self initWithTextField:tf withData:nil];
}

-(id)initWithTextField:(UITextField *)tf withData:(NSMutableArray*) data
{
    self = [super init];
    if (self) {
        self->textField = tf;
        self->textField.delegate = self;

		[self createDateFormatter];

        // set UI defaults
        self->toolbarStyle = UIBarStyleDefault;
		
        // set language defaults
//        self->placeholder = STR_TAPTOCHOOSE;
//        self->placeholderWhileSelecting = STR_PICK_AN_OPTION;
		self->toolbarDoneButtonText = STR_DONE;
        self->toolbarCancelButtonText = STR_CANCEL;
        
        // hide the caret and its blinking
        [[textField valueForKey:@"textInputTraits"]
         setValue:[UIColor clearColor]
         forKey:@"insertionPointColor"];
        
        // set the placeholder
        self->textField.placeholder = self->placeholder;
        
        // setup the arrow image
        UIImage* img = [UIImage imageNamed:@"downArrow.png"];   // non-CocoaPods
        if (img == nil) img = [UIImage imageNamed:@"DownPicker.bundle/downArrow.png"]; // CocoaPods
        if (img != nil) self->textField.rightView = [[UIImageView alloc] initWithImage:img];
        self->textField.rightView.contentMode = UIViewContentModeScaleAspectFit;
        self->textField.rightView.clipsToBounds = YES;
        
        // show the arrow image by default
        [self showArrowImage:YES];
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)doneClicked:(id) sender
{
    // make the textField selectable again
    textField.userInteractionEnabled = YES;
    
    [textField resignFirstResponder]; //hides the pickerView
    if (self->textField.text.length == 0) {
        self->textField.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:datePicker.date]];
    } else {
        if (![self->textField.text isEqualToString:_previousSelectedString]) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

-(void)cancelClicked:(id)sender
{
    // make the textField selectable again
    textField.userInteractionEnabled = YES;
    
    [textField resignFirstResponder]; //hides the pickerView
    self->textField.text = _previousSelectedString;
}

-(void)dateIsChanged:(id)sender{
	self->textField.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:datePicker.date]];	
}

- (IBAction)showPicker:(id)sender
{
    _previousSelectedString = self->textField.text;
    
    datePicker = [[UIDatePicker alloc] init];
	datePicker.datePickerMode = UIDatePickerModeDate;
	NSLocale *chLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
	[self->datePicker setLocale:chLocale];
	[self->datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
    //If the text field is empty show the place holder otherwise show the last selected option
    if (self->textField.text.length == 0)
    {
        self->textField.placeholder = self->placeholderWhileSelecting;
    }
    else
    {
		NSDate *oldDate = [dateFormatter dateFromString:self->textField.text];
        [self->datePicker setDate:oldDate];
    }

    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = self->toolbarStyle;
    [toolbar sizeToFit];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:self->toolbarCancelButtonText
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancelClicked:)];
    
    //space between buttons
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:self->toolbarDoneButtonText
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(doneClicked:)];
    
    
    
    [toolbar setItems:[NSArray arrayWithObjects:cancelButton, flexibleSpace, doneButton, nil]];

    //custom input view
    textField.inputView = datePicker;
    textField.inputAccessoryView = toolbar;  
}

- (void)createDateFormatter {
	
	dateFormatter = [[NSDateFormatter alloc] init];
	NSLocale *chinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
	[dateFormatter setDateFormat:@"yyyy年 MM月 dd日"];
	[dateFormatter setLocale:chinaLocale];
	
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    // make the textField unselectable
    textField.userInteractionEnabled = NO;
    
	[self showPicker:aTextField];
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

-(void) showArrowImage:(BOOL)b
{
    if (b == YES) {
      // set the DownPicker arrow to the right (you can replace it with any 32x24 px transparent image: changing size might give different results)
        self->textField.rightViewMode = UITextFieldViewModeAlways;
    }
    else {
        self->textField.rightViewMode = UITextFieldViewModeNever;
    }
}

-(void) setArrowImage:(UIImage*)image
{
    [(UIImageView*)self->textField.rightView setImage:image];
}

-(void) setPlaceholder:(NSString*)str
{
    self->placeholder = str;
    self->textField.placeholder = self->placeholder;
}

-(void) setPlaceholderWhileSelecting:(NSString*)str
{
    self->placeholderWhileSelecting = str;
}

-(void) setToolbarDoneButtonText:(NSString*)str
{
    self->toolbarDoneButtonText = str;
}

-(void) setToolbarCancelButtonText:(NSString*)str
{
    self->toolbarCancelButtonText = str;
}

-(void) setToolbarStyle:(UIBarStyle)style;
{
    self->toolbarStyle = style;
}

@end
