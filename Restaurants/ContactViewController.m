//
//  ContactViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 1/3/2014.
//  Copyright (c) 2014 Philip Tolton. All rights reserved.
//

#import "ContactViewController.h"
#import "Footer.h"


@interface ContactViewController ()

@end

@implementation ContactViewController

CLLocationManager *locationManager;
MKMapView *mapView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated {
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
    [mapView setDelegate:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    if (newLocation.coordinate.latitude == oldLocation.coordinate.latitude){
        return;
    }
    
    CLLocation *currentLocation = newLocation;
    double lat = [self.restaurant.lat doubleValue];
    double lon = [self.restaurant.lon doubleValue];
    CLLocationCoordinate2D dest = CLLocationCoordinate2DMake(lat, lon);
    
    if (currentLocation != nil) {
        NSLog(@"Lat: %f",newLocation.coordinate.latitude);
        
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
        request.source = [MKMapItem mapItemForCurrentLocation];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:dest addressDictionary:nil];
        MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
        [destination setName:@"Destination"];
        //        [destination openInMapsWithLaunchOptions:nil];
        request.destination = destination;
        request.requestsAlternateRoutes = NO;
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        
        [directions calculateDirectionsWithCompletionHandler:
         ^(MKDirectionsResponse *response, NSError *error) {
             if (error) {
                 //bla
                 NSLog(@"Error %@", error);
             } else {
                 int dist = 0;
                 for (MKRoute *route in response.routes)
                 {
                     dist = route.distance;
                     [mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
                     for (MKRouteStep *step in route.steps)
                     {
                         NSLog(@"%@", step.instructions);
                     }
                     break;
                 }
                 CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake((newLocation.coordinate.latitude + dest.latitude)/2,(newLocation.coordinate.longitude + dest.longitude)/2);
                 CLLocationDistance centerToBorderMeters = [newLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:dest.latitude longitude:dest.longitude]];
                 if (dist > centerToBorderMeters){
                     centerToBorderMeters = dist * 0.6;
                 }
                 MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance
                 (centerCoord,
                  centerToBorderMeters + 10,   //vertical span
                  centerToBorderMeters + 10);  //horizontal span
                 [mapView setRegion:rgn animated:YES];
                 [locationManager stopUpdatingLocation];
             }
         }];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor bgColor] colorWithAlphaComponent:0.95f];
    
    Footer *footer = [[[NSBundle mainBundle] loadNibNamed:@"Footer" owner:self options:nil] objectAtIndex:0];
    
    footer.phone.text = self.restaurant.phone;
    footer.address.text = self.restaurant.address;
    footer.contact_title.font = [UIFont fontWithName:@"Freestyle Script Bold" size:30.0f];

    for (UIView * txt in footer.subviews){
        if ([txt isKindOfClass:[UILabel class]] && [txt isFirstResponder]) {
            ((UILabel *)txt).textColor = [UIColor textColor];
        }
    }
    mapView = footer.mapView;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    footer.mapView.delegate = self;
    self.footer = footer;
    [footer setNeedsLayout];
    self.view.frame = CGRectMake(0, 0, footer.frame.size.height, footer.frame.size.width);
    [self.view addSubview:footer];
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 1.0;
    return renderer;
}

- (IBAction)dismissModalView:(id)sender
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end

