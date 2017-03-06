//
//  UserInfoKit.m
//  youtu
//
//  Created by qqq on 1/6/16.
//  Copyright © 2016 Christopher sh. All rights reserved.
//

#import "UserInfoKit.h"

@implementation UserInfoKit

+ (instancetype)sharedKit{
	static UserInfoKit *kit = nil;
	static dispatch_once_t onceUserId;
	dispatch_once(&onceUserId, ^{
		kit = [[UserInfoKit alloc] init];
	});
	return kit;
}

- (instancetype)init{
	self = [super init];
	if(self){
		_userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] longValue];
		_phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
        _level = [[[NSUserDefaults standardUserDefaults] objectForKey:@"level"] shortValue];
        _name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        _parent_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"parent_name"];
        _reamin_buy_num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"reamin_buy_num"] intValue];
        _buy_num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"buy_num"] intValue];
        _dividend_num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dividend_num"] intValue];
		_level_str = [[NSUserDefaults standardUserDefaults] objectForKey:@"level_str"];
		_current_money = [[[NSUserDefaults standardUserDefaults] objectForKey:@"current_money"] floatValue];
        _buy_money = [[[NSUserDefaults standardUserDefaults] objectForKey:@"buy_money"] floatValue];
        _invite_money = [[[NSUserDefaults standardUserDefaults] objectForKey:@"invite_money"] floatValue];
        _total_commision = [[[NSUserDefaults standardUserDefaults] objectForKey:@"total_commision"] floatValue];

        _bank_account = [[NSUserDefaults standardUserDefaults] objectForKey:@"bank_account"];
        _bank_cardid = [[NSUserDefaults standardUserDefaults] objectForKey:@"bank_cardid"];
        _bank_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"bank_name"];
        _commission_percent = [[[NSUserDefaults standardUserDefaults] objectForKey:@"commission_percent"] floatValue];
        _contact_phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"contact_phone"];
        _dividend_money = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dividend_money"] floatValue];
        _idcard_back_img = [[NSUserDefaults standardUserDefaults] objectForKey:@"idcard_back_img"];
        _idcard_front_img = [[NSUserDefaults standardUserDefaults] objectForKey:@"idcard_front_img"];
        _idcard_num = [[NSUserDefaults standardUserDefaults] objectForKey:@"idcard_num"];
        _invite_code = [[NSUserDefaults standardUserDefaults] objectForKey:@"invite_code"];
        _invite_num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"invite_num"] floatValue];
        _invite_qr_url = [[NSUserDefaults standardUserDefaults] objectForKey:@"invite_qr_url"];
        _invite_users = [[[NSUserDefaults standardUserDefaults] objectForKey:@"invite_users"] intValue];
        _jpush_alias_code = [[NSUserDefaults standardUserDefaults] objectForKey:@"jpush_alias_code"];
        _mgr_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mgr_id"] intValue];
        _month_commission_percent = [[[NSUserDefaults standardUserDefaults] objectForKey:@"month_commission_percent"] floatValue];
        _parent1_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"parent1_id"] intValue];
        _parent2_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"parent2_id"] intValue];
        _rating_commission_money = [[[NSUserDefaults standardUserDefaults] objectForKey:@"rating_commission_money"] floatValue];
        _rating_commission_num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"rating_commission_num"] floatValue];
        _recommender_flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"recommender_flag"] shortValue];
        _recomment_userid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"recomment_userid"] intValue];
        _reg_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"reg_date"];
        _withdraw_agent_money = [[[NSUserDefaults standardUserDefaults] objectForKey:@"withdraw_agent_money"] floatValue];
        _withdraw_agent_num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"withdraw_agent_num"] intValue];
        _withdraw_money = [[[NSUserDefaults standardUserDefaults] objectForKey:@"withdraw_money"] floatValue];
        _withdraw_num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"withdraw_num"] intValue];
	}
	return self;
}

