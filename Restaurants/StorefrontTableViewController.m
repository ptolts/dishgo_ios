//
//  StorefrontTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 10/29/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "StorefrontTableViewController.h"
#import "Header.h"
#import "Footer.h"
#import "RAppDelegate.h"
#import <RestKit/RestKit.h>
#import "Dishes.h"
#import "Option.h"
#import "Options.h"
#import "Sections.h"
#import "Subsections.h"
#import "DishViewCell.h"
#import "TableHeaderView.h"
#import "SectionTableViewController.h"
#import "DishScrollView.h"

@interface StorefrontTableViewController ()
@end

@implementation StorefrontTableViewController
    NSMutableArray *sectionsList;
    NSMutableArray *shoppingCart;
    NSArray *fetchedRestaurants;
    int current_page = 0;
    NSSet *defaultSectionsList;
    // io Card pin: 4827b4c8bc7646e08c699c9bd2ebde76
    CLLocationManager *locationManager;
    MKMapView *mapView;


- (void)dealloc {
    [locationManager stopUpdatingLocation];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
                 NSLog(@"Error");
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
    
    shoppingCart = [[NSMutableArray alloc] init];
    
    Header *header = [[[NSBundle mainBundle] loadNibNamed:@"Header" owner:self options:nil] objectAtIndex:0];
    header.label.text = self.restaurant.name;
    header.scroll_view.restaurant = self.restaurant;
    [header.scroll_view setupImages];
    self.tableView.tableHeaderView = header;
    
    Footer *footer = [[[NSBundle mainBundle] loadNibNamed:@"Footer" owner:self options:nil] objectAtIndex:0];
    
    footer.phone.text = self.restaurant.phone;
    footer.address.text = self.restaurant.address;
    mapView = footer.mapView;
    self.tableView.tableFooterView = footer;
    
    [self loadMenu];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    footer.mapView.delegate = self;
    NSLog(@"StoreFrontLoaded");
	// Do any additional setup after loading the view.
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
//    if (sectionIndex == 0)
//        return 0;
    
    return 33;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 117;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionsList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if([sectionsList count] == 0){
        return 0;
    }
    
    return 1;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    current_page = [((DishViewCell *)([(UITableView *)self.tableView cellForRowAtIndexPath:indexPath])).dishScrollView currentPage];
    NSLog(@"ScrollViewOffset Current_Page: %d",current_page);
    [self performSegueWithIdentifier:@"menuSectionClick" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DishViewCell";
    
    DishViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DishViewCell" owner:self options:nil] objectAtIndex:0];
    } else {
        for (UIView *aView in [NSArray arrayWithArray:cell.dishScrollView.subviews]) {
            [aView removeFromSuperview];
        }
    }
    

    cell.dishScrollView.section = [sectionsList objectAtIndex:indexPath.section];
    [cell.dishScrollView setupViews];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if ([[sectionsList objectAtIndex:sectionIndex] isKindOfClass:[Sections class]]){
        return [self headerView:sectionIndex tableView:tableView];
    } else if ([[sectionsList objectAtIndex:sectionIndex] isKindOfClass:[Subsections class]]){
        return [self subheaderView:sectionIndex tableView:tableView];
    } else {
        return nil;
    }
}

- (UIView *) headerView:(NSInteger)sectionIndex tableView:(UITableView *)tableView
{
    Sections *section = [sectionsList objectAtIndex:sectionIndex];
    if([section.name length] == 0){
        return nil;
    }
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    label.text = section.name;
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    [view addSubview:label];
    
    TableHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] objectAtIndex:0];
    view.headerTitle.text = section.name;
    return view;
    
}

