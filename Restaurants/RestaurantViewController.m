//
//  RestaurantViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 2013-10-08.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "RestaurantViewController.h"
#import "Restaurant.h"
#import "RAppDelegate.h"
#import "Images.h"
#import <RestKit/RestKit.h>
#import "RestaurantCells.h"
#import "noRestaurants.h"
#import "ImagesInScroll.h"
#import "RootViewController.h"
#import "StorefrontTableViewController.h"
#import "MenuTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RestaurantViewController ()

@end

@implementation RestaurantViewController {
    NSArray *restaurantList;
    CLLocationManager *locationManager;
    RKManagedObjectStore *managedObjectStore;
    NSMutableArray *cellList;
    NSTimer *scroll_timer;
    UIView *spinnerView;
    noRestaurants *noRestoView;
    UIWindow  *mainWindow;
    CLLocation *currentLocation;
    int scroll_count;
    UILabel *progress;
    UIButton *retryFetch;
    int location_attempts;
    UIActivityIndicatorView *spinner;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"HI");
    CLLocation *newLocation = [locations lastObject];
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0){
        NSLog(@"Skipping location because its most likely cached.");
        return;
    }
    
    NSLog(@"new: %f accuracy desired: %f obtained: %f",newLocation.coordinate.latitude,locationManager.desiredAccuracy,newLocation.horizontalAccuracy);
    
    if (newLocation.horizontalAccuracy > 500) {
        return;
    }
    
    NSLog(@"Done Location");
    
    currentLocation = newLocation;
    
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
    
    
    [self fetchRestaurants];
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"HI");
//    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
//    if (locationAge > 5.0){
//        NSLog(@"Skipping location because its most likely cached.");
//        return;
//    }
//    
//    NSLog(@"new: %f old: %f accuracy desired: %f obtained: %f",newLocation.coordinate.latitude,oldLocation.coordinate.latitude,locationManager.desiredAccuracy,newLocation.horizontalAccuracy);
//    
//    if (newLocation.horizontalAccuracy > locationManager.desiredAccuracy) {
//        return;
//    }
//    
//    NSLog(@"Done Location");
//    
//    currentLocation = newLocation;
//    
//    [locationManager stopMonitoringSignificantLocationChanges];
//    [locationManager stopUpdatingLocation];
//    
//    
//    [self fetchRestaurants];
//}


- (void) viewDidDisappear:(BOOL)animated {
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
}

