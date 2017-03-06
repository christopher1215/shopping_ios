//
//  ContactWith.h
//  shopping
//
//  Created by Macbook on 27/02/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactWith : NSObject
@property(nonatomic,assign) long user_id;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) short level;
@property(nonatomic,strong) NSString *reg_date;

@end
