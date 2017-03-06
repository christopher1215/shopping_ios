
#ifndef Constant_h
#define Constant_h

#define 	UNLOGIN_FLAG            0
#define     IS_SHOW_SMS_MESG        NO
#define		RowsPerPage             20
#define     DETAIL_ABLE_FLAG        2   //disable = 2, enable = 0
#define     IMG_SEL_MAX_CNT         1
#define     _AUTO_SCROLL_ENABLED    1
#define     _AUTO_SCROLL_DISABLED   0

//jPush
#define     PUSH_APPKEY         @"c4f079c921d3180a8a819b99"
#define     PUSH_CHANNEL        @"Publish channel"

//WECHAT PAYMENT
#define     WECHAT_APPKEY       @"wx9ab18451cd240865"
#define     APP_SECRET @"998d17563f0d6d0181b90ff543656ygrs"              //appsecret
#define     MCH_ID @"1269999401"                                        //商户号
#define     PARTNER_ID @"xbM5MBCVOj2sEAs8KrMfwla4djpcQKuvG9"            //商户API密钥

#define     ALIPAY_APPID            @"2016121804387041"
#define     ALIPAY_PARTNER          @"2088521377179293"
#define     ALIPAY_SELLER           @"2088521377179293"
#define     ALIPAY_NOTIFYURL        @"http://httpslnwd.com/appApi/ajax/payment/alipay/alipayRSA/notify_url/php"
#define     ALIPAY_PRIVATEKEY       @"MIICXAIBAAKBgQCul05VeqZWTaY8HQieYnAouCFG3TTgerPiMm/tt//HVmb88jWs+A4Y3sT2Y8Arn7FgWwZHbb+X/+ydHXnM9I+BH2Ro72qEE07GbxnduhHcaJzhV33HSANTvogvC3G1EnyNn/8jFXOvsQBOSYkKjRI58HoZNQtfvN30UVFaEVK9MQIDAQABAoGAY3q3GaF+8aHg3FO2u3hfa/QukdAs9tMzd+lBOXQj+5LRr8LarqnQbn9QPwvrTW/6g2qaE00HZDZgvc0zv4KB2SHA3Q6n4O2/+wjCMxMXI066m1zLp3Ll7iN8EB+Fq0CmofPB+4kns8t9yKHAUQ+6VUR9jFgYdhgv/AOoU6bWjyECQQDc2Fc4QJ5738smVwzaaLQZiLMgFkKyK3kwGA778aYruJFltwQ4FrIwVbF2BwbDNasDEiR5bp9jOUdibWhcmLStAkEAymIRCIFV3E/Wmhm7Ux7Z0FH9U6Rrw7KGZtNCWtgbCJd2D9Uk48kG+ALCrApyyxYDxIqZJSekvsoegTMB0n33FQJASj4wlCilHt/NW8ZH++TXJv5duZvCMEONKi3sW6aRRoF138v3DyQSI02rqxIRo+6W3yFqQah+zMykwuIlA3wSwQJBAMRVYqTXo834/f29HMdEVJYOFC4CgjD1jgFOzT6IC6HIHda6NfFs4f/T3bs836Q5FSqkMnGjBeW4+uLn8sqbPQkCQH+HmSiP/vG1XJXVA0pPbSSSgEi/Mz1DY2x7UrAgzudg3g20A7BYTKMo9pyy3ud2pVz236+CBeR+h8owUZb7nSE="

#define     RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]
#define     RGBA(r, g, b, a) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:a]
#define 	TimeStamp [NSString stringWithFormat:@"%ld",[[NSDate date] timeIntervalSince1970]]

#endif /* Constant_h */