- (void)menuClick:sender
{
    self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping = NO;
//    [((MenuTableViewController *)(self.frostedViewController.menuViewController)) setupMenu];
    [self.frostedViewController presentMenuViewController];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) startLoading {
    // Get main window reference
    mainWindow = (((RAppDelegate *)[UIApplication sharedApplication].delegate).window);
    
    // Create a full-screen subview
    spinnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWindow.frame.size.width, mainWindow.frame.size.height)];
    
    // Set up some properties of the subview
    spinnerView.backgroundColor = [UIColor whiteColor];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((mainWindow.frame.size.width/2.0) - 75, (mainWindow.frame.size.height/2.0) - 75, 150, 150)];
    [logo setContentMode:UIViewContentModeCenter];
    logo.image = [UIImage imageNamed:@"loading.png"];
    
    [spinnerView addSubview:logo];
    // Add the subview to the main window
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setColor:[UIColor almostBlackColor]];
    spinner.frame = CGRectMake((mainWindow.frame.size.width/2.0) - 12, logo.frame.origin.y + 160, 24, 24);
    [spinnerView addSubview:spinner];
    
    progress = [[UILabel alloc] init];
    [progress setText: @"FINDING LOCATION"];
    [progress setFont:[UIFont fontWithName:@"Copperplate-Bold" size:12.0f]];
    progress.textAlignment = NSTextAlignmentCenter;
    [progress setTextColor:[UIColor blackColor]];
    CGRect rect = progress.frame;
    rect.origin.y = logo.frame.origin.y + 210;
    rect.size.width = mainWindow.frame.size.width;
    rect.size.height = 30;
    progress.frame = rect;
    [spinnerView addSubview:progress];
    
    retryFetch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [retryFetch addTarget:self
               action:@selector(restartFetch:)
     forControlEvents:UIControlEventTouchUpInside];
    [retryFetch setTitle:@"RETRY" forState:UIControlStateNormal];
    [retryFetch.titleLabel setFont:[UIFont fontWithName:@"Copperplate-Bold" size:12.0f]];
    [retryFetch.titleLabel setTintColor:[UIColor whiteColor]];
    retryFetch.frame = CGRectMake((mainWindow.frame.size.width / 2) - 110, logo.frame.origin.y + 240, 220.0 , 30.0);
    retryFetch.backgroundColor = [UIColor blackColor];
    [retryFetch setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [retryFetch setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [retryFetch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    retryFetch.hidden = YES;
    [spinnerView addSubview:retryFetch];
    
    [spinner startAnimating];
    [mainWindow addSubview:spinnerView];
}

- (void) restartFetch:(id) sender {
    [UIView animateWithDuration:1.0
                     animations:^{
                         retryFetch.alpha = 1.0f;
                         retryFetch.alpha = 0.0f;
                         retryFetch.hidden = YES;
                         spinner.alpha = 1.0;
                         spinner.hidden = NO;
                     }];
    [self fetchRestaurants];
}

- (void) noRestaurants {
    // Get main window reference
    mainWindow = (((RAppDelegate *)[UIApplication sharedApplication].delegate).window);
    
    noRestoView = [[[NSBundle mainBundle] loadNibNamed:@"noRestaurants" owner:self options:nil] objectAtIndex:0];
    [noRestoView.demo addTarget:self action:@selector(launchDemo:) forControlEvents:UIControlEventTouchUpInside];
    [noRestoView.viewSite addTarget:self action:@selector(launchSite:) forControlEvents:UIControlEventTouchUpInside];
    [mainWindow addSubview:noRestoView];
}

-(void) launchSite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://dishgo.io"]];
}

-(void) launchDemo:(id)sender {
    double your_latitiude_value = 45.455448;
    double your_longitude_value = -74.144368;
    currentLocation = [[CLLocation alloc] initWithLatitude:your_latitiude_value longitude:your_longitude_value];
    [noRestoView removeFromSuperview];
    [self startLoading];
    [self fetchRestaurants];
}

- (void) stopLoading{
    [UIView animateWithDuration:1.0
                     animations:^{spinnerView.alpha = 0.0;}
                     completion:^(BOOL finished){
                        [spinnerView removeFromSuperview];
                        [self scrollEachCell];
                     }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    location_attempts = 0;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy: 1];
    locationManager.pausesLocationUpdatesAutomatically = NO;
    [locationManager startUpdatingLocation];
    scroll_count = 0;
    [self startLoading];
    cellList = [[NSMutableArray alloc] init];
    [self startScrolling];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor = [UIColor scarletColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    // FOOD CLOUD TITLE
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Copperplate-Bold" size:20.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"DishGo";
    self.navigationItem.titleView = label;
    
    [self.menu addTarget:self action:@selector(menuClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];

}

- (void) fetchRestaurants {
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         progress.alpha = 0.0f;
                         progress.text = @"FETCHING RESTAURANTS";
                         progress.alpha = 1.0f;
                     }];

    self.managedObjectContext = [(RAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSError *error;

    self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    ////////// QUERY NEW DATA AND UPDATE TABLE.
    
    NSManagedObjectModel *managedObjectModel = [(RAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectModel];
    
    managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    error = nil;
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (! success) {
        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Restaurants.sqlite"];
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:path withConfiguration:nil options:nil error:&error];
    if (! persistentStore) {
        RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
    }
    [managedObjectStore createManagedObjectContexts];
    
    ///// MAPPINGS
    RKEntityMapping *imagesMapping = [RKEntityMapping mappingForEntityForName:@"Images" inManagedObjectStore:managedObjectStore];
    [imagesMapping addAttributeMappingsFromDictionary:@{
                                                        @"local_file": @"url",
                                                        }];
    imagesMapping.identificationAttributes = @[ @"url" ];
    
    RKEntityMapping *restaurantMapping = [RKEntityMapping mappingForEntityForName:@"Restaurant" inManagedObjectStore:managedObjectStore];
    [restaurantMapping addAttributeMappingsFromDictionary:@{
                                                            @"_id": @"id",
                                                            @"name": @"name",
                                                            @"phone": @"phone",
                                                            @"address": @"address_line_1",
                                                            @"lat": @"lat",
                                                            @"lon": @"lon",
                                                            }];
    
    
    restaurantMapping.identificationAttributes = @[ @"id" ];
    
    [restaurantMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"image" toKeyPath:@"images" withMapping:imagesMapping]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:restaurantMapping method:RKRequestMethodAny pathPattern:@"/app/api/v1/restaurants" keyPath:nil statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://dishgo.io/app/api/v1/restaurants?lat=%f&lon=%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude]]];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.132:3000/app/api/v1/restaurants?lat=%f&lon=%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude]]];
    
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    operation.managedObjectCache = managedObjectStore.managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        
        NSLog(@"Total Restaurants: %d",[result.array count]);
        restaurantList = [result.array sortedArrayUsingComparator:^NSComparisonResult(Restaurant *obj1, Restaurant *obj2)
                          {
                              return [obj2.images count] - [obj1.images count];
                          }];
        
        NSLog(@"Attempting save...\n\n\n");
        
        [self.tableView reloadData];
        [self stopLoading];
        if([restaurantList count] == 0){
            [self noRestaurants];
        }
    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
        [UIView animateWithDuration:1.5
                         animations:^{
                             retryFetch.alpha = 0.0f;
                             spinner.alpha = 1.0f;
                             retryFetch.hidden = NO;
                             retryFetch.alpha = 1.0f;
                             spinner.alpha = 0.0f;
                             spinner.hidden = YES;
                             progress.alpha = 0.0f;
                             progress.text = @"NETWORK ERROR";
                             progress.alpha = 1.0f;
                         }];
    }];
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    if ([controller isKindOfClass:[StorefrontTableViewController class]]) {
        StorefrontTableViewController *vc = (StorefrontTableViewController *)controller;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"RESTAURANT ID: %@",[[restaurantList objectAtIndex:indexPath.row] objectID]);
        vc.restaurant = [restaurantList objectAtIndex:indexPath.row];
        vc.managedObjectStore = managedObjectStore;
        
    } else {
        NSAssert(NO, @"Unknown segue. All segues must be handled.");
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return restaurantList.count;
}
- (void) startScrolling {
    scroll_timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                    target:self
                                                  selector:@selector(scrollEachCell)
                                                  userInfo:Nil
                                                   repeats:YES];
    [scroll_timer fire];
}

- (void) scrollEachCell {
    
    if(scroll_count > 3){
        [scroll_timer invalidate];
        scroll_timer = nil;
        return;
    }
    
    int i = 0;
    for(RestaurantCells *c in cellList){
        i++;
        [c.scrollView scrollPages:i];
    }
    
    scroll_count++;
}

- (void) killScroll {
    [scroll_timer invalidate];
    scroll_timer = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RestaurantCells";
    
    RestaurantCells *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    RestaurantCells *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[RestaurantCells alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } else {
//        [cell.scrollView killScroll];
        [cellList removeObject:cell];
        for (UIView *aView in [NSArray arrayWithArray:cell.scrollView.subviews]) {
            [aView removeFromSuperview];
        }
    }
    
    // Configure the cell...
    
    // Set up the cell...
    Restaurant *resto = [restaurantList objectAtIndex:indexPath.row];
    
    
    int i = 0;
    for (Images *img in resto.images) {
        CGRect frame;
        frame.origin.x = cell.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = cell.scrollView.frame.size;
        
        ImagesInScroll *imageView = [[ImagesInScroll alloc] initWithFrame:frame];
        imageView.userInteractionEnabled = YES;
        
        __weak typeof(imageView) weakImage = imageView;
        [imageView          setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",img.url]]
                            placeholderImage:[UIImage imageNamed:@"Default.png"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                              if (image && cacheType == SDImageCacheTypeNone)
                                              {
                                                  weakImage.alpha = 0.0;
                                                  [UIView animateWithDuration:1.0
                                                                   animations:^{
                                                                       weakImage.alpha = 1.0;
                                                                   }];
                                              }
                                          }];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.scrollView addSubview:imageView];
        i++;
    }
    
    cell.scrollView.contentSize = CGSizeMake(cell.scrollView.frame.size.width * [resto.images count], cell.scrollView.frame.size.height);
    cell.scrollView.pagingEnabled = YES;
    
    cell.scrollView.numberOfPages = [resto.images count];
    
    cell.restaurantLabel.text = resto.name;
    cell.restaurantLabel.font = [UIFont fontWithName:@"Copperplate-Bold" size:20.0f];
    [cellList addObject:cell];
    cell.scrollView.currentPage = 1;
    return cell;
}


@end
