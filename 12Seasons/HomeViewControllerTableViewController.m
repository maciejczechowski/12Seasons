//
//  HomeViewControllerTableViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 13.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "HomeViewControllerTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "DbManager.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "ProductViewController.h"
#import "UIImage+ImageEffects.h"

@interface HomeViewControllerTableViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) NSArray *seasonalProducts;
@property (strong, nonatomic) NSString *productId;
@end

@implementation HomeViewControllerTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    

    
  //  imageView.image=[imageView.image applyBlurWithRadius:80 tintColor: [UIColor clearColor] saturationDeltaFactor:0 maskImage:nil];
    /*UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.alpha=0.99f;
    [blurEffectView setFrame:self.tableView.bounds];
    [self.tableView.backgroundView addSubview:blurEffectView];
    */
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
        self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    self.viewHeader.frame=CGRectMake(0,0,10,200);
    self.navigationController.navigationBarHidden=YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        DbManager *db=[[DbManager alloc ]init];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        
        self.seasonalProducts = [db getSeasonalProductsForMonth:(int)components.month andRegion:[AppDelegate getCurrentRegion]];
        
        // if you want to update your UI to reflect the fact that the update was done,
        // then dispatch that back to the main queue
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
 /*   if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) { // Check if user is linked to Facebook
        // Present the next view controller without animation
        self.profilePictureView.profileID=[[PFFacebookUtils session] accessTokenData].userID;
        self.profilePictureView.hidden=NO;
        self.btnLogin.hidden=YES;
        [self performSegueWithIdentifier:@"showMainMenu" sender:self];
        self.viewLogin.hidden=YES;
      /*  PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:37.77 longitude:-122.41];
        PFObject *placeObject = [PFObject objectWithClassName:@"PlaceObject"];
        [placeObject setObject:point forKey:@"location"];
        [placeObject setObject:@"Asparagus" forKey:@"product"];
          [placeObject setObject:@"Not very fresh" forKey:@"comments"];
        [placeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error)
            {
                NSLog(@"Save succeded!");
            }
        }];*/
    /*
        DbManager *db=[[DbManager alloc ]init];
        NSArray *arr= [db getSeasonalProductsForMonth:3 andRegion:2];
        NSDictionary *rec1=arr[0];
        NSLog(@"Name %@",rec1[@"NAME"]);
    }*/
    
   }

-(void)viewDidAppear:(BOOL)animated{
   

}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Zrobic notyfikacje
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section==0){
        return 0; //TODO: notyfikacje
    } else
        return self.seasonalProducts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seasonalProduct"];
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"seasonalProduct"];
        }
          cell.textLabel.text=self.seasonalProducts[indexPath.row][@"NAME"];
        //  cell.detailTextLabel.text=self.seasonalProducts[indexPath.row][@"GOODNESS"];
    // Configure the cell...
    
        return cell;
    }
    return  nil;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0)
        return  nil;
    return @"In season";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1)
    {
        NSString *cid=self.seasonalProducts[indexPath.row][@"ID"];
        self.productId=cid;
        [self performSegueWithIdentifier:@"showProduct" sender:self];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showProduct"])
    {
        ProductViewController *pvc=(ProductViewController*)segue.destinationViewController;
        pvc.productId=self.productId;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
