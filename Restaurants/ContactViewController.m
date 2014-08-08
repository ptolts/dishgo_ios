//
//  ContactViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 1/3/2014.
//  Copyright (c) 2014 Philip Tolton. All rights reserved.
//

#import "ContactViewController.h"
#import "Footer.h"
#import "PinsView.h"
#import <FAKFontAwesome.h>


@interface ContactViewController ()

@end

@implementation ContactViewController

CLLocationManager *locationManager;
MKMapView *mapView;
UIView *loading;


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
    
    if (newLocation.coordinate.latitude != oldLocation.coordinate.latitude){
        return;
    }
    
    [loading removeFromSuperview];
    
    CLLocation *currentLocation = newLocation;
    double lat = [self.restaurant.lat doubleValue];
    double lon = [self.restaurant.lon doubleValue];
    CLLocationCoordinate2D dest = CLLocationCoordinate2DMake(lat, lon);
    
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
    
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
                     MKMapRect rect = route.polyline.boundingMapRect;
                     UIEdgeInsets insets = UIEdgeInsetsMake(25, 25, 25, 25);
                     MKMapRect biggerRect = [self.footer.mapView mapRectThatFits:rect edgePadding:insets];
                     [mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
                     [self.footer.mapView setVisibleMapRect:biggerRect animated:YES];

                     PinsView *addAnnotation = [[PinsView alloc] initWithCoordinate:newLocation.coordinate];
                     [self.footer.mapView addAnnotation:addAnnotation];
                     PinsView *adddAnnotation = [[PinsView alloc] initWithCoordinate:dest];
                     [self.footer.mapView addAnnotation:adddAnnotation];
                     
                     break;
                 }
                 
             }
         }];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor bgColor] colorWithAlphaComponent:0.95f];
    
    Footer *footer = [[[NSBundle mainBundle] loadNibNamed:@"Footer" owner:self options:nil] objectAtIndex:0];
    
    footer.phone.text = [self.restaurant.phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    footer.address.textAlignment = NSTextAlignmentCenter;
    footer.address.text = [NSString stringWithFormat:@"%@\n%@\n%@",self.restaurant.address,self.restaurant.city,self.restaurant.postal_code];
//    [footer.address sizeToFit];
//    footer.contact_title.font = [UIFont fontWithName:@"Copperplate-Bold" size:20.0f];
    
    Hours *hours = self.restaurant.gHours;
    NSString *hours_text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@",
                            hours.monday.toString,
                            hours.tuesday.toString,
                            hours.wednesday.toString,
                            hours.thursday.toString,
                            hours.friday.toString,
                            hours.saturday.toString,
                            hours.sunday.toString];
    footer.hours.text = hours_text;

//    [footer.hours sizeToFit];

    footer.contact_title.backgroundColor = [UIColor bgColor];
    footer.contact_title.font = [UIFont fontWithName:@"East Market NF" size:22.0f];
    [footer.contact_title sizeToFit];
    CGRect frame = footer.contact_title.frame;
    frame.size.width += 20;
    NSLog(@"Width :%@",CGRectCreateDictionaryRepresentation(frame));
    footer.contact_title.frame = frame;
    footer.contact_title.center = footer.contact_title_background.center;
    footer.backgroundColor = [UIColor bgColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"header_line_300.png"]];

    [footer.contact_title_background addSubview:imageView];
    [footer.contact_title_background sendSubviewToBack:imageView ];
    
    for (UIView * txt in footer.subviews){
        if ([txt isKindOfClass:[UILabel class]] && [txt isFirstResponder]) {
            ((UILabel *)txt).textColor = [UIColor textColor];
        }
    }
    
    mapView = footer.mapView;
    
    footer.mapView.autoresizingMask = UIViewAutoresizingNone;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
    footer.mapView.delegate = self;
    self.footer = footer;
    [footer setNeedsLayout];
    self.view.frame = CGRectMake(0, 0, footer.frame.size.width, footer.frame.size.height);
    [self.view addSubview:footer];
    
    UITapGestureRecognizer* phone1LblGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phone1LblTapped)];
    [self.footer.phone setUserInteractionEnabled:YES];
    [self.footer.phone addGestureRecognizer:phone1LblGesture];

    double lat = [self.restaurant.lat doubleValue];
    double lon = [self.restaurant.lon doubleValue];
    CLLocationCoordinate2D dest = CLLocationCoordinate2DMake(lat, lon);
    PinsView *adddAnnotation = [[PinsView alloc] initWithCoordinate:dest];
    [self.footer.mapView addAnnotation:adddAnnotation];
    self.footer.mapView.centerCoordinate = dest;

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(dest, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.footer.mapView regionThatFits:viewRegion];
    [self.footer.mapView setRegion:adjustedRegion animated:YES];
    self.footer.mapView.showsUserLocation = YES;
    
//    loading = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.footer.mapView.frame.size.width, self.footer.mapView.frame.size.height)];
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activityView.center=loading.center;
//    [activityView startAnimating];
//    [loading addSubview:activityView];
//    [self.footer.mapView addSubview:loading];
    FAKFontAwesome *check = [FAKFontAwesome timesCircleIconWithSize:22.0f];
    [check addAttribute:NSForegroundColorAttributeName value:[UIColor almostBlackColor]];
    UIImage *b = [check imageWithSize:CGSizeMake(22.0,22.0)];
    UIImageView *a = [[UIImageView alloc] initWithImage:b];
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(10,10,44,44)];
    [c addSubview:a];
    [c addTarget:self action:@selector(dismissModalView:) forControlEvents:UIControlEventTouchUpInside];
    [self.footer addSubview:c];
}

- (void)phone1LblTapped
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.footer.phone.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
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
    if(self.pops){
        [self.pops dismissPresentedNavigationController];
    }
}

@end

