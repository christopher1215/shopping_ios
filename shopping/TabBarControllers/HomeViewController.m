//
//  HomeViewController.m
//  shopping
//
//  Created by Macbook on 2/13/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "SBSliderView.h"
#import "SBPhotoManager.h"
#import "DDKit.h"
#import "MJRefresh.h"

#import "Advert.h"
#import "Commodity.h"

#import "OrderViewController.h"
#import "JPUSHService.h"
#import "LogInViewController.h"


@interface HomeViewController ()<SBSliderDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *adverts;
    SBSliderView *slider;
    NSMutableArray *shopImgArrs;
    NSMutableArray *commodities;
    BOOL firstFlag;
    NSInteger currentInd;
}
@property (nonatomic) int last_id;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    adverts = [[NSMutableArray alloc] init];
    shopImgArrs = [[NSMutableArray alloc] init];
    commodities = [[NSMutableArray alloc] init];
    slider = [[[NSBundle mainBundle] loadNibNamed:@"SBSliderView" owner:self.SlideView options:nil] firstObject];
    
    slider.delegate = self;
    [self.SlideView addSubview:slider];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommodityCell"];
    [self addFooter];
    [self addRefreshKit];
    firstFlag = true;
    if ([UserInfoKit sharedKit].userID > 0) {
        [self loginAction];
    }
}
- (void)loginAction
{
    NSString * urlStr = [SERVER_URL stringByAppendingString: SVC_LOGIN];
    NSDictionary *data = @ {@"phone" : [NSString stringWithFormat:@"%@", [UserInfoKit sharedKit].phone],
        @"password" : [NSString stringWithFormat:@"%@", [UserInfoKit sharedKit].password]
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [Common showProgress:self.view];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              NSDictionary *latestLoans = [Common fetchData:responseObject];
              if (latestLoans) {
                  
                      [UserInfoKit sharedKit].userID = [[latestLoans objectForKey:@"user_id"] intValue];
                  
                      [UserInfoKit sharedKit].name = [latestLoans objectForKey:@"name"];
                      [UserInfoKit sharedKit].level = [[latestLoans objectForKey:@"level"] shortValue];
                      [UserInfoKit sharedKit].parent_name = [latestLoans objectForKey:@"parent_name"];
                      [UserInfoKit sharedKit].remain_buy_num = [[latestLoans objectForKey:@"remain_buy_num"] intValue];
                      [UserInfoKit sharedKit].dividend_num = [[latestLoans objectForKey:@"dividend_num"] intValue];
                      [UserInfoKit sharedKit].buy_num = [[latestLoans objectForKey:@"buy_num"] intValue];
                      [UserInfoKit sharedKit].level_str = [latestLoans objectForKey:@"level_str"];
                      [UserInfoKit sharedKit].current_money = [[latestLoans objectForKey:@"current_money"] floatValue];
                      [UserInfoKit sharedKit].buy_money = [[latestLoans objectForKey:@"buy_money"] floatValue];
                      [UserInfoKit sharedKit].invite_money = [[latestLoans objectForKey:@"invite_money"] floatValue];
                      [UserInfoKit sharedKit].total_commision = [[latestLoans objectForKey:@"total_commision"] floatValue];
                      
                      [UserInfoKit sharedKit].bank_account = [latestLoans objectForKey:@"bank_account"];
                      [UserInfoKit sharedKit].bank_cardid = [latestLoans objectForKey:@"bank_cardid"];
                      [UserInfoKit sharedKit].bank_name = [latestLoans objectForKey:@"bank_name"];
                      [UserInfoKit sharedKit].commission_percent = [[latestLoans objectForKey:@"commission_percent"] floatValue];
                      [UserInfoKit sharedKit].contact_phone = [latestLoans objectForKey:@"contact_phone"];
                      [UserInfoKit sharedKit].dividend_money = [[latestLoans objectForKey:@"dividend_money"] floatValue];
                      [UserInfoKit sharedKit].idcard_back_img = [latestLoans objectForKey:@"idcard_back_img"];
                      [UserInfoKit sharedKit].idcard_front_img = [latestLoans objectForKey:@"idcard_front_img"];
                      [UserInfoKit sharedKit].idcard_num = [latestLoans objectForKey:@"idcard_num"];
                      [UserInfoKit sharedKit].invite_code = [latestLoans objectForKey:@"invite_code"];
                      [UserInfoKit sharedKit].invite_num = [[latestLoans objectForKey:@"invite_num"] floatValue];
                      [UserInfoKit sharedKit].invite_qr_url = [latestLoans objectForKey:@"invite_qr_url"];
                      [UserInfoKit sharedKit].invite_users = [[latestLoans objectForKey:@"invite_users"] intValue];
                      [UserInfoKit sharedKit].jpush_alias_code = [latestLoans objectForKey:@"jpush_alias_code"];
                      [UserInfoKit sharedKit].mgr_id = [[latestLoans objectForKey:@"mgr_id"] intValue];
                      [UserInfoKit sharedKit].month_commission_percent = [[latestLoans objectForKey:@"month_commission_percent"] floatValue];
                      [UserInfoKit sharedKit].parent1_id = [[latestLoans objectForKey:@"parent1_id"] intValue];
                      [UserInfoKit sharedKit].parent2_id = [[latestLoans objectForKey:@"parent2_id"] intValue];
                      [UserInfoKit sharedKit].rating_commission_money = [[latestLoans objectForKey:@"rating_commission_money"] floatValue];
                      [UserInfoKit sharedKit].rating_commission_num = [[latestLoans objectForKey:@"rating_commission_num"] floatValue];
                      [UserInfoKit sharedKit].recommender_flag = [[latestLoans objectForKey:@"recommender_flag"] shortValue];
                      [UserInfoKit sharedKit].recomment_userid = [[latestLoans objectForKey:@"recomment_userid"] intValue];
                      [UserInfoKit sharedKit].reg_date = [latestLoans objectForKey:@"reg_date"];
                      [UserInfoKit sharedKit].withdraw_agent_money = [[latestLoans objectForKey:@"withdraw_agent_money"] floatValue];
                      [UserInfoKit sharedKit].withdraw_agent_num = [[latestLoans objectForKey:@"withdraw_agent_num"] intValue];
                      [UserInfoKit sharedKit].withdraw_money = [[latestLoans objectForKey:@"withdraw_money"] floatValue];
                      [UserInfoKit sharedKit].withdraw_num = [[latestLoans objectForKey:@"withdraw_num"] intValue];
                      [UserInfoKit sharedKit].contact_qq = [latestLoans objectForKey:@"contact_qq"];
                      
                      [JPUSHService setAlias:[UserInfoKit sharedKit].jpush_alias_code callbackSelector:nil
                                      object:self];
              } else {
                  [UserInfoKit sharedKit].userID = UNLOGIN_FLAG;
                  [UserInfoKit sharedKit].userID = 0;
                  [UserInfoKit sharedKit].name = @"";
                  [UserInfoKit sharedKit].phone = @"";
                  [UserInfoKit sharedKit].password = @"";
                  [UserInfoKit sharedKit].parent_name = @"";
                  [UserInfoKit sharedKit].current_money = 0;
                  [UserInfoKit sharedKit].buy_num = 0;
                  [UserInfoKit sharedKit].dividend_num = 0;
                  [UserInfoKit sharedKit].level_str = @"";
                  [UserInfoKit sharedKit].idcard_back_img = @"";
                  [UserInfoKit sharedKit].idcard_back_img = @"";
                  [UserInfoKit sharedKit].bank_account = @"";
                  [UserInfoKit sharedKit].bank_cardid = @"";
                  [UserInfoKit sharedKit].bank_name = @"";
                  [UserInfoKit sharedKit].idcard_num = @"";
                  [JPUSHService setAlias:@"" callbackSelector:nil
                                  object:self];

              }
              [Common hideProgress];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];
              //[Common showMessage:ERR_CONNECTION];
          }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    slider.frame = CGRectMake(0, 0, self.SlideView.frame.size.width,self.SlideView.frame.size.height);
    if (firstFlag) {
        [self getAdvInfo];
        firstFlag = false;
    }
    
}

