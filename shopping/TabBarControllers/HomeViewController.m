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
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:info.thumb_url] placeholderImageScale:[UIImage imageNamed:@"noImage.jpg"]];
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

- (IBAction)onBuy:(id)sender {
    UIButton *button = (UIButton *)sender;
    currentInd = button.tag;
    Commodity * info = [Commodity alloc];
    info = [commodities objectAtIndex:currentInd];
    OrderViewController *vc = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
    vc.title = STR_ORDER;
    vc.goods_id = info.goods_id;
    // Push the view controller.
    [self.navigationController pushViewController:vc animated:YES];

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