- (UIView *) subheaderView:(NSInteger)sectionIndex tableView:(UITableView *)tableView
{
    Subsections *section = [sectionsList objectAtIndex:sectionIndex];
    if([section.name length] == 0){
        return nil;
    }
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    view.backgroundColor = [UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    label.text = section.name;
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    [view addSubview:label];
    
    TableHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] objectAtIndex:0];
    view.headerTitle.text = section.name;
    return view;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // unwrap the controller if it's embedded in the nav controller.
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    
    if ([controller isKindOfClass:[SectionTableViewController class]]) {
        SectionTableViewController *vc = (SectionTableViewController *)controller;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"Section ID: %@",[[sectionsList objectAtIndex:indexPath.row] objectID]);
        vc.section = [sectionsList objectAtIndex:indexPath.section];
        vc.current_page = current_page;
        vc.shoppingCart = shoppingCart;
        vc.managedObjectStore = self.managedObjectStore;
    } else {
        NSLog(@"Class: %@",segue.destinationViewController);
        NSAssert(NO, @"Unknown segue. All segues must be handled.");
    }
    
}
- (void) loadMenu {
    
    NSLog(@"SUBVIEW RESTAURANT ID: %@",self.restaurant.objectID);
//    sectionsList = [[NSMutableArray alloc] init];
    sectionsList = (NSMutableArray *)[self.restaurant.menu allObjects];
    
//    fetchedRestaurants = [self.restaurant.menu allObjects];
    
//    sectionsList = [[NSMutableArray alloc] init];
//    
//    for(Sections *sec in fetchedRestaurants){
//        [sectionsList addObject:sec];
//        for(Subsections *sub in sec.subsections){
//            [sectionsList addObject:sub];
//        }
//    }
    
//    [sectionsList sortUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES], nil]];
    
    [self.tableView reloadData];
    
    
    ////////// QUERY NEW DATA AND UPDATE TABLE.
    
    RKManagedObjectStore *managedObjectStore = self.managedObjectStore;
    
    ///// MAPPINGS
    RKEntityMapping *dishesMapping = [RKEntityMapping mappingForEntityForName:@"Dishes" inManagedObjectStore:managedObjectStore];
    [dishesMapping addAttributeMappingsFromDictionary:@{
                                                        @"name": @"name",
                                                        @"id": @"id",
                                                        @"price": @"price",
                                                        @"index":@"position",
                                                        @"description": @"description_text",
                                                        }];
    dishesMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *sectionsMapping = [RKEntityMapping mappingForEntityForName:@"Sections" inManagedObjectStore:managedObjectStore];
    [sectionsMapping addAttributeMappingsFromDictionary:@{
                                                          @"name": @"name",
                                                          @"id": @"id",
                                                          @"index":@"position",
                                                          }];
    sectionsMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *subsectionsMapping = [RKEntityMapping mappingForEntityForName:@"Subsections" inManagedObjectStore:managedObjectStore];
    [subsectionsMapping addAttributeMappingsFromDictionary:@{
                                                             @"name": @"name",
                                                             @"id": @"id",
                                                             @"index":@"position",
                                                             }];
    subsectionsMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *optionMapping = [RKEntityMapping mappingForEntityForName:@"Option" inManagedObjectStore:managedObjectStore];
    [optionMapping addAttributeMappingsFromDictionary:@{
                                                        @"name": @"name",
                                                        @"price": @"price",
                                                        @"id": @"id",
                                                        }];
    optionMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *optionsMapping = [RKEntityMapping mappingForEntityForName:@"Options" inManagedObjectStore:managedObjectStore];
    [optionsMapping addAttributeMappingsFromDictionary:@{
                                                         @"name": @"name",
                                                         @"id": @"id",
                                                         }];
    optionsMapping.identificationAttributes = @[ @"id" ];

    
    
    [sectionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"subsections" toKeyPath:@"subsections" withMapping:subsectionsMapping]];
    [subsectionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dishes" toKeyPath:@"dishes" withMapping:dishesMapping]];
    [dishesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"options" toKeyPath:@"options" withMapping:optionsMapping]];
    [optionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"options" toKeyPath:@"list" withMapping:optionMapping]];
    
    NSString *query = [NSString stringWithFormat:@"/api/v1/restaurants/menu"]; //?id=%@",self.restaurant.id];
    NSString *url = [NSString stringWithFormat:@"http://dev.foodcloud.ca:3000/api/v1/restaurants/menu?id=%@",self.restaurant.id];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:sectionsMapping method:RKRequestMethodAny pathPattern:query keyPath:@"menu" statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    operation.managedObjectCache = managedObjectStore.managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        
//        NSLog(@"Total Sections: %d",[result.array count]);
        
//        defaultSectionsList = [result set];
//        fetchedRestaurants = [result array];
//        
//        sectionsList = [[NSMutableArray alloc] init];
//        for(Sections *sec in fetchedRestaurants){
//            [sectionsList addObject:sec];
//            for(Subsections *sub in sec.subsections){
//                [sectionsList addObject:sub];
//            }
//        }
        
//        for(Sections *sec in [result array]){
//            for(Subsections *sub in sec.subsections){
//                for(Dishes *di in sub.dishes){
//                    NSLog(@"%.02f",[di.price floatValue]);
//                }
//            }
//        }
        
        sectionsList = (NSMutableArray *)[result array];
        
        [sectionsList sortUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES], nil]];

        self.restaurant = (Restaurant *)[[[[result array] firstObject] managedObjectContext] objectWithID:[self.restaurant objectID]];
        self.restaurant.menu = [result set];

        NSError *error;
        NSLog(@"SAVING MENU OF SIZE %lu",(unsigned long)[[result array] count]);
        if (![[self.restaurant managedObjectContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        [self.tableView reloadData];
    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 1.0;
    return renderer;
}

@end
