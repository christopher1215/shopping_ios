//
//  UIDownPicker.m
//  Know
//
//  Created by DarkAngel on 29/03/15.
//  Copyright (c) 2015 Ryadel. All rights reserved.
//

#import "UIDownDatePicker.h"

@implementation UIDownDatePicker

-(id)init
{
    return [self initWithData:nil];
}

-(id)initWithData:(NSMutableArray*)data
{
    self = [super init];
    if (self) {
        self.DownDatePicker = [[DownDatePicker alloc] initWithTextField:self withData:data];
    }
    return self;
}

@end
