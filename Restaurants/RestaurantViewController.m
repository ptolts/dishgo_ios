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
#import "UserSession.h"
#import <JSONHTTPClient.h>

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
    UserSession *session;
    int scroll_count;
    UILabel *progress;
    UIButton *retryFetch;
    NSString *searchTxt;
    int sortBy;
    UIView *requestLocation;
    BOOL stopUpdatingLocation;
    BOOL isOpened;
    BOOL hasPrize;
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
    session.lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    session.lon = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
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
        [self.KVOController observe:self.frostedViewController.menuViewController keyPath:@"hasPrize" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(RestaurantViewController *observe, MenuTableViewController *object, NSDictionary *change) {
            hasPrize = object.hasPrize;
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
    [progress setText: NSLocalizedString(@"FINDING LOCATION",nil)];
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
    [retryFetch setTitle:NSLocalizedString(@"RETRY",nil) forState:UIControlStateNormal];
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
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex{
    return 0.1f;
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

-(BOOL) checkLocationServices {
    if([CLLocationManager locationServicesEnabled]){
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            NSLog(@"LOCATION SERVICES ARE DENIED");
            return false;
        }
    } else {
            NSLog(@"LOCATION SERVICES ARE DISABLED");
            return false;
    }
    return true;
}

- (void) requestLocationServices {
    // Get main window reference
    mainWindow = (((RAppDelegate *)[UIApplication sharedApplication].delegate).window);
    
    // Create a full-screen subview
    requestLocation = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWindow.frame.size.width, mainWindow.frame.size.height)];
    UIImageView *loc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"request_loc.png"]];
    
    [requestLocation addSubview:loc];
    UITapGestureRecognizer *close_location_services_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeLocationServices)];
    [requestLocation addGestureRecognizer:close_location_services_tap];
    [mainWindow addSubview:requestLocation];
}

-(void) closeLocationServices {
    [requestLocation removeFromSuperview];
    mainWindow = (((RAppDelegate *)[UIApplication sharedApplication].delegate).window);
    
    noRestoView = [[[NSBundle mainBundle] loadNibNamed:@"noRestaurants" owner:self options:nil] objectAtIndex:0];
    [noRestoView.demo addTarget:self action:@selector(launchDemo:) forControlEvents:UIControlEventTouchUpInside];
    [noRestoView.viewSite addTarget:self action:@selector(launchSite:) forControlEvents:UIControlEventTouchUpInside];
    noRestoView.demoLabel.text = NSLocalizedString(@"Without your location we can only offer a preview of what we have to offer.", nil);
    [mainWindow addSubview:noRestoView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"PASTEBOARD: %@",[[UIPasteboard pasteboardWithName:@"fb_app_attribution" create:NO] string]);
    session = [UserSession sharedManager];
    
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.KVOController = KVOController;
    
    location_attempts = 0;
    locationManager = [[CLLocationManager alloc] init];
    
    if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [locationManager requestWhenInUseAuthorization];
    }
 
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy: 1];
    locationManager.pausesLocationUpdatesAutomatically = NO;
    [locationManager startUpdatingLocation];
    scroll_count = 0;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        stopUpdatingLocation = NO;
        [locationManager startUpdatingLocation];
    }   withBackgroundColor:[UIColor almostBlackColor] withPullToRefreshHeightShowed:1];
    
    [self.tableView.pullToRefreshView setTextColor:[UIColor bgColor]];
    [self.tableView.pullToRefreshView setTitle:@"LOADING" forState:KoaPullToRefreshStateLoading];
    [self.tableView.pullToRefreshView setTitle:@"RELEASE" forState:KoaPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"PULL" forState:KoaPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTextFont:[UIFont fontWithName:@"Copperplate-Bold" size:16]];
    [self.tableView.pullToRefreshView setFontAwesomeIcon:@"icon-refresh"];
    
    cellList = [[NSMutableArray alloc] init];
    [self startScrolling];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor = [UIColor scarletColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    
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
    
    if(![self checkLocationServices]){
        [self requestLocationServices];
        return;
    }
    
    [self startLoading];

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
    
    if(hasPrize){
        NSPredicate *testForTrue = [NSPredicate predicateWithFormat:@"hasPrize == 1"];
        filteredRestaurantList = [filteredRestaurantList filteredArrayUsingPredicate:testForTrue];
    }
    
    [self.tableView reloadData];
}

- (void) fetchRestaurants {
    
    NSLog(@"FETCHING RESTAURANTS");
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         progress.alpha = 0.0f;
                         progress.text = NSLocalizedString(@"FETCHING RESTAURANTS",nil);
                         progress.alpha = 1.0f;
                     }];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/app/api/v1/restaurants?lat=%f&lon=%f",dishGoUrl,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
    NSLog(@"%@",url);
    
    NSURL *ns_url = [NSURL URLWithString:url];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:ns_url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            NSLog(@"Failed with error: %@", [error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [UIView animateWithDuration:1.5
                                                animations:^{
                                                    retryFetch.alpha = 0.0f;
                                                    spinner.alpha = 1.0f;
                                                    retryFetch.hidden = NO;
                                                    retryFetch.alpha = 1.0f;
                                                    spinner.alpha = 0.0f;
                                                    spinner.hidden = YES;
                                                    progress.alpha = 0.0f;
                                                    progress.text = NSLocalizedString(@"NETWORK ERROR",nil);
                                                    progress.alpha = 1.0f;
                                                }];
                           });
            return;
        }
        
        NSError *err;
        NSArray *result = [Restaurant arrayOfModelsFromData:data error:&err];
        NSArray *new_restaurantList = [result sortedArrayUsingComparator:^NSComparisonResult(Restaurant *obj1, Restaurant *obj2)
                                       {
                                           return [obj2.images count] - [obj1.images count];
                                       }];
        
        for(Restaurant *r in new_restaurantList){
            CLLocation *itemLoc = [[CLLocation alloc] initWithLatitude:[r.lat doubleValue]
                                                             longitude:[r.lon doubleValue]];
            CLLocationDistance itemDistance = [itemLoc distanceFromLocation:currentLocation];
            r.distance = [NSNumber numberWithDouble:itemDistance];
            [r setup_prizes];
            [r opened];
        }
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{    //back on main thread
                           restaurantList = new_restaurantList;
                           filteredRestaurantList = restaurantList;
                           [self filterRestaurants];
                           NSLog(@"RELOADING DATA.");
                           [self.tableView reloadData];
                           [self stopLoading];
                           if([restaurantList count] == 0){
                               [self noRestaurants];
                           }
                       });

    }] resume];
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
        cell.opened_closed.text = NSLocalizedString(@"Open",nil);
        cell.opened_closed.textColor = [UIColor greenColor];
    } else {
        cell.opened_closed.text = NSLocalizedString(@"Closed",nil);
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
