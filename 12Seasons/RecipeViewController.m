//
//  RecipeViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 23.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "RecipeViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface RecipeViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnPickIt;
- (IBAction)pickItAction:(id)sender;
- (IBAction)shareItActiion:(id)sender;
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
    if ([self.pickedRecipes filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"SELF['id']==%@",self.recipeUrl]].count>0) {
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
    self.navigationController.toolbarHidden=NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.toolbarHidden=YES;
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

    [self.pickedRecipes addObject:@{ @"id":self.recipeUrl,
                                     @"name":self.recipeName,
                                     @"image":self.recipeImageUrl
                                     }];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.pickedRecipes forKey:@"PickedRecipes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.btnPickIt.title=@"PICKED";
    self.btnPickIt.enabled=NO;
    
}

- (IBAction)shareItActiion:(id)sender {
    [self shareAction];
}

- (void)shareAction {
    //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    NSURL *recipeURL=[NSURL URLWithString:self.recipeUrl];
    NSURL *imageURL=[NSURL URLWithString:self.recipeImageUrl];
    BOOL res= [FBDialogs canPresentOSIntegratedShareDialog];
   /* UIImage *image=
    [FBDialogs presentOSIntegratedShareDialogModallyFrom:self initialText:self.recipeName image:imageURL url:recipeURL handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
        if (!error)
        {
            NSLog(@"OK!");
        }
    }];*/
    [FBDialogs presentShareDialogWithLink:recipeURL name:self.recipeName caption:@"Seasonal recipe" description:nil picture:imageURL clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        if (!error)
        {
            NSLog(@"OK!");
        }
    }];
  
}
@end