-(void)setUserID:(long)userID{
    _userID = userID;
    [[NSUserDefaults standardUserDefaults] setInteger:_userID?:UNLOGIN_FLAG forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void)setPhone:(NSString *)phone{
	_phone = phone;
	[[NSUserDefaults standardUserDefaults] setObject:_phone?:@"" forKey:@"phone"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setLevel:(short)level{
    _level = level;
    [[NSUserDefaults standardUserDefaults] setInteger:_level?:0 forKey:@"level"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setName:(NSString *)name{
    _name = name;
    [[NSUserDefaults standardUserDefaults] setObject:_name?:@"" forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setPassword:(NSString *)password{
    _password = password;
    [[NSUserDefaults standardUserDefaults] setObject:_password?:@"" forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setParent_name:(NSString *)parent_name{
    _parent_name = parent_name;
    [[NSUserDefaults standardUserDefaults] setObject:_parent_name?:@"" forKey:@"parent_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void)setReamin_buy_num:(int)reamin_buy_num{
    _reamin_buy_num = reamin_buy_num;
    [[NSUserDefaults standardUserDefaults] setInteger:_reamin_buy_num?:0 forKey:@"reamin_buy_num"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setBuy_num:(int)buy_num{
	_buy_num = buy_num;
    [[NSUserDefaults standardUserDefaults] setInteger:_buy_num?:0 forKey:@"buy_num"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setDividend_num:(int)dividend_num{
    _dividend_num = dividend_num;
    [[NSUserDefaults standardUserDefaults] setInteger:_dividend_num?:0 forKey:@"dividend_num"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLevel_str:(NSString *)level_str
{
    _level_str = level_str;
    [[NSUserDefaults standardUserDefaults] setObject:_level_str?:@"" forKey:@"level_str"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCurrent_money:(float)current_money
{
    _current_money = current_money;
    [[NSUserDefaults standardUserDefaults] setFloat:_current_money?:0 forKey:@"current_money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setBuy_money:(float)buy_money
{
    _buy_money = buy_money;
    [[NSUserDefaults standardUserDefaults] setFloat:_buy_money?:0 forKey:@"buy_money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setInvite_money:(float)invite_money
{
    _invite_money = invite_money;
    [[NSUserDefaults standardUserDefaults] setFloat:_invite_money?:0 forKey:@"invite_money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTotal_commision:(float)total_commision
{
    _total_commision = total_commision;
    [[NSUserDefaults standardUserDefaults] setFloat:_total_commision?:0 forKey:@"total_commision"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBank_account:(NSString *)bank_account{
    _bank_account = bank_account;
    [[NSUserDefaults standardUserDefaults] setObject:_bank_account?:@"" forKey:@"bank_account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setBank_cardid:(NSString *)bank_cardid{
    _bank_cardid = bank_cardid;
    [[NSUserDefaults standardUserDefaults] setObject:_bank_cardid?:@"" forKey:@"bank_cardid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setBank_name:(NSString *)bank_name{
    _bank_name = bank_name;
    [[NSUserDefaults standardUserDefaults] setObject:_bank_name?:@"" forKey:@"bank_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setCommission_percent:(float)commission_percent
{
    _commission_percent = commission_percent;
    [[NSUserDefaults standardUserDefaults] setFloat:_commission_percent?:0 forKey:@"commission_percent"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setContact_phone:(NSString *)contact_phone{
    _contact_phone = contact_phone;
    [[NSUserDefaults standardUserDefaults] setObject:_contact_phone?:@"" forKey:@"contact_phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setDividend_money:(float)dividend_money
{
    _dividend_money = dividend_money;
    [[NSUserDefaults standardUserDefaults] setFloat:_dividend_money?:0 forKey:@"dividend_money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setIdcard_back_img:(NSString *)idcard_back_img{
    _idcard_back_img = idcard_back_img;
    [[NSUserDefaults standardUserDefaults] setObject:_idcard_back_img?:@"" forKey:@"idcard_back_img"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setIdcard_front_img:(NSString *)idcard_front_img{
    _idcard_front_img = idcard_front_img;
    [[NSUserDefaults standardUserDefaults] setObject:_idcard_front_img?:@"" forKey:@"idcard_front_img"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setIdcard_num:(NSString *)idcard_num{
    _idcard_num = idcard_num;
    [[NSUserDefaults standardUserDefaults] setObject:_idcard_num?:@"" forKey:@"idcard_num"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setInvite_code:(NSString *)invite_code{
    _invite_code = invite_code;
    [[NSUserDefaults standardUserDefaults] setObject:_invite_code?:@"" forKey:@"invite_code"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setInvite_num:(float)invite_num
{
    _invite_num = invite_num;
    [[NSUserDefaults standardUserDefaults] setFloat:_invite_num?:0 forKey:@"invite_num"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setInvite_qr_url:(NSString *)invite_qr_url{
    _invite_qr_url = invite_qr_url;
    [[NSUserDefaults standardUserDefaults] setObject:_invite_qr_url?:@"" forKey:@"invite_qr_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setInvite_users:(int)invite_users{
    _invite_users = invite_users;
    [[NSUserDefaults standardUserDefaults] setInteger:_invite_users?:0 forKey:@"invite_users"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setJpush_alias_code:(NSString *)jpush_alias_code{
    _jpush_alias_code = jpush_alias_code;
    [[NSUserDefaults standardUserDefaults] setObject:_jpush_alias_code?:@"" forKey:@"jpush_alias_code"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setMgr_id:(int)mgr_id{
    _mgr_id = mgr_id;
    [[NSUserDefaults standardUserDefaults] setInteger:_mgr_id?:0 forKey:@"mgr_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setMonth_commission_percent:(float)month_commission_percent
{
    _month_commission_percent = month_commission_percent;
    [[NSUserDefaults standardUserDefaults] setFloat:_month_commission_percent?:0 forKey:@"month_commission_percent"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setParent1_id:(int)parent1_id{
    _parent1_id = parent1_id;
    [[NSUserDefaults standardUserDefaults] setInteger:_parent1_id?:0 forKey:@"parent1_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setParent2_id:(int)parent2_id{
    _parent2_id = parent2_id;
    [[NSUserDefaults standardUserDefaults] setInteger:_parent2_id?:0 forKey:@"parent2_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setRating_commission_money:(float)rating_commission_money
{
    _rating_commission_money = rating_commission_money;
    [[NSUserDefaults standardUserDefaults] setFloat:_rating_commission_money?:0 forKey:@"rating_commission_money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setRating_commission_num:(float)rating_commission_num
{
    _rating_commission_num = rating_commission_num;
    [[NSUserDefaults standardUserDefaults] setFloat:_rating_commission_num?:0 forKey:@"rating_commission_num"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setRecommender_flag:(short)recommender_flag{
    _recommender_flag = recommender_flag;
    [[NSUserDefaults standardUserDefaults] setInteger:_recommender_flag?:0 forKey:@"recommender_flag"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)setRecomment_userid:(int)recomment_userid{
    _recomment_userid = recomment_userid;
    [[NSUserDefaults standardUserDefaults] setInteger:_recomment_userid?:0 forKey:@"recomment_userid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setReg_date:(NSString *)reg_date{
    _reg_date = reg_date;
    [[NSUserDefaults standardUserDefaults] setObject:_reg_date?:@"" forKey:@"reg_date"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setWithdraw_agent_money:(float)withdraw_agent_money
{
    _withdraw_agent_money = withdraw_agent_money;
    [[NSUserDefaults standardUserDefaults] setFloat:_withdraw_agent_money?:0 forKey:@"withdraw_agent_money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setWithdraw_agent_num:(int)withdraw_agent_num{
    _withdraw_agent_num = withdraw_agent_num;
    [[NSUserDefaults standardUserDefaults] setInteger:_withdraw_agent_num?:0 forKey:@"withdraw_agent_num"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setWithdraw_money:(float)withdraw_money
{
    _withdraw_money = withdraw_money;
    [[NSUserDefaults standardUserDefaults] setFloat:_withdraw_money?:0 forKey:@"withdraw_money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setWithdraw_num:(int)withdraw_num{
    _withdraw_num = withdraw_num;
    [[NSUserDefaults standardUserDefaults] setInteger:_withdraw_num?:0 forKey:@"withdraw_num"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
