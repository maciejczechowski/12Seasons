//
//  AppDelegate.m
//  12Seasons
//
//  Created by Maciej Czechowski on 10.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "DbManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        [FBLoginView class];
    [Parse setApplicationId:@"88e4QDJCud8uIBouCG0vt7VV262SiRaTZWzPzZ2B"
                   clientKey:@"2MsqgF485lTikZYPI3zTG7yClTGpTdTxNJrpYxLp"];
        [PFFacebookUtils  initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [DbManager  copyDatabaseIntoDocumentsDirectory:@"seasons.sqlite"];
    // Override oint for customization after application launch.
    
  
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[PFFacebookUtils session] close];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

#warning  region do danych uzytkownika!
+(NSString*)getCurrentRegion{
    return  @"PL";
}

@end
