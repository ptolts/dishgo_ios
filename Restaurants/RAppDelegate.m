//
//  RAppDelegate.m
//  Restaurants
//
//  Created by Philip Tolton on 2013-10-08.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "RAppDelegate.h"
#import "RootViewController.h"
#import "RestaurantViewController.h"
#import "UserSession.h"
#import "CancelKeyboard.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <ICETutorialPage.h>
#import <ICETutorialController.h>


@implementation RAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize cart_save;
BOOL attemptingFacebookLogin;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    attemptingFacebookLogin = YES;
    return [FBSession.activeSession handleOpenURL:url];
}

- (CancelKeyboard *)window
{
    static CancelKeyboard *customWindow = nil;
    if (!customWindow) customWindow = [[CancelKeyboard alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    return customWindow;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 5;
    
    // Optional: set Logger to VERBOSE for debug information.
//    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-48865823-2"];

    BOOL tutorial = YES;
    if(tutorial){
        [self tutorial];
    } else {
        [self normal];
    }
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    return YES;
}

- (void) normal {
    [self loadCart];
    [UserSession sharedManager];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    REFrostedViewController *rootViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = rootViewController;
}

- (void) tutorial {

    NSString *page_1_string_part_1 = @"With DishGo you can browse menus,";
    NSString *page_1_string_part_2 = @"rate dishes, share pictures and collect";
    NSString *page_1_string_part_3 = @"rewards.\n";
    NSString *page_1_string_part_4 = @"Every DishCoin earned gives";
    NSString *page_1_string_part_5 = @"you access to great prizes.";

    NSString *page_1_string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n",page_1_string_part_1,page_1_string_part_2,page_1_string_part_3,page_1_string_part_4,page_1_string_part_5];

    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"Restaurant Menus, on demand" subTitle:page_1_string pictureName:@"page1.png" duration:3.0f];
    
    ICETutorialLabelStyle *page_1_style = [[ICETutorialLabelStyle alloc] init];
    [page_1_style setFont:[UIFont fontWithName:@"Josefin Sans" size:18.0f]];
    [page_1_style setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [page_1_style setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
//    [page_1_style setOffset:280];

    ICETutorialLabelStyle *page_1_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_1_desc_style setFont:[UIFont fontWithName:@"Josefin Sans" size:18.0f]];
    [page_1_desc_style setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [page_1_desc_style setLinesNumber:6];
//    [page_1_desc_style setOffset:200];
    
    [layer1 setSubTitleStyle:page_1_style];
    [layer1 setTitleStyle:page_1_desc_style];
    
    page_1_string_part_1 = @"Search through restaurants";
    page_1_string_part_2 = @"in your surrounding area";
    page_1_string_part_3 = @"and select one by";
    page_1_string_part_4 = @"tapping the tile.";

    page_1_string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n",page_1_string_part_1,page_1_string_part_2,page_1_string_part_3,page_1_string_part_4];
    
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"Select a restaurant" subTitle:page_1_string pictureName:@"page2.png" duration:3.0f];
    
    
    ICETutorialLabelStyle *page_2_style = [[ICETutorialLabelStyle alloc] init];
    [page_2_style setFont:[UIFont fontWithName:@"Josefin Sans" size:18.0f]];
    [page_2_style setTextColor:[UIColor scarletColor]];
    [page_2_style setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
//    [page_2_style setOffset:280];
    
    ICETutorialLabelStyle *page_2_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_2_desc_style setFont:[UIFont fontWithName:@"Josefin Sans" size:18.0f]];
    [page_2_desc_style setTextColor:[UIColor almostBlackColor]];
    [page_2_desc_style setLinesNumber:6];
//    [page_2_desc_style setOffset:200];

    [layer2 setSubTitleStyle:page_2_style];
    [layer2 setTitleStyle:page_2_desc_style];

    // Load into an array.
    NSArray *tutorialLayers = @[layer1,layer2];
    

    ICETutorialController *tutorial_controller = [[ICETutorialController alloc] initWithPages:tutorialLayers delegate:self];
    
    // Set the common styles, and start scrolling (auto scroll, and looping enabled by default)
//        [tutorial_controller setCommonPageSubTitleStyle:subStyle];
//        [tutorial_controller setCommonPageDescriptionStyle:descStyle];

    // Set button 1 action.
//    [tutorial_controller setButton1Block:^(UIButton *button){
//        NSLog(@"Button 1 pressed.");
//    }];
    
    // Set button 2 action, stop the scrolling.
//    __unsafe_unretained typeof(RAppDelegate) *weakSelf = self;
//    [tutorial_controller setButton2Block:^(UIButton *button){
//        [weakSelf normal];
//    }];

    
    self.window.rootViewController = tutorial_controller;

    // Run it.
    [tutorial_controller startScrolling];
    
    return;
    
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
    NSLog(@"Button 1 pressed.");
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    [self normal];
}

- (void) saveCart {
    [[NSUserDefaults standardUserDefaults] setObject:cart_save forKey:@"cart_save"];
    NSLog(@"SAVING USER DEFAULTS");
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) loadCart {
    NSMutableDictionary *retrieved_dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"cart_save"];
    if (retrieved_dict == nil) {
        retrieved_dict = [[NSMutableDictionary alloc] init];
    }
    cart_save = [retrieved_dict mutableCopy];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if(!attemptingFacebookLogin){
        [[NSNotificationCenter defaultCenter]   postNotificationName:@"attemptingFacebookLogin"
                                                object:self];
    }
    attemptingFacebookLogin = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveCart];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DishGo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Restaurants.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
