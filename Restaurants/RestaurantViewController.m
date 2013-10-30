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

@interface RestaurantViewController ()

@end

@implementation RestaurantViewController {
    NSArray *restaurantList;
    RKManagedObjectStore *managedObjectStore;
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
    [self.frostedViewController presentMenuViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.menu addTarget:self action:@selector(menuClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Test listing all FailedBankInfos from the store
    NSManagedObjectContext *context = [(RAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Restaurant"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedRestaurants = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Fetched: %d\n\n\n", [fetchedRestaurants count]);
    restaurantList = fetchedRestaurants;
    [self.tableView reloadData];
    
    
    ////////// QUERY NEW DATA AND UPDATE TABLE.
    

    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    error = nil;
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (! success) {
        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Restaurants.sqlite"];
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if (! persistentStore) {
        RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
    }
    [managedObjectStore createManagedObjectContexts];
    
    ///// MAPPINGS
    RKEntityMapping *imagesMapping = [RKEntityMapping mappingForEntityForName:@"Images" inManagedObjectStore:managedObjectStore];
    [imagesMapping addAttributeMappingsFromDictionary:@{
                                                        @"url": @"url",
                                                        }];
    imagesMapping.identificationAttributes = @[ @"url" ];
    
    RKEntityMapping *restaurantMapping = [RKEntityMapping mappingForEntityForName:@"Restaurant" inManagedObjectStore:managedObjectStore];
    [restaurantMapping addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"lat": @"lat",
                                                          @"lon": @"lon",
                                                        }];
    
    restaurantMapping.identificationAttributes = @[ @"id" ];

    [restaurantMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"images" toKeyPath:@"images" withMapping:imagesMapping]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:restaurantMapping method:RKRequestMethodAny pathPattern:@"/api/v1/restaurants" keyPath:nil statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.foodcloud.ca:3000/api/v1/restaurants"]];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    operation.managedObjectCache = managedObjectStore.managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        
        NSLog(@"Total Restaurants: %d",[result.array count]);
        restaurantList = result.array;
//        for(Restaurant *res in restaurantList){
//            NSLog(@"Id: %@",res.objectID);
//            for(Images *img in res.images){
//                NSLog(@"\tImage: %@",img.url);
//            }
//        }
        
        NSLog(@"Attempting save...\n\n\n");
        NSError *err;
        if (![context save:&err]) {
            NSLog(@"Whoops, couldn't save: %@", [err localizedDescription]);
        }
        
        [self.tableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RestaurantCells";
    
//    RestaurantCells *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    RestaurantCells *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[RestaurantCells alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } else {
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
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://dev.foodcloud.ca:3000/assets/sources/%@",img.url]]
                  placeholderImage:[UIImage imageNamed:@"Default.png"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.scrollView addSubview:imageView];
        i++;
    }
    
    cell.scrollView.contentSize = CGSizeMake(cell.scrollView.frame.size.width * [resto.images count], cell.scrollView.frame.size.height);
    cell.scrollView.pagingEnabled = YES;
    cell.restaurantLabel.text = resto.name;
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