- (void)getAdvInfo
{
    [adverts removeAllObjects];
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_AD_IMG];
    NSDictionary *data = @ {};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [Common showProgress:self.view];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              NSArray *latestLoans = [Common fetchArray:responseObject];
              if (latestLoans.count > 0) {
                  for (NSDictionary *latestloan in latestLoans) {
                      Advert *info = [Advert alloc];
                      info.advertID = [[latestloan objectForKey:@"id"] longValue];
                      if ([[latestloan objectForKey:@"image_url"] isKindOfClass:[NSNull class]]) {
                          info.image_url = @"";
                      } else {
                          info.image_url = [latestloan objectForKey:@"image_url"];
                      }
                      [shopImgArrs addObject:info.image_url];
                      [adverts addObject:info];
                  }
              }
//              shopImgArrs = [NSArray arrayWithObjects:@"Black-Car-HD-Wallpaper.jpg", @"lamborghini_murcielago_superveloce_2-2880x1800.jpg", @"nature-landscape-photography-lanscape-cool-hd-wallpapers-fullscreen-high-resolution.jpg", @"wallpaper-hd-3151.jpg", nil];
              [slider createSliderWithImages:shopImgArrs WithAutoScroll:_AUTO_SCROLL_ENABLED inView:self.SlideView];
              [Common hideProgress];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [Common hideProgress];
              [Common showMessage:ERR_CONNECTION];
          }];


}

