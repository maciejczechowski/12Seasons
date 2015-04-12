//
//  ProductListTableViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 17.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "ProductListTableViewController.h"
#import "DbManager.h"
#import "ProductViewController.h"

@interface ProductListTableViewController () <UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, strong) NSArray* allProducts;
@property (nonatomic, strong) NSMutableArray* filteredProducts;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSString *productId;
@end

@implementation ProductListTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;

    //self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.navigationItem.titleView = self.searchController.searchBar;

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        DbManager *db=[[DbManager alloc ]init];
        
        self.allProducts=[db getProducts];
       self.filteredProducts = [NSMutableArray arrayWithCapacity:[self.allProducts count]];
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

    // Return the number of rows in the section.
    if (self.searchController.active) {
        return [self.filteredProducts count];
    } else {
        return [self.allProducts count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productCell"];
    }
    NSDictionary *product;
    
    if (self.searchController.active) {
        product = [self.filteredProducts objectAtIndex:indexPath.row];
    } else {
        product = [self.allProducts objectAtIndex:indexPath.row];
    }
    
    
    cell.textLabel.text=product[@"NAME"];
    
    return cell;
}

-(void)filterContentForSearchText:(NSString*)searchText {
    
    if ([searchText length]==0)
    {
        self.filteredProducts=[NSMutableArray arrayWithArray:self.allProducts];
        return;
    }
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
   // [self.filteredProducts removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF['NAME'] contains[c] %@",searchText];
    self.filteredProducts  = [NSMutableArray arrayWithArray:[self.allProducts filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    

    
    [self filterContentForSearchText:searchString];
    
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cid;
    if (self.searchController.active) {
        cid = [self.filteredProducts objectAtIndex:indexPath.row][@"ID"];
    } else {
        cid = [self.allProducts objectAtIndex:indexPath.row][@"ID"];
    }

    self.productId=cid;
    [self performSegueWithIdentifier:@"showProduct" sender:self];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self dismissViewControllerAnimated:NO completion:nil];
        
    
}

#pragma mark - Navigation

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
