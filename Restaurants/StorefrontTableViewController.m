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
#import "REFrostedViewController.h"
#import "MenuTableViewController.h"
#import "DishScrollView.h"
#import "DishTableViewCell.h"
#import "UIColor+Custom.h"

#define DEFAULT_SIZE 148
#define HEADER_DEFAULT_SIZE 44

@interface StorefrontTableViewController ()
@end

@implementation StorefrontTableViewController
    NSMutableArray *sectionsList;
    NSMutableArray *shoppingCart;
    NSMutableArray *cellList;
    NSArray *fetchedRestaurants;
    int current_page = 0;
    NSSet *defaultSectionsList;
    // io Card pin: 4827b4c8bc7646e08c699c9bd2ebde76
    CLLocationManager *locationManager;
    MKMapView *mapView;
    UIView *spinnerView;
    UIWindow  *mainWindow;


- (void) viewDidDisappear:(BOOL)animated {
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
    [mapView setDelegate:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) startLoading {
    self.cart.button.enabled = NO;
    int junk = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    mainWindow = (((RAppDelegate *)[UIApplication sharedApplication].delegate).window);
    spinnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWindow.frame.size.width, mainWindow.frame.size.height - junk)];
    spinnerView.backgroundColor = [UIColor whiteColor];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((mainWindow.frame.size.width/2.0) - 75, ((mainWindow.frame.size.height - junk)/2.0) - 95, 150, 150)];
    [logo setContentMode:UIViewContentModeCenter];
    logo.image = [UIImage imageNamed:@"loading.png"];
    [spinnerView addSubview:logo];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setColor:[UIColor almostBlackColor]];
    spinner.frame = CGRectMake((mainWindow.frame.size.width/2.0) - 12, logo.frame.origin.y + 160, 24, 24);
    [spinnerView addSubview:spinner];
    [spinner startAnimating];
    
    [self.view addSubview:spinnerView];
}

