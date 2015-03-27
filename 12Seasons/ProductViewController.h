//
//  ProductViewController.h
//  12Seasons
//
//  Created by Maciej Czechowski on 10.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductViewController : UITableViewController
@property (nonatomic, strong) NSArray *recipes;
@property (strong, atomic) NSString* productId;

@end
