//
//  SeasonalityChartViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 19.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "SeasonalityChartViewController.h"
#import "SeasonalitySingleMonthTableViewController.h"

@interface SeasonalityChartViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) SeasonalitySingleMonthTableViewController *previousMonth;
@property (nonatomic, strong) SeasonalitySingleMonthTableViewController *currentMonth;
@property (nonatomic, strong) SeasonalitySingleMonthTableViewController *nextMonth;


@end

@implementation SeasonalityChartViewController

-(void)loadView{
    [super loadView];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.pageIndicatorTintColor=[UIColor grayColor];
    pageControl.currentPageIndicatorTintColor=[UIColor blackColor];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource=self;
    self.delegate=self;

    self.automaticallyAdjustsScrollViewInsets=NO;
    self.currentMonthId=3;
   
}

-(void)viewWillAppear:(BOOL)animated{
    self.previousMonth = [[SeasonalitySingleMonthTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.currentMonth = [[SeasonalitySingleMonthTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.nextMonth = [[SeasonalitySingleMonthTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.currentMonth.MonthId=self.currentMonthId;
    self.nextMonth.MonthId=[self getNextMonthId:self.currentMonthId];
    self.previousMonth.MonthId=[self getPreviousMonthId:self.currentMonthId];
    self.title=self.currentMonth.title;
 
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setViewControllers:[[NSArray alloc] initWithObjects:self.currentMonth, nil ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil ];       // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    return self.nextMonth;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    return self.previousMonth;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed){
        int mid;
        if ([self.viewControllers firstObject]==self.previousMonth)
        {
            mid=self.previousMonth.MonthId;
            id tmp=self.previousMonth;
            self.previousMonth=self.nextMonth;
            self.nextMonth=self.currentMonth;
            self.currentMonth=tmp;
        } else
        {
            mid=self.nextMonth.MonthId;
            id tmp=self.nextMonth;
            self.nextMonth=self.previousMonth;
            self.previousMonth=self.currentMonth;
            self.currentMonth=tmp;
            
        }
        {
            self.currentMonthId=mid;
            self.previousMonth.MonthId=[self getPreviousMonthId:mid];
   
            self.currentMonth.MonthId=mid;
            self.nextMonth.MonthId=[self getNextMonthId:mid];
            self.title=((UIViewController*)[self.viewControllers firstObject]).title;
        }
        
  
    }
}

-(int)getPreviousMonthId:(int)monthId
{
    if (monthId==1)
        return 12;
    return  monthId-1;
}

-(int)getNextMonthId:(int)monthId
{
    if (monthId==12)
        return 1;
    return  monthId+1;
}
/*
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return  12;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return self.currentMonthId-1;
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
