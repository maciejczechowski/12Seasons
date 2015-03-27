//
//  SeasonalitySingleMonthTableViewController.h
//  12Seasons
//
//  Created by Maciej Czechowski on 19.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  SeasonalitySingleMonthDelegate <NSObject>

@required

- (void)selectedProduct:(NSString*)productId;

@end


@interface SeasonalitySingleMonthTableViewController : UITableViewController
@property (nonatomic) int MonthId;
@property (nonatomic, weak) id <SeasonalitySingleMonthDelegate> monthDelegate;
@end
