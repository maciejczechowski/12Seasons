//
//  SeasonalityChartViewController.h
//  12Seasons
//
//  Created by Maciej Czechowski on 19.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SeasonalityChartDelegate <NSObject>

@required

- (void)transitionedToMonth:(int)monthId;

@end


@interface SeasonalityChartViewController : UIPageViewController
@property int currentMonthId;
@property (nonatomic, weak) id <SeasonalityChartDelegate> chartDelegate;
@end
