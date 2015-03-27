//
//  ParseManager.m
//  12Seasons
//
//  Created by Maciej Czechowski on 19.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "ParseManager.h"
#import "FoundItRecord.h"
#import <Parse/Parse.h>
@implementation ParseManager

/*
 [PFCloud callFunctionInBackground:@"hello"
 withParameters:@{}
 block:^(NSString *result, NSError *error) {
 if (!error) {
 // result is @"Hello world!"
 }
 }];
 */
+(void)saveDataForItem:(NSString*)item withLatitude:(double)latitude withLongitude:(double)longitude  inPlacemark:(NSString*)placemark withComments:(NSString*)comments resutHandler:(PFObjectResultBlock)completionBlock {

    
 /*   PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];
    PFObject *placeObject = [PFObject objectWithClassName:@"ProductFoundItRecord"];
    [placeObject setObject:point forKey:@"location"];
    [placeObject setObject: item forKey:@"productId"];
    [placeObject setObject:placemark forKey:@"locationDescription"];
    [placeObject setObject:comments forKey:@"comments"];
*/
    
    [PFCloud callFunctionInBackground:@"storeLocation"
                       withParameters:@{
                                        @"latitude": [NSNumber numberWithDouble:latitude],
                                        @"longitude": [NSNumber numberWithDouble:longitude],
                                        @"placemark": placemark,
                                        @"comments": comments,
                                          @"product": item
                                        }
                                block:^(PFObject *result, NSError *error) {
                                    completionBlock(result, error);

                                    if (!error) {
                                                                        }
                                }];
//    [placeObject saveInBackgroundWithBlock:completionBlock];
}

+(void)getItemsNear:(CLLocationCoordinate2D)location withRadius:(double)miles withBlock:(PFArrayResultBlock)completionBlock
{
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLatitude:location.latitude
                                                      longitude:location.longitude];
    PFQuery *query = [PFQuery queryWithClassName:@"FoundItRecord"];
    [query whereKey:@"location" nearGeoPoint:userGeoPoint withinMiles:20.0];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *foundItObjects;
        if (!error)
        {
            foundItObjects=[[NSMutableArray alloc] init];
            for (PFObject *obj in objects){
                FoundItRecord *rec=[[FoundItRecord alloc] init];
                
                PFGeoPoint *location=[obj objectForKey:@"location"];
                
                rec.productId=[obj objectForKey:@"productId"];
                rec.location=[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
                rec.placemarkName=[obj objectForKey:@"placemark"];
                rec.comments=[obj objectForKey:@"comments"];
                rec.createDate=[obj createdAt];
                [foundItObjects addObject:rec];
            }
        }
        completionBlock(foundItObjects,error);
    }];
}


+(void)getProduct:(NSString*)productId Near:(CLLocationCoordinate2D)location withRadius:(double)miles withBlock:(PFArrayResultBlock)completionBlock
{
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLatitude:location.latitude
                                                      longitude:location.longitude];
    PFQuery *query = [PFQuery queryWithClassName:@"FoundItRecord"];
    [query whereKey:@"location" nearGeoPoint:userGeoPoint withinMiles:20.0];
    [query whereKey:@"productId" equalTo:productId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *foundItObjects;
        if (!error)
        {
            foundItObjects=[[NSMutableArray alloc] init];
            for (PFObject *obj in objects){
                FoundItRecord *rec=[[FoundItRecord alloc] init];
                
                PFGeoPoint *location=[obj objectForKey:@"location"];
                
                rec.productId=[obj objectForKey:@"productId"];
                rec.location=[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
                rec.placemarkName=[obj objectForKey:@"placemark"];
                rec.comments=[obj objectForKey:@"comments"];
                rec.createDate=[obj createdAt];
                [foundItObjects addObject:rec];
            }
        }
        completionBlock(foundItObjects,error);
    }];
}

@end
