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
#import "Constant.h"
#import "Hours.h"
#import "KoaPullToRefresh.h"
#import "Days.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <GAI.h>
#import "GetListedTableViewCell.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface RestaurantViewController ()

@end

@implementation RestaurantViewController {
    NSArray *restaurantList;
    NSArray *filteredRestaurantList;
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
    NSString *searchTxt;
    int sortBy;
    BOOL stopUpdatingLocation;
    BOOL isOpened;
    BOOL doesDelivery;
    BOOL setSortByObserver;
    int location_attempts;
    UIActivityIndicatorView *spinner;
    BOOL isSearching;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor scarletColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:@"Restaurant Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
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
    
    currentLocation = newLocation;
    
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
    
    if(stopUpdatingLocation){
        return;
    }
    
    NSLog(@"Done Location -- Fetching Restaurants");
    stopUpdatingLocation = YES;
    [self fetchRestaurants];
}


- (void) viewDidDisappear:(BOOL)animated {
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
}

- (void)menuClick:sender
{
    if(!setSortByObserver){
        [self.KVOController observe:self.frostedViewController.menuViewController keyPath:@"sort_by" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(RestaurantViewController *observe, MenuTableViewController *object, NSDictionary *change) {
            sortBy = [object.sort_by intValue];
            [self filterRestaurants];
        }];
        [self.KVOController observe:self.frostedViewController.menuViewController keyPath:@"isOpened" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(RestaurantViewController *observe, MenuTableViewController *object, NSDictionary *change) {
            isOpened = object.isOpened;
            [self filterRestaurants];
        }];
        [self.KVOController observe:self.frostedViewController.menuViewController keyPath:@"doesDelivery" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(RestaurantViewController *observe, MenuTableViewController *object, NSDictionary *change) {
            doesDelivery = object.doesDelivery;
            [self filterRestaurants];
        }];
        setSortByObserver = YES;
    }
    self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping = NO;
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
    spinner.frame = CGRectMake((mainWindow.frame.size.width/2.0) - 12, logo.frame.origin.y + 210, 24, 24);
    [spinnerView addSubview:spinner];
    
    progress = [[UILabel alloc] init];
    [progress setText: @"FINDING LOCATION"];
    [progress setFont:[UIFont fontWithName:@"JosefinSans-Bold" size:12.0f]];
    progress.textAlignment = NSTextAlignmentCenter;
    [progress setTextColor:[UIColor blackColor]];
    CGRect rect = progress.frame;
    rect.origin.y = logo.frame.origin.y + 160;
    rect.size.width = mainWindow.frame.size.width;
    rect.size.height = 30;
    progress.frame = rect;
    [spinnerView addSubview:progress];
    
    retryFetch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [retryFetch addTarget:self
               action:@selector(restartFetch:)
     forControlEvents:UIControlEventTouchUpInside];
    [retryFetch setTitle:@"RETRY" forState:UIControlStateNormal];
    [retryFetch.titleLabel setFont:[UIFont fontWithName:@"JosefinSans-Bold" size:12.0f]];
    [retryFetch.titleLabel setTintColor:[UIColor whiteColor]];
    retryFetch.frame = CGRectMake((mainWindow.frame.size.width / 2) - 110, logo.frame.origin.y + 240, 220.0 , 30.0);
    retryFetch.backgroundColor = [UIColor almostBlackColor];
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
    NSLog(@"Retry Fetching Restaurants");
    [self fetchRestaurants];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex{
    return 0.1;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
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

-(void) letsDishGoSite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://letsdishgo.com"]];
}

-(void) launchDemo:(id)sender {
    double your_latitiude_value = 45.455448;
    double your_longitude_value = -74.144368;
    currentLocation = [[CLLocation alloc] initWithLatitude:your_latitiude_value longitude:your_longitude_value];
    [noRestoView removeFromSuperview];
    [self startLoading];
    NSLog(@"Launching Demo - Fetch Restaurants");
    [self fetchRestaurants];
}

- (void) stopLoading{
    [UIView animateWithDuration:1.0
                     animations:^{spinnerView.alpha = 0.0;}
                     completion:^(BOOL finished){
                         if(spinnerView){
                             [spinnerView removeFromSuperview];
                         }
                        [self scrollEachCell];
                     }];
    [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"PASTEBOARD: %@",[[UIPasteboard pasteboardWithName:@"fb_app_attribution" create:NO] string]);
    
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.KVOController = KVOController;
    
    location_attempts = 0;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy: 1];
    locationManager.pausesLocationUpdatesAutomatically = NO;
    [locationManager startUpdatingLocation];
    scroll_count = 0;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        // Tasks to do on refresh. Update datasource, add rows, …
        // Call [tableView.pullToRefreshView stopAnimating] when done.
        [locationManager startUpdatingLocation];
    }   withBackgroundColor:[UIColor almostBlackColor] withPullToRefreshHeightShowed:4];
    
    [self.tableView.pullToRefreshView setTextColor:[UIColor bgColor]];
    [self.tableView.pullToRefreshView setTitle:@"LOADING" forState:KoaPullToRefreshStateLoading];
    [self.tableView.pullToRefreshView setTitle:@"RELEASE" forState:KoaPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"PULL" forState:KoaPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTextFont:[UIFont fontWithName:@"Copperplate-Bold" size:16]];
    [self.tableView.pullToRefreshView setFontAwesomeIcon:@"icon-refresh"];
    
    [self startLoading];
    cellList = [[NSMutableArray alloc] init];
    [self startScrolling];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor = [UIColor scarletColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    // FOOD CLOUD TITLE
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
//    label.backgroundColor = [UIColor clearColor];
//    [label setFont:[UIFont fontWithName:@"Copperplate-Bold" size:20.0f]];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    label.adjustsFontSizeToFitWidth = YES;
//    label.text = @"DishGo";
//    self.navigationItem.titleView = label;
    
    UISearchDisplayController *mySearchDisplayController;
    self.search_bar = mySearchDisplayController;
    self.bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 250, 0)];
    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.bar contentsController:self];
    mySearchDisplayController.delegate = self;
    mySearchDisplayController.searchResultsDataSource = self;
    mySearchDisplayController.searchResultsDelegate = self;
    self.bar.delegate = self;
    self.bar.tintColor = [UIColor scarletColor];
    [self setSearch_bar:mySearchDisplayController];
    
    UITextField *txfSearchField = [self.bar valueForKey:@"_searchField"];
