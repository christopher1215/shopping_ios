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
@property (nonatomic, assign) long companyID;
@property (nonatomic, assign) int credit;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) short sex;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString *birthDate;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, strong) NSString *guideImgUrl;
@property (nonatomic, assign) long sectorID;
@property (nonatomic, assign) long positionID;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, assign) int answerTime;
@property (nonatomic, assign) int unreadCount;
@property (nonatomic, assign) int planTestCredit;
@property (nonatomic, assign) int companyTestCredit;
@property (nonatomic, assign) int personalTestCredit;
@property (nonatomic, assign) int cartCount;
@property (nonatomic, assign) float exchangeRate;

+ (instancetype)sharedKit;
@end