- (void) stopLoading{
    [UIView animateWithDuration:0.5
                     animations:^{spinnerView.alpha = 0.0;}
                     completion:^(BOOL finished){
                         [spinnerView removeFromSuperview];
                     }];
    // THIS ADD STUFF TO THE CART FOR TESTING.
    bool kill = NO;
    for(Sections *sec in sectionsList){
        for(Subsections *subsec in sec.subsections){
            for(Dishes *d in subsec.dishes){
                DishTableViewCell *dish_logic = [[[NSBundle mainBundle] loadNibNamed:@"DishTableViewCell" owner:self options:nil] objectAtIndex:0];
                dish_logic.dish = d;
                dish_logic.dishTitle.text = d.name;
                dish_logic.parent = self;
                dish_logic.priceLabel.backgroundColor = [UIColor bgColor];
                [dish_logic setupLowerHalf];
                [dish_logic setupShoppingCart];
                [shoppingCart addObject:dish_logic];
                if([shoppingCart count] > 5){
                    kill = YES;
                    break;
                }
            }
            if (kill)
                break;
        }
        if (kill)
            break;
    }
    self.cart.button.enabled = YES;
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

-(void) viewDidAppear:(BOOL)animated {
    if([shoppingCart count] != 0){
        int tots = 0;
        for(DishTableViewCell *d in shoppingCart){
            tots += (int) d.dishFooterView.stepper.value;
        }
        [self.cart setCount:[NSString stringWithFormat:@"%d", tots]];
    } else {
        [self.cart setCount:@"0"];
    }
}

-(void) myCustomBack {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) setupBackButtonAndCart {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]; // <-- Use your own image
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
    [backBtn setImage:backBtnImage];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = -16;// it was -6 in iOS 6
//    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, backBtn, nil] animated:NO];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    //	self.navigationItem.leftBarButtonItem = backBtn;
    
    shoppingCart = [[NSMutableArray alloc] init];
    CartButton *cartButton = [[CartButton alloc] init];
    [cartButton.button addTarget:self action:@selector(cartClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:cartButton.button];
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, customItem, nil] animated:NO];
    [self.navigationItem setRightBarButtonItem:customItem];
    //    self.navigationItem.rightBarButtonItem = customItem;
    self.cart = cartButton;
    [self.cart setCount:[NSString stringWithFormat:@"%d", [shoppingCart count]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLoading];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.autoresizingMask = UIViewAutoresizingNone;
    
    [self setupBackButtonAndCart];
    
    // FOOD CLOUD TITLE
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Freestyle Script Bold" size:30.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = self.restaurant.name;
    self.navigationItem.titleView = label;
    
    Header *header = [[[NSBundle mainBundle] loadNibNamed:@"Header" owner:self options:nil] objectAtIndex:0];
    header.label.text = self.restaurant.name;
//    header.label.font = [UIFont fontWithName:@"Freestyle Script Bold" size:40.0f];
    header.scroll_view.restaurant = self.restaurant;
    [header.scroll_view setupImages];
    header.autoresizingMask = UIViewAutoresizingNone;
    header.scroll_view.autoresizingMask = UIViewAutoresizingNone;
    self.tableView.tableHeaderView = header;
    
    Footer *footer = [[[NSBundle mainBundle] loadNibNamed:@"Footer" owner:self options:nil] objectAtIndex:0];
    
    footer.phone.text = self.restaurant.phone;
    footer.address.text = self.restaurant.address;
    footer.contact_title.font = [UIFont fontWithName:@"Freestyle Script Bold" size:30.0f];
    footer.backgroundColor = [UIColor bgColor];
    for (UIView * txt in footer.subviews){
        if ([txt isKindOfClass:[UILabel class]] && [txt isFirstResponder]) {
            ((UILabel *)txt).textColor = [UIColor textColor];
        }
    }
    mapView = footer.mapView;
    self.tableView.tableFooterView = footer;
    
    self.tableView.backgroundColor = [UIColor bgColor];
    
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

- (void)cartClick:sender
{
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping = YES;
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping_cart = shoppingCart;
    [((MenuTableViewController *)(self.frostedViewController.menuViewController)) setupMenu];
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    [self.frostedViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if([sectionsList count] == 0){
        return 0;
    }
    return HEADER_DEFAULT_SIZE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return DEFAULT_SIZE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([sectionsList count] == 0){
        return 1;
    }
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

- (void) buildCells {
    cellList = [[NSMutableArray alloc] init];
    for(Sections *section in sectionsList){
        DishViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DishViewCell" owner:self options:nil] objectAtIndex:0];
        [cell setRestorationIdentifier:@"DishViewCell"];
        cell.dishScrollView.section = section;
        [cell.dishScrollView setupViews];
        cell.backgroundColor = [UIColor bgColor];
        [cellList addObject:cell];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"DishViewCell";
//
//    DishViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    // Configure the cell...
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"DishViewCell" owner:self options:nil] objectAtIndex:0];
//    } else {
//        for (UIView *aView in [NSArray arrayWithArray:cell.dishScrollView.subviews]) {
//            [aView removeFromSuperview];
//        }
//    }
//    
//
//    cell.dishScrollView.section = [sectionsList objectAtIndex:indexPath.section];
////    [cell.dishScrollView setupViews:indexPath];
//    cell.backgroundColor = [UIColor bgColor];
    
//    return cell;

    return [cellList objectAtIndex:indexPath.section];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    
    if([sectionsList count] == 0){
        return nil;
    }
    
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
//    NSLog(@"FONT FAMILIES\n%@",[UIFont familyNames]);
    
    TableHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] objectAtIndex:0];
    view.headerTitle.text = section.name;
    view.headerTitle.font = [UIFont fontWithName:@"Freestyle Script Bold" size:30.0f];
    view.headerTitle.textColor = [UIColor textColor];
    view.backgroundColor = [UIColor bgColor];
    for (UIView * txt in view.subviews){
        if ([txt isKindOfClass:[UILabel class]] && [txt isFirstResponder]) {
            ((UILabel *)txt).textColor = [UIColor textColor];
        }
    }
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
    view.headerTitle.textColor = [UIColor textColor];    
    view.backgroundColor = [UIColor bgColor];
    for (UIView * txt in view.subviews){
        if ([txt isKindOfClass:[UILabel class]] && [txt isFirstResponder]) {
            ((UILabel *)txt).textColor = [UIColor textColor];
        }
    }
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
    sectionsList = (NSMutableArray *)[self.restaurant.menu array];
    
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
    [self buildCells];
    [self.tableView reloadData];
    
    
    ////////// QUERY NEW DATA AND UPDATE TABLE.
    
    RKManagedObjectStore *managedObjectStore = self.managedObjectStore;
    
    ///// MAPPINGS
    RKEntityMapping *dishesMapping = [RKEntityMapping mappingForEntityForName:@"Dishes" inManagedObjectStore:managedObjectStore];
    [dishesMapping addAttributeMappingsFromDictionary:@{
                                                        @"name": @"name",
                                                        @"_id": @"id",
                                                        @"price": @"price",
                                                        @"index":@"position",
                                                        @"description": @"description_text",
                                                        }];
    dishesMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *sectionsMapping = [RKEntityMapping mappingForEntityForName:@"Sections" inManagedObjectStore:managedObjectStore];
    [sectionsMapping addAttributeMappingsFromDictionary:@{
                                                          @"name": @"name",
                                                          @"_id": @"id",
                                                          @"index":@"position",
                                                          }];
    sectionsMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *subsectionsMapping = [RKEntityMapping mappingForEntityForName:@"Subsections" inManagedObjectStore:managedObjectStore];
    [subsectionsMapping addAttributeMappingsFromDictionary:@{
                                                             @"name": @"name",
                                                             @"_id": @"id",
                                                             @"index":@"position",
                                                             }];
    subsectionsMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *optionMapping = [RKEntityMapping mappingForEntityForName:@"Option" inManagedObjectStore:managedObjectStore];
    [optionMapping addAttributeMappingsFromDictionary:@{
                                                        @"name": @"name",
                                                        @"price": @"price",
                                                        @"_id": @"id",
                                                        }];
    optionMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *optionsMapping = [RKEntityMapping mappingForEntityForName:@"Options" inManagedObjectStore:managedObjectStore];
    [optionsMapping addAttributeMappingsFromDictionary:@{
                                                         @"name": @"name",
                                                         @"_id": @"id",
                                                         @"type": @"type",
                                                         }];
    optionsMapping.identificationAttributes = @[ @"id" ];

    
    
    [sectionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"subsection" toKeyPath:@"subsections" withMapping:subsectionsMapping]];
    [subsectionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dish" toKeyPath:@"dishes" withMapping:dishesMapping]];
    [dishesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"options" toKeyPath:@"options" withMapping:optionsMapping]];
    [optionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"individual_option" toKeyPath:@"list" withMapping:optionMapping]];
    
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
        self.restaurant.menu = [NSOrderedSet orderedSetWithArray:[result array]];

        NSError *error;
        NSLog(@"SAVING MENU OF SIZE %lu",(unsigned long)[[result array] count]);
        if (![[self.restaurant managedObjectContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        } else {
            [self buildCells];
            [self.tableView reloadData];
        }
        
        [self stopLoading];
        
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
