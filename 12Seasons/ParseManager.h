//
//  ParseManager.h
//  12Seasons
//
//  Created by Maciej Czechowski on 19.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface ParseManager : NSObject

+(void)saveDataForItem:(NSString*)item withLatitude:(double)latitude withLongitude:(double)longitude  inPlacemark:(NSString*)placemark withComments:(NSString*)comments resutHandler:(PFObjectResultBlock)completionBlock;

+(void)getItemsNear:(CLLocationCoordinate2D)location withRadius:(double)miles withBlock:(PFArrayResultBlock)completionBlock;

+(void)getProduct:(NSString*)productId Near:(CLLocationCoordinate2D)location withRadius:(double)miles withBlock:(PFArrayResultBlock)completionBlock;
@end
