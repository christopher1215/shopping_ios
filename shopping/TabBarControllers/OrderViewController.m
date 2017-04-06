//
//  OrderViewController.m
//  shopping
//
//  Created by Macbook on 06/03/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "OrderViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface OrderViewController ()<UIActionSheetDelegate>{
    NSString *orderNum;
    
}

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnPay.layer.cornerRadius = 5.0f;
    self.btnPay.layer.borderWidth = 1.0f;
    self.btnPay.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnPay.layer.masksToBounds = YES;
    [self getInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderViewer:) name:@"refreshOrderViewer" object:nil];
    self.lblMoney.text = [NSString stringWithFormat:@"帐号余额：%.02f元",[UserInfoKit sharedKit].current_money];
}
-(void)refreshOrderViewer:(NSNotification *)noti
{
    [self getInfo];
}

-(void)getInfo{
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GET_ORDERNUM];
    NSDictionary *data = @ {@"user_id"	: [NSString stringWithFormat:@"%ld", [UserInfoKit sharedKit].userID],
        @"goods_id"			: [NSString stringWithFormat:@"%ld", self.goods_id]
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [Common showProgress:self.view];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              [Common hideProgress];
              NSDictionary *latestLoans = [Common fetchData:responseObject];
              if (latestLoans) {
                  
                  orderNum = [latestLoans objectForKey: @"order_num"];
                  _lblOrderNum.text = orderNum;
                  _lblCost.text = [NSString stringWithFormat:@"¥%.02f", [[latestLoans objectForKey: @"cost"] floatValue]];
                      
              } else {
                  [self.navigationController popViewControllerAnimated:NO];
              };
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];
              [Common showMessage:ERR_CONNECTION];
          }];
    
}
- (IBAction)onPay:(id)sender {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信",@"钱包支付",/*@"支付宝",*/nil];
        [actionSheet showInView:self.view];

}


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld", (long)buttonIndex);
     if(buttonIndex == 0)
     {
         if ([WXApi isWXAppInstalled])
         {
             [self jumpToBizPay];
         } else
         {
             NSString *myHTMLSource = @"itunesurl://itunes.apple.com/cn/app/微信/id414478124?mt=8";
             //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:myHTMLSource]options:@{} completionHandler:nil];
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myHTMLSource] options:@{} completionHandler:nil];
         }
     }
     else if(buttonIndex == 1){
         NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_WALLET_PAY];
         NSDictionary *data = @ {@"user_id"	: [NSString stringWithFormat:@"%ld", [UserInfoKit sharedKit].userID],
             @"goods_id"			: [NSString stringWithFormat:@"%ld", self.goods_id],
             @"order_num"			: [NSString stringWithFormat:@"%@", orderNum]
         };
         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
         [Common showProgress:self.view];
         manager.responseSerializer = [AFJSONResponseSerializer serializer];
         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
         [manager POST:urlStr parameters:data
               success:^(AFHTTPRequestOperation *operation, id responseObject){
                   [Common hideProgress];
                   if ([[responseObject objectForKey:@"errCode"] intValue] == 0) {
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoProfileViewer" object:@{@"tabID":@"2"}];
                       UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付成功" message:[responseObject objectForKey:@"errMsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                       
                       [alter show];
                   } else {
                       UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:[responseObject objectForKey:@"errMsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                       
                       [alter show];
                   };
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@", error);
                   [Common hideProgress];
                   [Common showMessage:ERR_CONNECTION];
               }];
         
     }

