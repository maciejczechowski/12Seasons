//
//  HomeViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 27.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "HomeViewController.h"
#import "SeasonalityChartViewController.h"
#import "UIImage+ImageEffects.h"

@interface HomeViewController () <SeasonalityChartDelegate>
@property (nonatomic, strong) UIImageView *background;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.background= [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.background.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    [self.view addSubview:self.background];
    self.background.contentMode=UIViewContentModeScaleAspectFill;
   // self.background.image=[UIImage imageNamed:@"m3.jpg"];
    [self.view sendSubviewToBack:self.background];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
        self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
        self.navigationController.navigationBarHidden=NO;
}
- (void)transitionedToMonth:(int)monthId
{
    NSString *fileName=[NSString stringWithFormat:@"m%d.jpg", monthId];
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.33];
    //
    //UIImage *newImage=[[UIImage imageNamed:fileName]  applyBlurWithRadius:0 tintColor:tintColor saturationDeltaFactor:0.7 maskImage:nil];;

    UIImage *newImage=[UIImage imageNamed:fileName];

    [UIView transitionWithView:self.background
                      duration:0.4f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.background.image = newImage;
                    } completion:NULL];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"chart"])
    {
        SeasonalityChartViewController *trget=(SeasonalityChartViewController*)segue.destinationViewController;
        trget.chartDelegate=self;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
