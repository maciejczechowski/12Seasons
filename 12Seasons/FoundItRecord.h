//
//  FoundItRecord.h
//  12Seasons
//
//  Created by Maciej Czechowski on 19.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FoundItRecord : NSObject
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *placemarkName;
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) NSDate *createDate;
@end
