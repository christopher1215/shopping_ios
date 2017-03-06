//
//  UserInfoKit.h
//  youtu
//
//  Created by qqq on 1/6/16.
//  Copyright © 2016 Christopher sh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoKit : NSObject
@property (nonatomic, assign) long userID;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) short level;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * password;

@property (nonatomic, strong) NSString *parent_name;
@property (nonatomic, assign) int reamin_buy_num;
@property (nonatomic, assign) int buy_num;
@property (nonatomic, assign) int dividend_num;
@property (nonatomic, strong) NSString *level_str;
@property (nonatomic, assign) float current_money;
@property (nonatomic, assign) float buy_money;
@property (nonatomic, assign) float invite_money;
@property (nonatomic, assign) float total_commision;

@property (nonatomic, strong) NSString *bank_account;
@property (nonatomic, strong) NSString *bank_cardid;
@property (nonatomic, strong) NSString *bank_name;
@property (nonatomic, assign) float commission_percent;
@property (nonatomic, strong) NSString *contact_phone;
@property (nonatomic, assign) float dividend_money;
@property (nonatomic, strong) NSString *idcard_back_img;
@property (nonatomic, strong) NSString *idcard_front_img;
@property (nonatomic, strong) NSString *idcard_num;
@property (nonatomic, strong) NSString *invite_code;
@property (nonatomic, assign) float invite_num;
@property (nonatomic, strong) NSString *invite_qr_url;
@property (nonatomic, assign) int invite_users;
@property (nonatomic, strong) NSString *jpush_alias_code;
@property (nonatomic, assign) int mgr_id;
@property (nonatomic, assign) float month_commission_percent;
@property (nonatomic, assign) int parent1_id;
@property (nonatomic, assign) int parent2_id;
@property (nonatomic, assign) float rating_commission_money;
@property (nonatomic, assign) float rating_commission_num;
@property (nonatomic, assign) short recommender_flag;
@property (nonatomic, assign) int recomment_userid;
@property (nonatomic, strong) NSString *reg_date;
@property (nonatomic, assign) float withdraw_agent_money;
@property (nonatomic, assign) int withdraw_agent_num;
@property (nonatomic, assign) float withdraw_money;
@property (nonatomic, assign) int withdraw_num;

+ (instancetype)sharedKit;
@end