//    [txfSearchField setBackgroundColor:[[UIColor scarletColor] colorWithAlphaComponent:0.95]];
    [txfSearchField setLeftView:UITextFieldViewModeNever];
    [txfSearchField setBorderStyle:UITextBorderStyleRoundedRect];
    txfSearchField.layer.borderWidth = 1.0f;
    txfSearchField.layer.cornerRadius = 5.0f;
    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;

    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.bar];
    self.navigationItem.leftBarButtonItem = searchBarItem;
    
    [self.menu addTarget:self action:@selector(menuClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText length] != 0) {
        isSearching = YES;
        searchTxt = searchText;
        [self filterRestaurants];
    }
    else {
        isSearching = NO;
        searchTxt = @"";
        [self filterRestaurants];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchTxt = @"";
    [self filterRestaurants];
    isSearching = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)filterRestaurants {
    if([searchTxt length] != 0) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchTxt];
        filteredRestaurantList = [restaurantList filteredArrayUsingPredicate:resultPredicate];
    } else {
        filteredRestaurantList = restaurantList;
    }
    
    NSSortDescriptor *sortByDistance = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDistance];
    
    switch(sortBy)
    {
        case 0:
            filteredRestaurantList = [filteredRestaurantList sortedArrayUsingDescriptors:sortDescriptors];
            break;
        case 1:
            filteredRestaurantList = [filteredRestaurantList sortedArrayUsingComparator:^NSComparisonResult(Restaurant *obj1, Restaurant *obj2)
                              {
                                  return [obj2.images count] - [obj1.images count];
                              }];
            break;
        default:
            
            break;
    }
    
    if(isOpened){
        NSPredicate *testForTrue = [NSPredicate predicateWithFormat:@"isOpened == 1"];
        filteredRestaurantList = [filteredRestaurantList filteredArrayUsingPredicate:testForTrue];
    }
    
    if(doesDelivery){
        NSPredicate *testForTrue = [NSPredicate predicateWithFormat:@"does_delivery == 1"];
        filteredRestaurantList = [filteredRestaurantList filteredArrayUsingPredicate:testForTrue];
    }
    
    [self.tableView reloadData];
}

