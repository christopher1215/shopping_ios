//
//  Notification.h
//  shopping
//
//  Created by Macbook on 28/02/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject
@property(nonatomic,assign) long notification_id;
@property(nonatomic,strong) NSString *message_type;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *reg_date;
@end
