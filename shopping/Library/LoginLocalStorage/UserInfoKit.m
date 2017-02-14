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
        _companyID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"companyID"] longValue];
        _credit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"credit"] intValue];
		_phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
        _logoUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"logoUrl"];
        _guideImgUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"guideImgUrl"];
        _status = [[[NSUserDefaults standardUserDefaults] objectForKey:@"status"] intValue];
        _sex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"] shortValue];
		_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
		_password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
		_birthDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"birthDate"];
		_createDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"createDate"];
        _sectorID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sectorID"] longValue];
        _positionID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"positionID"] longValue];
        _deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        _unreadCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"unreadCount"] intValue];
        _planTestCredit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"planTestCredit"] intValue];
        _companyTestCredit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"companyTestCredit"] intValue];
        _personalTestCredit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"personalTestCredit"] intValue];
        _cartCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cartCount"] intValue];
	}
	return self;
}

-(void)setUserID:(long)userID{
    _userID = userID;
    [[NSUserDefaults standardUserDefaults] setInteger:_userID?:UNLOGIN_FLAG forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)setCompanyID:(long)companyID{
    _companyID = companyID;
    [[NSUserDefaults standardUserDefaults] setInteger:_companyID?:0 forKey:@"companyID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)setCredit:(int)credit{
    _credit = credit;
    [[NSUserDefaults standardUserDefaults] setInteger:_credit?:0 forKey:@"credit"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void)setPhone:(NSString *)phone{
	_phone = phone;
	[[NSUserDefaults standardUserDefaults] setObject:_phone?:@"" forKey:@"phone"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setLogoUrl:(NSString *)logoUrl{
    _logoUrl = logoUrl;
    [[NSUserDefaults standardUserDefaults] setObject:_logoUrl?:@"" forKey:@"logoUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setGuideImgUrl:(NSString *)guideImgUrl{
    _guideImgUrl = guideImgUrl;
    [[NSUserDefaults standardUserDefaults] setObject:_guideImgUrl?:@"" forKey:@"guideImgUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setStatus:(int)status{
    _status = status;
    [[NSUserDefaults standardUserDefaults] setInteger:_status?:0 forKey:@"status"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setSex:(short)sex{
    _sex = sex;
    [[NSUserDefaults standardUserDefaults] setInteger:_sex?:0 forKey:@"sex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setName:(NSString *)name{
	_name = name;
	[[NSUserDefaults standardUserDefaults] setObject:_name?:@"" forKey:@"name"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPassword:(NSString *)password
{
    _password = password;
    [[NSUserDefaults standardUserDefaults] setObject:_password?:@"" forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setBirthDate:(NSString *)birthDate{
	_birthDate = birthDate;
	[[NSUserDefaults standardUserDefaults] setObject:_birthDate?:@"" forKey:@"birthDate"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCreateDate:(NSString *)createDate{
	_createDate = createDate;
	[[NSUserDefaults standardUserDefaults] setObject:_createDate?:@"" forKey:@"createDate"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setSectorID:(long)sectorID{
	_sectorID = sectorID;
	[[NSUserDefaults standardUserDefaults] setInteger:_sectorID?:0 forKey:@"sectorID"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPositionID:(long)positionID
{
    _positionID = positionID;
    [[NSUserDefaults standardUserDefaults] setInteger:_positionID?:0 forKey:@"positionID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setDeviceToken:(NSString *)deviceToken{
    _deviceToken = deviceToken;
    [[NSUserDefaults standardUserDefaults] setObject:_deviceToken?:@"" forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)setUnreadCount:(int)unreadCount{
    _unreadCount = unreadCount;
    [[NSUserDefaults standardUserDefaults] setInteger:_unreadCount?:0 forKey:@"unreadCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)setPlanTestCredit:(int)planTestCredit{
    _planTestCredit = planTestCredit;
    [[NSUserDefaults standardUserDefaults] setInteger:_planTestCredit?:0 forKey:@"planTestCredit"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setCompanyTestCredit:(int)companyTestCredit{
    _companyTestCredit = companyTestCredit;
    [[NSUserDefaults standardUserDefaults] setInteger:_companyTestCredit?:0 forKey:@"companyTestCredit"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setPersonalTestCredit:(int)personalTestCredit{
    _personalTestCredit = personalTestCredit;
    [[NSUserDefaults standardUserDefaults] setInteger:_personalTestCredit?:0 forKey:@"personalTestCredit"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setCartCount:(int)cartCount{
    _cartCount = cartCount;
    [[NSUserDefaults standardUserDefaults] setInteger:_cartCount?:0 forKey:@"cartCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setExchangeRate:(float)exchangeRate{
    _exchangeRate = exchangeRate;
    [[NSUserDefaults standardUserDefaults] setFloat:_exchangeRate?:0 forKey:@"exchangeRate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
