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


@interface StorefrontTableViewController ()
@end

@implementation StorefrontTableViewController
    NSArray *sectionsList;
    // io Card pin: 4827b4c8bc7646e08c699c9bd2ebde76
    CLLocationManager *locationManager;
    MKMapView *mapView;

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
    
    Header *header = [[[NSBundle mainBundle] loadNibNamed:@"Header" owner:self options:nil] objectAtIndex:0];
    header.label.text = self.restaurant.name;
    header.scroll_view.restaurant = self.restaurant;
    [header.scroll_view setupImages];
    self.tableView.tableHeaderView = header;
    
    Footer *footer = [[[NSBundle mainBundle] loadNibNamed:@"Footer" owner:self options:nil] objectAtIndex:0];
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
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionsList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Rows in section %d: %d",section,[[[sectionsList objectAtIndex:section] subsections] count]);
    return [[[sectionsList objectAtIndex:section] subsections] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } else {
        
    }
    
    // Configure the cell...
    
    // Set up the cell...
    Subsections *subsection = [[[sectionsList objectAtIndex:indexPath.section] subsections].allObjects objectAtIndex:indexPath.row];
    NSLog(@"Cell Label: %@ at %d in section %d",subsection.name,indexPath.row,indexPath.section);
    cell.textLabel.text = subsection.name;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    Sections *section = [sectionsList objectAtIndex:sectionIndex];
    label.text = section.name;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void) loadMenu {
    
    NSManagedObjectContext *context = [(RAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sections"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedRestaurants = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Fetched: %d\n\n\n", [fetchedRestaurants count]);
    sectionsList = fetchedRestaurants;
    [self.tableView reloadData];
    
    
    ////////// QUERY NEW DATA AND UPDATE TABLE.
    
    
//    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
//    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
//    error = nil;
//    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
//    if (! success) {
//        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
//    }
//    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Restaurants.sqlite"];
//    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
//    if (! persistentStore) {
//        RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
//    }
//    [managedObjectStore createManagedObjectContexts];
    RKManagedObjectStore *managedObjectStore = self.managedObjectStore;
    
    ///// MAPPINGS
    RKEntityMapping *dishesMapping = [RKEntityMapping mappingForEntityForName:@"Dishes" inManagedObjectStore:managedObjectStore];
    [dishesMapping addAttributeMappingsFromDictionary:@{
                                                        @"name": @"name",
                                                        @"id": @"id",
                                                        }];
    dishesMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *sectionsMapping = [RKEntityMapping mappingForEntityForName:@"Sections" inManagedObjectStore:managedObjectStore];
    [sectionsMapping addAttributeMappingsFromDictionary:@{
                                                          @"name": @"name",
                                                          @"id": @"id",
                                                          }];
    sectionsMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *subsectionsMapping = [RKEntityMapping mappingForEntityForName:@"Subsections" inManagedObjectStore:managedObjectStore];
    [subsectionsMapping addAttributeMappingsFromDictionary:@{
                                                             @"name": @"name",
                                                             @"id": @"id",
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
    [optionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"list" toKeyPath:@"options" withMapping:optionMapping]];
    
    NSString *query = [NSString stringWithFormat:@"/api/v1/restaurants/menu"]; //?id=%@",self.restaurant.id];
    NSString *url = [NSString stringWithFormat:@"http://dev.foodcloud.ca:3000/api/v1/restaurants/menu?id=%@",self.restaurant.id];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:sectionsMapping method:RKRequestMethodAny pathPattern:query keyPath:nil statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    operation.managedObjectCache = managedObjectStore.managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        
        NSLog(@"Total Sections: %d",[result.array count]);
        sectionsList = result.array;
        for(Sections *res in sectionsList){
           NSLog(@"Name: %@",res.name);
       }
        
        NSLog(@"Attempting save...\n\n\n");
        NSError *err;
//        if (![context save:&err]) {
//            NSLog(@"Whoops, couldn't save: %@", [err localizedDescription]);
//        }
        
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