- (void) fetchRestaurants {
    
    NSLog(@"FETCHING RESTAURANTS");
    
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
    
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];    
    
    ///// MAPPINGS
    RKEntityMapping *imagesMapping = [RKEntityMapping mappingForEntityForName:@"Images" inManagedObjectStore:managedObjectStore];
    [imagesMapping addAttributeMappingsFromDictionary:@{
                                                        @"medium": @"url",
                                                        @"id": @"id",
                                                        }];
    imagesMapping.identificationAttributes = @[ @"id" ];

//    RKLogConfigureByName("RestKit", RKLogLevelWarning);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    
    RKObjectMapping *daysMapping = [RKObjectMapping mappingForClass:[Days class]];
    
    [daysMapping addAttributeMappingsFromDictionary:@{
                                                        @"open_1": @"opens_1",
                                                        @"close_1": @"closes_1",
                                                        @"closed": @"closed",
                                                        @"name":@"day",
                                                        }];
    
    
    RKObjectMapping *hoursMapping = [RKObjectMapping mappingForClass:[Hours class]];
    [hoursMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"name"];
    
    [hoursMapping addRelationshipMappingWithSourceKeyPath:@"monday" mapping:daysMapping];
    [hoursMapping addRelationshipMappingWithSourceKeyPath:@"tuesday" mapping:daysMapping];
    [hoursMapping addRelationshipMappingWithSourceKeyPath:@"wednesday" mapping:daysMapping];
    [hoursMapping addRelationshipMappingWithSourceKeyPath:@"thursday" mapping:daysMapping];
    [hoursMapping addRelationshipMappingWithSourceKeyPath:@"friday" mapping:daysMapping];
    [hoursMapping addRelationshipMappingWithSourceKeyPath:@"saturday" mapping:daysMapping];
    [hoursMapping addRelationshipMappingWithSourceKeyPath:@"sunday" mapping:daysMapping];
    
    
    RKEntityMapping *restaurantMapping = [RKEntityMapping mappingForEntityForName:@"Restaurant" inManagedObjectStore:managedObjectStore];
    [restaurantMapping addAttributeMappingsFromDictionary:@{
                                                            @"_id": @"id",
                                                            @"name": @"name",
                                                            @"city": @"city",
                                                            @"postal_code": @"postal_code",                                                            
                                                            @"phone": @"phone",
                                                            @"is_admin":@"is_admin",
                                                            @"address_line_1": @"address",
                                                            @"does_delivery":@"does_delivery",
                                                            @"lat": @"lat",
                                                            @"lon": @"lon",
                                                            }];
    restaurantMapping.identificationAttributes = @[ @"id" ];

    
    [restaurantMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"image" toKeyPath:@"images" withMapping:imagesMapping]];
    [restaurantMapping addRelationshipMappingWithSourceKeyPath:@"hours" mapping:hoursMapping];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:restaurantMapping method:RKRequestMethodAny pathPattern:@"/app/api/v1/restaurants" keyPath:nil statusCodes:statusCodes];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/api/v1/restaurants?lat=%f&lon=%f",dishGoUrl,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude]]];
    
    [request setTimeoutInterval:15];
    
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    operation.managedObjectCache = managedObjectStore.managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        
        NSArray *new_restaurantList = [result.array sortedArrayUsingComparator:^NSComparisonResult(Restaurant *obj1, Restaurant *obj2)
                          {
                              return [obj2.images count] - [obj1.images count];
                          }];
        
        for(Restaurant *r in new_restaurantList){
            CLLocation *itemLoc = [[CLLocation alloc] initWithLatitude:[r.lat doubleValue]
                                                             longitude:[r.lon doubleValue]];
            CLLocationDistance itemDistance = [itemLoc distanceFromLocation:currentLocation];
            r.distance = [NSNumber numberWithDouble:itemDistance];
            [r opened];
        }
        restaurantList = new_restaurantList;
        filteredRestaurantList = restaurantList;
        [self filterRestaurants];
        NSLog(@"RELOADING DATA.");
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

