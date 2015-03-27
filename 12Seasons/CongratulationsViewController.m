//
//  CongratulationsViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 24.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "CongratulationsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface CongratulationsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
- (IBAction)shareAction:(id)sender;
- (IBAction)closeAction:(id)sender;

@end

@implementation CongratulationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)createGraphObjectWithPlaceId:(id)placeId
{
    
}

- (IBAction)shareAction:(id)sender {
    NSMutableDictionary<FBOpenGraphObject> *object = [FBGraphObject openGraphObjectForPost];
    
    // specify that this Open Graph object will be posted to Facebook
    object.provisionedForPost = YES;
    
    // for og:title
    object[@"title"] = self.productName;
    
    // for og:type, this corresponds to the Namespace you've set for your app and the object type name
    object[@"type"] = @"product";
    object[@"data"] = @{@"type":@"geo_point",
                            @"location" : @{ @"longitude": @"-58.381667", @"latitude": @"-34.603333"} };
    
   
    // for og:description
    
    //    // for og:url, we cover how this is used in the "Deep Linking" section below
    //  object[@"url"] = @"http://example.com/roasted_pumpkin_seeds";
    
    // for og:image we assign the image that we just staged, using the uri we got as a response
    // the image has to be packed in a dictionary like this:
    
    [FBRequestConnection startForPostOpenGraphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            // get the object ID for the Open Graph object that is now stored in the Object API
            NSString *objectId = [result objectForKey:@"id"];
            NSLog([NSString stringWithFormat:@"object id: %@", objectId]);
            
            id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
            [action setObject:objectId forKey:@"product"];
           NSNumber *latitude=[NSNumber numberWithDouble:self.location.coordinate.latitude];
            NSNumber *longitude=[NSNumber numberWithDouble:self.location.coordinate.longitude];;
           // a//ction[@"data"] = @{@"type":@"geo_point",
           //                     @"location" : @{ @"longitude": @"-58.381667", @"latitude": @"-34.603333"} };
           
      
         /*  // action[@"data"] =  @{
                                        @"latitude": latitude, // these are NSNumber //objects, but i also
                                        @"longitude": longitude // tried to pass NSString objects
                                        
                                };*/
           
          //  action[@"latitude"]=
            //      action[@"longitude"]=[NSNumber numberWithDouble:self.location.coordinate.longitude];
           // [action setObject:@{ @"longitude": @"-58.381667", @"latitude": @"-34.603333"}  forKey:@"location"];
    //    [action setObject: @{@"type":@"geo_point",
         //                  @"longitude": @"-58.381667", @"latitude": @"-34.603333"}  forKey:@"location"];
            
         //   [action setObject:@{@"latitude": latitude,
           //                              @"longitude": longitude}
           //                     forKey:@"location"];
            
           
  
                 //      locationObject[@"data:latitude"]=latitude;
          //  locationObject[@"data:longitude"]=longitude;
            
            // THIS is the key, the custom properties MUST be within a dictionary called "data"
           // openGraphObject[@"data"] = @{@"location": @{@"latitude": self.imageLatitude, @"longitude": self.imageLongitude }};

      
               action[@"location:latitude"]=latitude;
               action[@"location:longitude"]=longitude;
            
            
            NSLog(@"Action: %@",[action description]);
          //  action[@"location"] =  @{ @"longitude": @"-58.381667", @"latitude": @"-34.603333"} ;
            
            [FBRequestConnection startForPostWithGraphPath:@"me/seasoneater:pin"
                                               graphObject:action
                                         completionHandler:^(FBRequestConnection *connection,
                                                             id result,
                                                             NSError *error) {
                                             if(!error) {
                                                 NSLog([NSString stringWithFormat:@"OG story posted, story id: %@", [result objectForKey:@"id"]]);
                                                 [[[UIAlertView alloc] initWithTitle:@"OG story posted"
                                                                             message:@"Check your Facebook profile or activity log to see the story."
                                                                            delegate:self
                                                                   cancelButtonTitle:@"OK!"
                                                                   otherButtonTitles:nil] show];
                                             }
                                             else {
                                                 // An error occurred
                                                 NSLog(@"Error posting the Open Graph object to the Object API: %@", error);
                                             }
                                         }];
        } else {
            // An error occurred
            NSLog(@"Error posting the Open Graph object to the Object API: %@", error);
        }
    }];
  
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
