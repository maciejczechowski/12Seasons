//
//  MainMenuControllerViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 16.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "MainMenuControllerViewController.h"
#import  <PFFacebookUtils.h>
#import "SeasonalityChartViewController.h"
#import "UIImage+ImageEffects.h"
#import "ParseManager.h"
#import <Parse/Parse.h>

@interface MainMenuControllerViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnProducts;

@property (weak, nonatomic) IBOutlet UIButton *btnPicks;
- (IBAction)touchLogin:(id)sender;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *viewProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;

@end

@implementation MainMenuControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
  /*
    UIImage *image=[[UIImage imageNamed:@"veggies.jpg" ] applyBlurWithRadius:0.1 tintColor:[UIColor clearColor] saturationDeltaFactor:0.4 maskImage:nil];
    
   // UIImage *image=[UIImage imageNamed:@"veggies.jpg" ];
    
    UIImageView *imageView= [[UIImageView alloc] initWithImage:image];
    imageView.frame=CGRectMake(0, -150, self.view.bounds.size.width, self.view.bounds.size.height+150);
    imageView.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.clipsToBounds=NO;
    self.view.clipsToBounds=NO;
   imageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
  */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self showButtons:YES];
      
        PFUser *usr=[PFUser currentUser] ;
        PFQuery *uquery=[PFUser query];
        [uquery getObjectInBackgroundWithId:usr.objectId block:^(PFObject *object, NSError *error) {
            self.lblScore.text=[NSString stringWithFormat:@"Your score: %d",[(NSNumber*)object[@"score"] intValue]];

        }];
        
     
        
    }
    else
    {
        [self showButtons:NO];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showSeasonality"])
    {
        SeasonalityChartViewController *scvc=(SeasonalityChartViewController*)segue.destinationViewController;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        
        
        scvc.currentMonthId=(int)components.month;
    }
}


-(void)showButtons:(BOOL)userLoggedIn{
    if (userLoggedIn)
    {
        self.viewProfileImage.profileID=[[PFFacebookUtils session] accessTokenData].userID;
        self.viewProfileImage.pictureCropping=FBProfilePictureCroppingSquare;
        self.btnLogin.hidden=YES;
        self.btnMap.hidden=NO;
        self.lblScore.hidden=NO;
       
    }
    else {
        self.btnLogin.hidden=NO;
        self.btnMap.hidden=YES;
        self.lblScore.hidden=YES;
    }
    
}


- (IBAction)touchLogin:(id)sender {
     // Set permissions required from the facebook user account
     NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location",@"publish_actions"];
     
     // Login PFUser using Facebook
     [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
     //     [_activityIndicator stopAnimating]; // Hide loading indicator
     
     if (!user) {
         NSString *errorMessage = nil;
         if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
         } else {
            NSLog(@"Uh oh. An error occurred: %@", error);
            errorMessage = [error localizedDescription];
         }
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                         message:errorMessage
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"Dismiss", nil];
         [alert show];
        } else {
     
            [self showButtons:YES];
         }
     }];
     
     //   [_activityIndicator startAnimating]; // Show loading indicator until login is finished
     
}
@end
