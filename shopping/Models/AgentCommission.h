//
//  AgentCommission.h
//  shopping
//
//  Created by Macbook on 01/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgentCommission : NSObject
@property(nonatomic,strong) NSString *reg_date;
@property(nonatomic,assign) float amount;
@property(nonatomic,assign) long buyer_id;
@property(nonatomic,strong) NSString *buyer_name;
@property(nonatomic,strong) NSString *direct_invite;
@property(nonatomic,strong) NSString *goods_name;
@property(nonatomic,assign) float goods_price;
@property(nonatomic,assign) long Commission_id;
@property(nonatomic,assign) long invite_id;
@property(nonatomic,assign) int rate;
@property(nonatomic,assign) long user_id;

@end
