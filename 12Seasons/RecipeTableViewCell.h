//
//  RecipeTableViewCell.h
//  12Seasons
//
//  Created by Maciej Czechowski on 23.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

@end
