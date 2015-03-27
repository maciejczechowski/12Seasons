//
//  SeasonalitySingleMonthTableViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 19.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "SeasonalitySingleMonthTableViewController.h"
#import "DbManager.h"
#import "AppDelegate.h"
#import "ProductViewController.h"
@interface SeasonalitySingleMonthTableViewController ()
@property (nonatomic, strong) NSArray *seasonalProducts;
@property (nonatomic, strong) NSString *productId;
@end

@implementation SeasonalitySingleMonthTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView  registerClass:[UITableViewCell class] forCellReuseIdentifier:@"pc"];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.opaque=NO;
 //   self.tableView.superview.backgroundColor=[UIColor greenColor];
  //  self.view.backgroundColor=[UIColor clearColor];
    self.view.opaque=NO;
   // self.automaticallyAdjustsScrollViewInsets=NO;
   // self.tableView.contentInset=UIEdgeInsetsMake(64,0,0,0);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewśWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int monthNumber = self.MonthId;
    NSString * dateString = [NSString stringWithFormat: @"%d", monthNumber];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSDate* myDate = [dateFormatter dateFromString:dateString];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *stringFromDate = [formatter stringFromDate:myDate];
    return stringFromDate;
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  35;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
   // header.textLabel.backgroundColor= [UIColor blackColor];
    // Another way to set the background color
    //Note: does not preserve gradient effect of original header
     header.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
}
-(void)setMonthId:(int)MonthId{
    self->_MonthId=MonthId;
    self.title=[NSString stringWithFormat:@"Month %i",MonthId];
}

-(void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        DbManager *db=[[DbManager alloc ]init];
     
        
        self.seasonalProducts = [db getSeasonalProductsForMonth:self.MonthId andRegion:[AppDelegate getCurrentRegion]];
        
        // if you want to update your UI to reflect the fact that the update was done,
        // then dispatch that back to the main queue
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.seasonalProducts count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.productId=self.seasonalProducts[indexPath.row][@"ID"];
    if (self.monthDelegate)
       [ self.monthDelegate selectedProduct:self.productId];
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pc" ];
       cell.textLabel.text=self.seasonalProducts[indexPath.row][@"NAME"];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
   // if (cell.backgroundView==nil)
  ///  {
 //       UIBlurEffect *blur=[UIBlurEffect effectWithStyle: UIBlurEffectStyleLight];
 //       UIVisualEffectView *vefv=[[UIVisualEffectView alloc] initWithEffect:blur];
 //       UIVisualEffect *vibrancy=[UIVibrancyEffect effectForBlurEffect:blur];
       /* UIVisualEffectView *vibrancyView=[[UIVisualEffectView alloc] initWithEffect:vibrancy];
        vibrancyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [vefv.contentView addSubview:vibrancyView];
        [cell.textLabel removeFromSuperview];
        [vibrancyView.contentView addSubview:cell.textLabel];*/
 //       cell.backgroundView=vefv;
///    }
    return cell;
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProduct"])
    {
        ((ProductViewController*)segue.destinationViewController).productId=self.productId;
    }
}


@end