#pragma mark - Custom Methods

- (void)addRefreshKit
{
    if([self.tableView.header isRefreshing]){
        [self.tableView.header endRefreshing];
    }
    if([self.tableView.footer isRefreshing]){
        [self.tableView.footer endRefreshing];
    }
    
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.last_id = 0;
        [weakSelf getInfo:weakSelf.last_id];
    }];
    self.tableView.header.automaticallyChangeAlpha = YES;
    [self.tableView.header beginRefreshing];
    
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    self.tableView.footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getInfo:weakSelf.last_id];
    }];
}

- (void)getInfo:(int)last_id
{
    __weak typeof(self) weakSelf = self;
    NSString * urlStr = [SERVER_URL stringByAppendingString:SVC_GOODS_MORE];
    NSDictionary *data = @ {
        @"last_id":[NSString stringWithFormat:@"%d", last_id],
        @"start":@"0",
        @"page_num":[NSString stringWithFormat:@"%d", RowsPerPage]
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              if (last_id == 0) {
                  [commodities removeAllObjects];
              }
              
              NSDictionary *latestLoans = [Common fetchData:responseObject];
              if(latestLoans) {
                  NSArray *commoditylists = [latestLoans objectForKey:@"commodities"];
                  for (NSDictionary *goods in commoditylists) {
                      Commodity *commodityItem = [Commodity alloc];
                      commodityItem.goods_id = [[goods objectForKey:@"goods_id"] integerValue];
                      commodityItem.name = [goods objectForKey:@"name"];
                      if ([[goods objectForKey:@"comment"] isKindOfClass:[NSNull class]]) {
                          commodityItem.comment = @"";
                      } else {
                          commodityItem.comment = [goods objectForKey:@"comment"];
                      }
                      commodityItem.cost = [[goods objectForKey:@"cost"] doubleValue];
                      if ([[goods objectForKey:@"original_url"] isKindOfClass:[NSNull class]]) {
                          commodityItem.original_url = @"";
                      } else {
                          commodityItem.original_url = [goods objectForKey:@"original_url"];
                      }
                      if ([[goods objectForKey:@"thumb_url"] isKindOfClass:[NSNull class]]) {
                          commodityItem.thumb_url = @"";
                      } else {
                          commodityItem.thumb_url = [goods objectForKey:@"thumb_url"];
                      }
                      commodityItem.buy_status = [[goods objectForKey:@"buy_status"] shortValue];
                      [commodities addObject:commodityItem];
                  }
                  weakSelf.last_id = [[latestLoans objectForKey:@"last_id"] intValue];

              }else{
                  
                  weakSelf.tableView.footer.hidden = YES;
              }
              [weakSelf.tableView reloadData];
              
              if([weakSelf.tableView.header isRefreshing]){
                  [weakSelf.tableView.header endRefreshing];
              } else {
                  [weakSelf.tableView.footer endRefreshing];
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if([weakSelf.tableView.header isRefreshing]){
                  [weakSelf.tableView.header endRefreshing];
              } else {
                  [weakSelf.tableView.footer endRefreshing];
              }
              [Common showMessage:ERR_CONNECTION];
          }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commodities count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView bounds].size.width / 25 * 7;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommodityCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommodityCell"];
    }
    if (indexPath.row < [commodities count]){
        Commodity *info = [Commodity alloc];
        info = [commodities objectAtIndex:indexPath.row];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:info.original_url] placeholderImageScale:[UIImage imageNamed:@"noImage.jpg"]];
        if (cell.imgView.gestureRecognizers.count == 0)
        {
            [cell.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)]];
        }
        cell.imgView.tag = indexPath.row;

        cell.lblTitle.text = info.name;
        cell.lblPrice.text = [NSString stringWithFormat:@"¥%.02f", info.cost];
        if (info.buy_status) {
            [cell.imgBuyState setHidden:YES];
            [cell.btnCart setHidden:NO];
            
        } else {
            [cell.imgBuyState setHidden:NO];
            [cell.btnCart setHidden:YES];
        }
        [cell.btnCart addTarget:self action:@selector(onBuy:) forControlEvents:UIControlEventTouchDown];
        cell.btnCart.tag = indexPath.row;
    }
    return cell;
}
- (void)tapCell:(UITapGestureRecognizer *)inGestureRecognizer
{
    UIImageView *childView = (UIImageView*)inGestureRecognizer.view;
    if (childView.tag < [commodities count]){// && self.detailFlag != DETAIL_ABLE_FLAG){
        Commodity *info = [commodities objectAtIndex:childView.tag];
        //goto nib of story board
        SBPhotoManager *photoViewerManager = [[SBPhotoManager alloc] init];
        UIImageView *tmpImgView = [[UIImageView alloc] init];
        [tmpImgView sd_setImageWithURL:[NSURL URLWithString:info.original_url] placeholderImageScale:[UIImage imageNamed:@"noImage.jpg"]];
        [photoViewerManager initializePhotoViewerFromViewControlller:self forTargetImageView:tmpImgView withPosition:self.tableView.frame];
        
    }
}

- (IBAction)onBuy:(id)sender {
    if([UserInfoKit sharedKit].userID > UNLOGIN_FLAG){
        
        UIButton *button = (UIButton *)sender;
        currentInd = button.tag;
        Commodity * info = [Commodity alloc];
        info = [commodities objectAtIndex:currentInd];
        OrderViewController *vc = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
        vc.title = STR_ORDER;
        vc.goods_id = info.goods_id;
        // Push the view controller.
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self gotoLogin];
    }

}
- (void)gotoLogin {
    // Create the next view controller.
    LogInViewController *loginViewController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
    // Push the view controller.
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)sbslider:(SBSliderView *)sbslider didTapOnImage:(UIImage *)targetImage andParentView:(UIImageView *)targetView indAdvert:(int)index{
    SBPhotoManager *photoViewerManager = [[SBPhotoManager alloc] init];
    [photoViewerManager initializePhotoViewerFromViewControlller:self forTargetImageView:targetView withPosition:sbslider.frame];

}

@end
