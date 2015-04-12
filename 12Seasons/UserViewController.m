//
//  UserViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 28.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "UserViewController.h"
#import "ParseManager.h"
@interface UserViewController ()
@property (nonatomic, strong) NSArray *topUsers;
@property (nonatomic, strong) NSDictionary  *yourPosition;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ParseManager getTopUsersWithCompletionBlock:^(NSArray *objects, NSError *error) {
        self.topUsers=objects;
        [self.tableView reloadData ];
    }];
    
    [ParseManager getCurrentUserPosition:^(NSDictionary *result, NSError *error) {
        self.yourPosition=result;
        [self.tableView reloadData];
    }];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (section==0)
    {
        return  self.topUsers.count;
    }
    return  0;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0 && self.yourPosition)
    {
        return  [NSString stringWithFormat:@"Your position: %d, with score: %d",[(NSNumber*)self.yourPosition[@"position"] intValue], [(NSNumber*)self.yourPosition[@"score"] intValue]];
    }
    
    return  nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0)
        return @"Top users";
    if (section==1)
        return @"Recent activity";
    return  nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topUserCell" forIndexPath:indexPath];
    cell.textLabel.text=[NSString stringWithFormat:@"%d. %@",(int)indexPath.row+1, self.topUsers[indexPath.row][@"username"]];
    cell.detailTextLabel.text=[NSString stringWithFormat: @"%d",[(NSNumber*)self.topUsers[indexPath.row][@"score"] intValue]];
    // Configure the cell...
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
