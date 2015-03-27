//
//  MapViewController.m
//  12Seasons
//
//  Created by Maciej Czechowski on 17.03.2015.
//  Copyright (c) 2015 Maciej Czechowski. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "DbManager.h"
#import "MKProductAnnotation.h"
#import "ParseManager.h"
#import "FoundItRecord.h"
#import <SEHumanizedTimeDiff/NSDate+HumanizedTime.h>

@interface MapViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *productsInRange;
@property (strong, nonatomic) NSMutableDictionary *productsDistances;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property int currentAnnotatedProduct;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager=[[CLLocationManager alloc] init ];
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation=YES;
    self.currentAnnotatedProduct=-1;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell"];
    NSDictionary *currentEntry=self.productsInRange[indexPath.row];
    
    NSString *productName=currentEntry[@"NAME"];

    cell.textLabel.text=productName;
    
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%f km", [(NSNumber*)currentEntry[@"DISTANCE"] doubleValue]/1000 ];
    
    
    return  cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productsInRange.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *currentEntry=self.productsInRange[indexPath.row];
    NSNumber *productId=currentEntry[@"ID"];
    self.currentAnnotatedProduct=[productId intValue];
    CLLocationCoordinate2D center = self.mapView.centerCoordinate;
    CLLocationCoordinate2D forceChg;
    forceChg.latitude = 0;
    forceChg.longitude = 0;
    self.mapView.centerCoordinate = forceChg;
    self.mapView.centerCoordinate = center;
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [mapView setRegion:mapRegion animated: YES];
    
    //query the nearest
    [ParseManager getItemsNear:userLocation.location.coordinate withRadius:20  withBlock:^(NSArray *objects, NSError *error) {
        
        if (!error){
            [self removeAllAnnotations];
      
            DbManager *dbm=[[DbManager alloc] init];
            CLLocation *userLocation=self.mapView.userLocation.location ;
            self.productsDistances=[[NSMutableDictionary alloc]init];
            
            for (FoundItRecord *obj in objects){
                
                    CLLocationDistance distance=[userLocation distanceFromLocation:obj.location];
                
                NSDictionary *locationObject=@{
                @"ID":obj.productId,
                @"NAME": [dbm getProductById:obj.productId],
                @"LOCATION": obj.location,
                @"COMMENTS": obj.comments,
                @"DISTANCE": [[NSNumber alloc] initWithDouble:distance],
                @"WHEN" : obj.createDate
                };
                
                NSDictionary *currentNearestProduct=[self.productsDistances objectForKey:obj.productId];
                
                if (currentNearestProduct==nil
                    || [(NSNumber*)currentNearestProduct[@"DISTANCE"] doubleValue]>[(NSNumber*)locationObject[@"DISTANCE"] doubleValue])
                {
                    self.productsDistances[obj.productId]=locationObject;
                }
                
                [self createAnnotationForProduct:locationObject];
            }
   
           
            self.productsInRange=[self.productsDistances allValues];
            
            [self.tableView reloadData];
        }
    }];
    
}

-(void)removeAllAnnotations
{
    id userAnnotation = self.mapView.userLocation;
    
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [annotations removeObject:userAnnotation];
    
    [self.mapView removeAnnotations:annotations];
}

-(void)createAnnotationForProduct:(NSDictionary*)productData
{
    NSString *whenString=[(NSDate*)productData[@"WHEN"]
stringWithHumanizedTimeDifference
];
    
    MKProductAnnotation *productAnnotation=[[MKProductAnnotation alloc] init];
    productAnnotation.coordinate=((CLLocation*)productData[@"LOCATION"]).coordinate;
    productAnnotation.title=
    
   [ NSString stringWithFormat:@"%@ (%@)",(NSString*)productData[@"NAME"], whenString ];
    productAnnotation.subtitle=(NSString*)productData[@"COMMENTS"];
    productAnnotation.ProductId=[(NSNumber*)productData[@"ID"] intValue];
    [self.mapView addAnnotation:productAnnotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKProductAnnotation class]])
    {
        MKProductAnnotation *productAnnotation=(MKProductAnnotation*)annotation;
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ProductPinAnnotationView"];
        if (!pinView)
        {
            // If an existing MKPinAnnotationView view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ProductPinAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
                    } else {
            pinView.annotation = annotation;
        }
        if (productAnnotation.ProductId==self.currentAnnotatedProduct)
            pinView.pinColor=MKPinAnnotationColorGreen;
        else
            pinView.pinColor=MKPinAnnotationColorRed;

        
        return pinView;
    }
    return nil;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *foundItAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Found it!" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // show UIActionSheet
    }];
    foundItAction.backgroundColor = [UIColor greenColor];
    /*
    UITableViewRowAction *flagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Flag" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // flag the row
    }];
    flagAction.backgroundColor = [UIColor yellowColor];
    */
    return @[foundItAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // No statement or algorithm is needed in here. Just the implementation
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
