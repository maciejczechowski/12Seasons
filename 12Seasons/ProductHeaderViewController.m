//
//  ProductHeaderViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 17.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "ProductHeaderViewController.h"
#import "FoundItTableViewController.h"
#import "SeasonalityChartViewController.h"
#import "DbManager.h"
#import "AppDelegate.h"
@interface ProductHeaderViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *seasonImage;

@property (strong, nonatomic) DbManager *dbManager;
@property (strong, nonatomic) NSMutableArray *monthOverlays;
@property (strong, nonatomic) NSMutableArray *monthNamesOverlays;
@property (strong, nonatomic) NSArray *seasonalityData;
@end

@implementation ProductHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager=[[DbManager alloc] init];

    self.view.backgroundColor=[UIColor whiteColor];
    self.seasonalityData=[self.dbManager getSeasonDataForProductId:self.ProductId inRegion:[AppDelegate getCurrentRegion]];

   
    
    float width=self.view.frame.size.width/3-1;
    float height=30;
    for (int y=0; y<4; y++)
    {
        for (int x=0; x<3; x++)
        {
            int monthNumber = y*3+x+1;
            NSString * dateString = [NSString stringWithFormat: @"%d", monthNumber];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM"];
            NSDate* myDate = [dateFormatter dateFromString:dateString];
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMMM"];
            NSString *stringFromDate = [formatter stringFromDate:myDate];
            
            
            UILabel *month=[[UILabel alloc] initWithFrame:CGRectMake(x*width+2, y*height+2, width-1, height-1)];
            
            NSLog(@"Frame %d: %f x %f",monthNumber, month.frame.origin.x, month.frame.origin.y);
            month.text=stringFromDate;
            month.textAlignment=NSTextAlignmentCenter;
            
             float percent= ([self.seasonalityData[monthNumber-1] integerValue])/100.0;
         //   month.backgroundColor=[UIColor colorWithRed:145/255.0 green:211/255.0 blue:148/255.0 alpha:(1) ] ;
            month.alpha=percent;
            month.textColor=[UIColor colorWithRed:6/255.0 green:148/255.0 blue:22/255.0 alpha:(1) ];
           
            [self.view addSubview:month];
            
        }
        
    }
  /*
    self.monthOverlays=[[NSMutableArray alloc] initWithCapacity:12];
    float x=0;
    float y=20;
    float xq=0;
    float width=self.view.frame.size.width/12;
    float monthHeight=20;
    for (int i=2; i<14;i++)
    {
        if (i>2 && (i-2)%3==0)
        {
            y=20;
            xq+=width*3;
        }
        
        //UIView *monthOverlay=[[UIView alloc] initWithFrame:CGRectMake(x, 0, width, self.view.frame.size.height)];
        UIVisualEffect *blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *monthOverlay=[[UIVisualEffectView alloc] initWithEffect:blur];
        monthOverlay.frame=CGRectMake(x, 0, width, self.view.frame.size.height);
        
        
        x+=width;
      //  monthOverlay.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
       [self.view addSubview:monthOverlay];
      //  [self.view bringSubviewToFront:monthOverlay];
        monthOverlay.layer.zPosition=1;
       
        monthOverlay.alpha=(1-[self.seasonalityData[i%12] integerValue]/100.0);
       //  monthOverlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:(1-[self.seasonalityData[i%12] integerValue]/100.0)];
        if([self.seasonalityData[i%12] integerValue]!=0) {
        UILabel *monthNameOverlay=[[UILabel alloc] initWithFrame:CGRectMake(xq, y,  width*3, monthHeight)];
            
        monthNameOverlay.text=[[df monthSymbols] objectAtIndex:(i%12)];
        y+=monthHeight;
   
          //      monthNameOverlay.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth ;
        monthNameOverlay.textAlignment=NSTextAlignmentCenter;
            monthNameOverlay.textColor=[UIColor whiteColor];// colorWithAlphaComponent:[self.seasonalityData[i%12] integerValue]/100.0];
            monthNameOverlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
            monthNameOverlay.layer.zPosition=2;
            monthOverlay.opaque=NO;
        [self.view addSubview:monthNameOverlay];
        //[self.view bringSubviewToFront:monthNameOverlay];
        }
        
        //self.monthOverlays[i]=monthOverlay;
        
        
    }*/
    // Do any additional setup after loading the view.
  }
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
   // self.topLayoutGuide

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"foundIt"])
    {
        FoundItTableViewController *fit=(FoundItTableViewController*)segue.destinationViewController;
        fit.ProductId=self.ProductId;
    }
}


@end
