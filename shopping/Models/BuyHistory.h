//
//  BuyHistory.h
//  shopping
//
//  Created by Macbook on 02/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyHistory : NSObject
@property(nonatomic,strong) NSString *buy_date;
@property(nonatomic,strong) NSString *goods_name;
@property(nonatomic,assign) float goods_price;

@end
