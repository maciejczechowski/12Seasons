//
//  DbManager.m
//  12Seasons
//
//  Created by Maciej Czechowski on 14.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "DbManager.h"
#import <sqlite3.h>
#import <FMDB.h>

@interface DbManager()

@property (nonatomic, strong) NSString *documentsDirectory;

@property (nonatomic, strong) FMDatabase *db;
@end
@implementation DbManager
static NSString *databaseName;



-(instancetype)init{
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename.
     //   self.databaseFilename = dbFilename;
        
        //// Copy the database file into the documents directory if necessary.
     //  [self copyDatabaseIntoDocumentsDirectory];
        
         self.db = [FMDatabase databaseWithPath: [self.documentsDirectory stringByAppendingPathComponent:databaseName]];
        
        if (![self.db open]) {
              return nil;
        }
    }
    return self;
}

+(void)copyDatabaseIntoDocumentsDirectory:(NSString*)dbName{
            databaseName=dbName;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }

    }
}

-(NSArray*)getSeasonalProductsForMonth:(int)forMonth andRegion:(NSString*)forRegion{
    NSMutableArray *results=[NSMutableArray array];
    

    
    FMResultSet *s = [self.db executeQuery: [NSString stringWithFormat:@"SELECT P.ID, P.NAME, M%i FROM SEASONALITY JOIN PRODUCT P ON P.ID=PRODUCT_ID WHERE  M%i IS NOT NULL AND M%i>0 AND REGION_ID=? ORDER BY  P.NAME",forMonth,forMonth,forMonth], forRegion ];
    
   //   FMResultSet *s = [self.db executeQueryWithFormat:@"SELECT * FROM SEASONALITY"];
    while ([s next]) {
        NSDictionary *productInSeason=@{
                                    @"ID": [s stringForColumnIndex:0],
                                    @"NAME": [s stringForColumnIndex:1],
                                    @"GOODNESS": [s stringForColumnIndex:2]
                                    
                                    };
        [results addObject:productInSeason];
    }
    return  results;
}

-(NSString*)getProductById:(NSString*)productId{
    
    FMResultSet *s = [self.db executeQueryWithFormat:@"SELECT P.NAME FROM PRODUCT P WHERE ID=%@",productId];
    if ([s next])
        return [s stringForColumnIndex:0];
    return  productId;

}


-(NSArray*)getSeasonDataForProductId:(NSString*)productId inRegion:(NSString*)regionId{
    
//
   // NSDateFormatter *df = [[NSDateFormatter alloc] init];

    
    FMResultSet *s = [self.db executeQueryWithFormat:@"SELECT M1, M2, M3, M4,M5,M6,M7,M8,M9,M10,M11,M12 FROM SEASONALITY S WHERE PRODUCT_ID=%@ AND REGION_ID=%@",productId,regionId];
    [s next];
  
    NSMutableArray *result=[[NSMutableArray alloc] initWithCapacity:12];
   // NSMutableString *result=[[NSMutableString alloc] init];
      for (int i=0; i<12; i++)
    {
        if ([s columnIndexIsNull:i])
            result[i]=[NSNumber numberWithInt:0];
        else {
                           result[i]=[NSNumber numberWithInt:[s intForColumnIndex:i]];
        }
        //      // // if (monthData!=nil)
     //       [result appendFormat:@"%@, ",[[df monthSymbols] objectAtIndex:(i)]];
            
    }
    
    return result;
    
}


-(NSArray*)getProducts{
        NSMutableArray *results=[NSMutableArray array];
    FMResultSet *s = [self.db executeQueryWithFormat:@"SELECT P.ID, P.NAME FROM PRODUCT P ORDER BY P.NAME"];
    
    while ([s next]) {
        NSDictionary *product=@{
                                        @"ID": [s stringForColumnIndex:0],
                                        @"NAME": [s stringForColumnIndex:1]
                                        
                                        };
        [results addObject:product];
    }
    return  results;
}
@end
