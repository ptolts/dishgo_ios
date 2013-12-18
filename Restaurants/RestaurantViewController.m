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
#import "ImagesInScroll.h"
#import "RootViewController.h"
#import "StorefrontTableViewController.h"
#import "MenuTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RestaurantViewController ()

@end

@implementation RestaurantViewController {
    NSArray *restaurantList;
    RKManagedObjectStore *managedObjectStore;
    NSMutableArray *cellList;
    NSTimer *scroll_timer;
    UIView *spinnerView;
    UIWindow  *mainWindow;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)menuClick:sender
{
    self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping = NO;
    [((MenuTableViewController *)(self.frostedViewController.menuViewController)) setupMenu];
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
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setColor:[UIColor almostBlackColor]];
    spinner.frame = CGRectMake((mainWindow.frame.size.width/2.0) - 12, logo.frame.origin.y + 160, 24, 24);
    [spinnerView addSubview:spinner];
    [spinner startAnimating];
    
    
    [mainWindow addSubview:spinnerView];
}

- (void) stopLoading{
    [UIView animateWithDuration:0.5
                     animations:^{spinnerView.alpha = 0.0;}
                     completion:^(BOOL finished){ [spinnerView removeFromSuperview]; }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLoading];
    cellList = [[NSMutableArray alloc] init];
    [self startScrolling];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor = [UIColor scarletColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    // FOOD CLOUD TITLE
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Freestyle Script Bold" size:30.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"FoodCloud";
    self.navigationItem.titleView = label;
    
    [self.menu addTarget:self action:@selector(menuClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Test listing all FailedBankInfos from the store
    self.managedObjectContext = [(RAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

    NSError *error;
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Restaurant"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedRestaurants = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Fetched: %d\n\n\n", [fetchedRestaurants count]);
    restaurantList = [fetchedRestaurants sortedArrayUsingComparator:^NSComparisonResult(Restaurant *obj1, Restaurant *obj2)
    {
        return [obj2.images count] - [obj1.images count];
    }];

    [self.tableView reloadData];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    ////////// QUERY NEW DATA AND UPDATE TABLE.
    

//    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
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
                                                          @"address": @"address",
                                                          @"lat": @"lat",
                                                          @"lon": @"lon",
                                                        }];
    
    
    restaurantMapping.identificationAttributes = @[ @"id" ];

    [restaurantMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"image" toKeyPath:@"images" withMapping:imagesMapping]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:restaurantMapping method:RKRequestMethodAny pathPattern:@"/api/v1/restaurants" keyPath:nil statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.foodcloud.ca:3000/api/v1/restaurants"]];
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
        NSError *err;
        if (![self.managedObjectContext save:&err]) {
            NSLog(@"Whoops, couldn't save: %@", [err localizedDescription]);
        }
        
        [self.tableView reloadData];
        [self stopLoading];
    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Clicked!");
//    StorefrontViewController *storeFrontController = [[StorefrontViewController alloc] initWithNibName:@"" bundle:<#(NSBundle *)#>];
//    storeFrontController.restaurant = [restaurantList objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:storeFrontController animated:YES];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return restaurantList.count;
}

//- (void) killScroll {
//    [scroll_timer invalidate];
//    scroll_timer = nil;
//}

- (void) startScrolling {
    scroll_timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                    target:self
                                                  selector:@selector(scrollEachCell)
                                                  userInfo:Nil
                                                   repeats:YES];
    [scroll_timer fire];
}

- (void) scrollEachCell {
    for(RestaurantCells *c in cellList){
        [c.scrollView scrollPages];
    }
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
        [imageView          setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://dev.foodcloud.ca:3000/assets/sources/%@",img.url]]
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
//    [cell.scrollView scroll];
    
    cell.restaurantLabel.text = resto.name;
    cell.restaurantLabel.font = [UIFont fontWithName:@"Freestyle Script Bold" size:28.0f];
    [cellList addObject:cell];
    cell.scrollView.currentPage = 0;
    return cell;
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

@end
