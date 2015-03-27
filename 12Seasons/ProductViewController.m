//
//  ProductViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 10.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "ProductViewController.h"
#import <RestKit/RestKit.h>
#import "F2FRecipe.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DbManager.h"
#import "ProductHeaderViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ParseManager.h"
#import "FoundItRecord.h"
#import "RecipeTableViewCell.h"
#import "RecipeViewController.h"
@interface ProductViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *productLocationData;
@property (nonatomic, strong) UIButton *showMore;
@property int currentPage;
@property (nonatomic, strong) NSString *currentRecipeUrl;
@end

@implementation ProductViewController

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://food2fork.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *recipeMapping = [RKObjectMapping mappingForClass:[F2FRecipe class]];
    [recipeMapping addAttributeMappingsFromArray:@[@"title"]];
    [recipeMapping addAttributeMappingsFromArray:@[@"image_url"]];
      [recipeMapping addAttributeMappingsFromArray:@[@"f2f_url"]];
         [recipeMapping addAttributeMappingsFromArray:@[@"publisher_url"]];
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:recipeMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/api/search"
                                                keyPath:@"recipes"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager setAcceptHeaderWithMIMEType:@"text/html"];
    [objectManager addResponseDescriptor:responseDescriptor];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    
}

- (void)loadRecipes
{
    NSString *product = [[[DbManager alloc] init] getProductById:self.productId];
    NSString *apiKey=@"1c085b79bf6045bbac619b52d0dd8fdb";
    NSDictionary *queryParams = @{@"q" : product,
                                  @"key" : apiKey,
                                  @"page": [NSNumber numberWithInt:self.currentPage]
                                  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/search"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.recipes = mappingResult.array;
                                                  self.showMore.hidden=NO;
                                                  
                                                    [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Ups?': %@", error);
                                              }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage=1;
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate=self;
       [self.locationManager startUpdatingLocation];
    self.showMore= [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showMore setTitle:@"Show other" forState:UIControlStateNormal];
    [self.showMore addTarget:self action:@selector(showOther:) forControlEvents:UIControlEventTouchUpInside];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)showOther:(id)sender{
    self.currentPage++;
    self.showMore.hidden=YES;
    self.recipes=nil;
    [self.tableView reloadData];
    [self loadRecipes];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DbManager *dbm=[[DbManager alloc] init];
    self.title=[dbm getProductById:self.productId];
    [self configureRestKit];
    [self loadRecipes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.locationManager stopUpdatingLocation];
    CLLocation *location=(CLLocation*)[locations firstObject];
    [ParseManager getProduct: self.productId Near:location.coordinate withRadius:30 withBlock:^(NSArray *objects, NSError *error) {
        self.productLocationData=objects;
        [self.tableView reloadData];
    }];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   if (section==0)
       return  self.productLocationData.count;
    if (section==1)
        return  self.recipes.count;
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0)
        return @"Where is it";
    if (section==1)
        return @"Try it";
    return  nil;
        
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1 && self.recipes.count>0)
        return self.showMore;
    return  nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  if (section==1)
      return  44;
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1){
        RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recipeCell"];
    
        
    
    F2FRecipe *recipe=self.recipes[indexPath.row];
    cell.lblTitle.text=recipe.title;
    cell.recipeImage.contentMode = UIViewContentModeScaleAspectFill;
        cell.recipeImage.clipsToBounds=YES;
    [cell.recipeImage sd_setImageWithURL: [NSURL URLWithString:recipe.image_url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
    }
    if (indexPath.section==0)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"foundItCell"];
        FoundItRecord *fir=self.productLocationData[indexPath.row];
        cell.textLabel.text=fir.placemarkName;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%f km",[fir.location distanceFromLocation:self.locationManager.location]/1000];
        return cell;
    }
    return  nil;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1)
        return 80;
    return  44;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1){
        self.currentRecipeUrl=((F2FRecipe*)self.recipes[indexPath.row]).publisher_url;
    }
    return indexPath;

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"menu"])
    {
        ProductHeaderViewController *pvc=(ProductHeaderViewController*)segue.destinationViewController;
        pvc.ProductId=self.productId;
    }
    
    if ([[segue identifier] isEqualToString:@"showRecipe"])
    {
        RecipeViewController *rvc=(RecipeViewController*)segue.destinationViewController;
        rvc.recipeUrl=self.currentRecipeUrl;
    }
}


@end
