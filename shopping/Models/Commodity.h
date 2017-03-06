//
//  Commodity.h
//  psychology
//
//  Created by 123 on 16/8/8.
//  Copyright © 2016年 Christopher sh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commodity : NSObject

@property(nonatomic,assign) long goods_id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *comment;
@property(nonatomic,assign) double cost;
@property(nonatomic,strong) NSString *original_url;
@property(nonatomic,strong) NSString *thumb_url;
@property(nonatomic,assign) short buy_status;
@end
