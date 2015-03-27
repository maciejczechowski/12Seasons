//
//  DbManager.h
//  12Seasons
//
//  Created by Maciej Czechowski on 14.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DbManager : NSObject


-(NSArray*)getSeasonalProductsForMonth:(int)forMonth andRegion:(NSString*)forRegion;
+(void)copyDatabaseIntoDocumentsDirectory:(NSString*)dbName;
-(NSString*)getProductById:(NSString*)productId;
-(NSArray*)getProducts;

-(NSArray*)getSeasonDataForProductId:(NSString*)productId inRegion:(NSString*)regionId;
@end
