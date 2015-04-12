//
//  FoundItTableViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 17.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "FoundItTableViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Parse/Parse.h>
#import "DbManager.h"
#import <MBProgressHUD.h>
#import "ParseManager.h"
#import "CongratulationsViewController.h"

@interface FoundItTableViewController ()  <MKMapViewDelegate, CongratulationsDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtComment;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellPlace;
@property (strong, nonatomic) MKPointAnnotation *currentAnnotatedPlace;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellProduct;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;
- (IBAction)saveAction:(id)sender;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong) NSString *productName;
@property int score;

- (IBAction)cancelAction:(id)sender;

@property (strong) NSString *placemarkName;
@end

@implementation FoundItTableViewController
BOOL coordiateSet;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnSave.enabled=NO;
    [self.navigationItem setHidesBackButton:YES];
    self.locationManager=[[CLLocationManager alloc] init ];
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.delegate=self;
    self.mapView.showsUserLocation=YES;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleGesture:)];
    lpgr.minimumPressDuration = 1.0;  //user must press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    self.productName=[[[DbManager alloc] init] getProductById:self.ProductId];
    self.cellProduct.textLabel.text=self.productName;
 //   self.navigationItem.prompt=self.productName;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.locationManager startUpdatingLocation];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    if (!coordiateSet) {
        MKCoordinateRegion mapRegion;
            mapRegion.center = mapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.05;
        mapRegion.span.longitudeDelta = 0.05;
        coordiateSet=YES;
    
        [mapView setRegion:mapRegion animated: YES];
    }
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    // if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
    //   return;
    self.btnSave.enabled=NO;
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    if (self.currentAnnotatedPlace==nil) {
        self.currentAnnotatedPlace = [[MKPointAnnotation alloc] init];
        [self.mapView addAnnotation:self.currentAnnotatedPlace];
    }
    self.currentAnnotatedPlace.coordinate = touchMapCoordinate;
    self.currentAnnotatedPlace.title = @"It's here!";
    CLLocation *loc=[[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [self geocodeLocation:loc];
    
}

- (void)geocodeLocation:(CLLocation*)location
{
    if (!self.geocoder)
        self.geocoder = [[CLGeocoder alloc] init];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             NSString *placeDecription;
             if (placemark.areasOfInterest.count>0)
             {
                 placeDecription=[placemark.areasOfInterest[0] description];
                 self.btnSave.enabled=YES;
             } else
                 if (placemark.addressDictionary!=nil) {
                     placeDecription=[NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
                     self.btnSave.enabled=YES;
                 }
             self.placemarkName=placeDecription;
             self.cellPlace.detailTextLabel.text=placeDecription;
         }
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)saveAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ParseManager saveDataForItem:self.ProductId withLatitude:self.currentAnnotatedPlace.coordinate.latitude withLongitude:self.currentAnnotatedPlace.coordinate.longitude inPlacemark:self.placemarkName withComments:self.txtComment.text resutHandler:^(PFObject *result, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.score=[(NSNumber*)result[@"score"] intValue];
        
        if (!error)
        {
            [self performSegueWithIdentifier:@"showCongrats" sender:self];
        

        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
            

        }
    }];

}
- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)finished{
    [self dismissViewControllerAnimated:YES completion:^{
           [self.navigationController popViewControllerAnimated:YES];
    }
   ];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"showCongrats"])
    {
      
        CongratulationsViewController *cvc=(CongratulationsViewController*)segue.destinationViewController;
        cvc.productName=self.productName;
        cvc.location=[[CLLocation alloc] initWithLatitude:self.currentAnnotatedPlace.coordinate.latitude longitude:self.currentAnnotatedPlace.coordinate.longitude];
        cvc.venue=self.placemarkName;
        cvc.delegate=self;
        cvc.score=self.score;
    }

}
@end
