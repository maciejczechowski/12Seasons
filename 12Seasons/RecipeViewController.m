//
//  RecipeViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 23.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "RecipeViewController.h"

@interface RecipeViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnPickIt;
- (IBAction)pickItAction:(id)sender;
@property (nonatomic, strong) NSMutableArray *pickedRecipes;
@end

@implementation RecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickedRecipes=[[[NSUserDefaults standardUserDefaults] arrayForKey:@"PickedRecipes"] mutableCopy];
    
    if (self.pickedRecipes==nil)
    {
        self.pickedRecipes=[[NSMutableArray alloc] init];
    }
    if ([self.pickedRecipes filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"SELF==%@",self.recipeId]].count>0) {
        self.btnPickIt.title=@"PICKED";
        self.btnPickIt.enabled=NO;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString: self.recipeUrl ]]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pickItAction:(id)sender {

    [self.pickedRecipes addObject:self.recipeId];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.pickedRecipes forKey:@"PickedRecipes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.btnPickIt.title=@"PICKED";
    self.btnPickIt.enabled=NO;
    
}
@end