/*     {
     
     NSString *appid = ALIPAY_APPID;
     NSString *partner = ALIPAY_PARTNER;
     NSString *seller = ALIPAY_SELLER;
     NSString *privateKey = ALIPAY_PRIVATEKEY;
     
     //partner和seller获取失败,提示
     if ([partner length] == 0 ||
     [seller length] == 0 ||
     [privateKey length] == 0)
     {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
     message:@"缺少partner或者seller或者私钥。"
     delegate:self
     cancelButtonTitle:@"确定"
     otherButtonTitles:nil];
     [alert show];
     return;
     }
     
     //         *生成订单信息及签名
     Commodity * info = [Commodity alloc];
     info = [commodities objectAtIndex:currentInd];
     NSString *products = info.name;
     
     NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GET_ORDERNUM];
     NSDictionary *data = @ {@"user_id"	: [NSString stringWithFormat:@"%ld", [UserInfoKit sharedKit].userID],
     @"goods_id"			: [NSString stringWithFormat:@"%ld", info.goods_id]
     };
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     [Common showProgress:self.view];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
     [manager POST:urlStr parameters:data
     success:^(AFHTTPRequestOperation *operation, id responseObject){
     [Common hideProgress];
     NSDictionary *latestLoans = [Common fetchData:responseObject];
     if (latestLoans) {
     //              if ([[responseObject objectForKey:@"errCode"] intValue] == 0) {
     //[Common showMessage:STR_INSERTCART_SUCCESS];
     Order* order = [Order new];
     order.app_id = appid;
     // NOTE: 支付接口名称
     order.method = @"alipay.trade.app.pay";
     // NOTE: 参数编码格式
     order.charset = @"utf-8";
     // NOTE: 当前时间点
     NSDateFormatter* formatter = [NSDateFormatter new];
     [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     order.timestamp = [formatter stringFromDate:[NSDate date]];
     // NOTE: 支付版本
     order.version = @"1.0";
     
     // NOTE: sign_type设置
     order.sign_type = @"RSA";
     // NOTE: 商品数据
     order.biz_content = [BizContent new];
     order.biz_content.body = products;
     order.biz_content.subject = @"问鼎-商品";
     order.biz_content.out_trade_no = [latestLoans objectForKey:@"order_num"];//[self generateTradeNO]; //订单ID（由商家自行制定）
     order.biz_content.timeout_express = @"30m"; //超时时间设置
     order.biz_content.total_amount = [NSString stringWithFormat:@"%.02f", info.cost]; //商品价格
     order.notify_url =  ALIPAY_NOTIFYURL; //回调URL
     //
     //                      order.paymentType = @"1";
     //                      order.showURL = @"m.alipay.com";
     //将商品信息拼接成字符串
     NSString *orderInfo = [order orderInfoEncoded:NO];
     NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
     NSLog(@"orderSpec = %@",orderInfo);
     
     // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
     //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
     id<DataSigner> signer = CreateRSADataSigner(privateKey);
     NSString *signedString = [signer signString:orderInfo];
     
     // NOTE: 如果加签成功，则继续执行支付
     if (signedString != nil) {
     //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
     NSString *appScheme = @"alipay2016121804387041";
     
     // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
     NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
     orderInfoEncoded, signedString];
     
     // NOTE: 调用支付结果开始支付
     [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
     NSLog(@"reslut = %@",resultDic);
     //                              [self gotoOrderViewer:2];
     
     }];
     }
     }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"Error: %@", error);
     [Common hideProgress];
     [Common showMessage:ERR_CONNECTION];
     }];
     
     
     }
    */
}

- (void)jumpToBizPay {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    /*
     *生成订单信息及签名
     */
    NSDictionary *sendData = @ {
      @"order_num"		: orderNum
      
    };
    NSString * urlStrSub = [SERVER_URL stringByAppendingString:SVC_PRE_WEIXIN_PAY];
    AFHTTPRequestOperationManager *managerSub = [AFHTTPRequestOperationManager manager];
    managerSub.responseSerializer = [AFJSONResponseSerializer serializer];
    managerSub.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [managerSub POST:urlStrSub parameters:sendData
           success:^(AFHTTPRequestOperation *operationSub, id resObject){
               NSDictionary *latestLoansSub = [Common fetchData:resObject];
               if (latestLoansSub) {
                   
                   NSMutableString *stamp  = [latestLoansSub objectForKey:@"timestamp"];
                   
                   //调起微信支付
                   PayReq* req             = [[PayReq alloc] init];
                   
                   req.partnerId           = @"1441972702";
                   req.prepayId            = [latestLoansSub objectForKey:@"prepay_id"];
                   req.nonceStr            = [latestLoansSub objectForKey:@"nonce_str"];
                   req.timeStamp           = stamp.intValue;
                   req.package             = [latestLoansSub objectForKey:@"package"];
                   req.sign                = [latestLoansSub objectForKey:@"sign"];
                   [WXApi sendReq:req];
                   //日志输出
                   NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",WECHAT_APPKEY,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                   //UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付成功" message:[latestLoans objectForKey:@"return_msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                   
                   //[alter show];
                   //[self gotoOrderViewer:0];
               }
           }
           failure:^(AFHTTPRequestOperation *operationSub, NSError *error) {
               NSLog(@"Error: %@", error);
               [Common hideProgress];
               [Common showMessage:ERR_CONNECTION];
           }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