- (void) segueToRestaurant: (Restaurant *) restaurant {
    [self performSegueWithIdentifier:@"toStoreFront" sender: restaurant];
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
    
    Restaurant *c = (Restaurant *) sender;
    
    if ([controller isKindOfClass:[StorefrontTableViewController class]]) {
        StorefrontTableViewController *vc = (StorefrontTableViewController *)controller;
        vc.restaurant = c;
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
    if(isSearching){
        return [filteredRestaurantList count] + 1;
    } else {
        return [filteredRestaurantList count];
    }
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
    
    if(scroll_count > 1){
        [scroll_timer invalidate];
        scroll_timer = nil;
        return;
    }
    
    int i = 0;
    for(RestaurantCells *c in cellList){
        i++;
        if(c.scrollView){
            [c.scrollView scrollPages:i];
        }
    }
    
    scroll_count++;
}

- (void) killScroll {
    [scroll_timer invalidate];
    scroll_timer = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(([filteredRestaurantList count] + 1) == (indexPath.row + 1)){
        static NSString *CellIdentifier = @"letsDishGoCell";
        GetListedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GetListed" owner:self options:nil] objectAtIndex:0];
        }
        [cell.letsdishgo addTarget:self action:@selector(letsDishGoSite:)];
        return cell;
    }
    
    Restaurant *resto;
    resto = [filteredRestaurantList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"RestaurantCells";
    RestaurantCells *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RestaurantCells alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } else {
        [cellList removeObject:cell];
        for (UIView *aView in [NSArray arrayWithArray:cell.scrollView.subviews]) {
            [aView removeFromSuperview];
        }
    }
    
    cell.restaurant = resto;
    
    int i = 0;
    for (Images *img in resto.images) {
        CGRect frame;
        frame.origin.x = cell.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = cell.scrollView.frame.size;
        
        ImagesInScroll *imageView = [[ImagesInScroll alloc] initWithFrame:frame];
        imageView.userInteractionEnabled = NO;
        
        __weak typeof(imageView) weakImage = imageView;
        if(i==0){
            [imageView      setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",img.url]]
                            placeholderImage:[UIImage imageNamed:@"Default.png"]
                            options:SDWebImageHighPriority
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
        } else {
            [imageView         setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",img.url]]
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
        }
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell.scrollView addSubview:imageView];
        i++;
        if(i > 6){
            break;
        }
    }
    
    cell.scrollView.contentSize = CGSizeMake(cell.scrollView.frame.size.width * i, cell.scrollView.frame.size.height);
    cell.scrollView.pagingEnabled = YES;
    cell.scrollView.numberOfPages = [resto.images count];
    cell.scrollView.restaurant = resto;
    cell.scrollView.segue_controller = self;
    cell.restaurantLabel.text = resto.name;
    cell.restaurantLabel.font = [UIFont fontWithName:@"JosefinSans-Bold" size:20.0f];
    [cellList addObject:cell];
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",([resto.distance doubleValue] / 1000)];
    cell.distanceLabel.layer.cornerRadius = 3.0;
    UIColor *b = [UIColor almostBlackColor];
    b = [b colorWithAlphaComponent:0.8];
    cell.distanceLabel.font = [UIFont fontWithName:@"JosefinSans-Bold" size:18.0f];
    cell.distanceLabel.backgroundColor = b;
    cell.distanceLabel.hidden = NO;
    
    if(resto.isOpened){
        cell.opened_closed.text = @"Open";
        cell.opened_closed.textColor = [UIColor greenColor];
    } else {
        cell.opened_closed.text = @"Closed";
        cell.opened_closed.textColor = [UIColor scarletColor];
    }
    cell.opened_closed.font = [UIFont fontWithName:@"JosefinSans-Bold" size:18.0f];
    cell.opened_closed.layer.cornerRadius = 3.0;
    cell.opened_closed.backgroundColor = b;
    cell.opened_closed.hidden = NO;
    
    cell.scrollView.currentPage = 1;
    return cell;
}


@end
