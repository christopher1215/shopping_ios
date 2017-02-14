//
//  HomeViewController.m
//  shopping
//
//  Created by Macbook on 2/13/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "HomeViewController.h"
#import "SBSliderView.h"
#import "SBPhotoManager.h"
#import "DDKit.h"

@interface HomeViewController ()<SBSliderDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *adverts;
    SBSliderView *slider;
    NSMutableArray *shopImgArrs;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    adverts = [[NSMutableArray alloc] init];
    slider = [[[NSBundle mainBundle] loadNibNamed:@"SBSliderView" owner:self.SlideView options:nil] firstObject];
    
    slider.delegate = self;
    [self.SlideView addSubview:slider];


}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    slider.frame = CGRectMake(0, 0, self.SlideView.frame.size.width,self.SlideView.frame.size.height);
    [self getInfo];
}

- (void)getInfo
{
    [adverts removeAllObjects];
//    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_HOMEPAGE];
//    NSDictionary *data = @ {@"companyid" : [NSString stringWithFormat:@"%ld", [UserInfoKit sharedKit].companyID]};
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [Common showProgress:self.view];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    [manager POST:urlStr parameters:data
//          success:^(AFHTTPRequestOperation *operation, id responseObject){
//              NSDictionary *latestLoans = [Common fetchData:responseObject];
//              if(latestLoans) {
//                  NSArray *advertlists = [latestLoans objectForKey:@"advertisingEntityList"];
//                  if (advertlists.count > 0) {
//                      for (NSDictionary *advertitem in advertlists) {
//                          Advert *info = [Advert alloc];
//                          info.advertID = [[advertitem objectForKey:@"id"] longValue];
//                          info.merchandiseID = [[advertitem objectForKey:@"merchandiseID"] longValue];
//                          info.type = [[advertitem objectForKey:@"type"] shortValue];
//                          if ([[advertitem objectForKey:@"url"] isKindOfClass:[NSNull class]]) {
//                              info.url = @"";
//                          } else {
//                              info.url = [advertitem objectForKey:@"url"];
//                          }
//                          info.imgUrl = [NSString stringWithFormat:@"%@%@",IMAGE_URL_ADVERT,[advertitem objectForKey:@"imgUrl"]];
//                          info.createDate = [advertitem objectForKey:@"createDate"];
//                          info.deleted = [[advertitem objectForKey:@"deleted"] shortValue];
//                          [shopImgArrs addObject:info.imgUrl];
//                          [adverts addObject:info];
//                      }
//                  }
//              }
              shopImgArrs = [NSArray arrayWithObjects:@"Black-Car-HD-Wallpaper.jpg", @"lamborghini_murcielago_superveloce_2-2880x1800.jpg", @"nature-landscape-photography-lanscape-cool-hd-wallpapers-fullscreen-high-resolution.jpg", @"wallpaper-hd-3151.jpg", nil];
              [slider createSliderWithImages:shopImgArrs WithAutoScroll:_AUTO_SCROLL_ENABLED inView:self.SlideView];
//              [Common hideProgress];
//              
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"Error: %@", error);
//              [Common hideProgress];
//              [Common showMessage:ERR_CONNECTION];
//          }];


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
