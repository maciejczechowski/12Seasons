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

@end

@implementation RecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
