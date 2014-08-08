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
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import <FAKFontAwesome.h>


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

    NSLog(@"%@",[[NSLocale preferredLanguages] objectAtIndex:0]);
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 5;
    
    // Optional: set Logger to VERBOSE for debug information.
//    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-48865823-2"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    BOOL tutorial = [defaults boolForKey:@"tutorial"];
    if(!tutorial){
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
    
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:@"Tutorial Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

    // PAGE 1
    
    NSString *page_1_string_part_1 = @"Rate dishes, share pictures";
    NSString *page_1_string_part_2 = @"and collect DishCoins.";
    NSString *page_1_string_part_3 = @"Redeem them for great prizes";
    
    NSString *page_1_string_part_4;
    NSString *page_1_string_part_5;

    NSString *page_1_string = [NSString stringWithFormat:@"%@\n%@\n%@",page_1_string_part_1,page_1_string_part_2,page_1_string_part_3];

    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"Browse Restaurant Menus" subTitle:page_1_string pictureName:@"page1.png" duration:5.0f];
    
    ICETutorialLabelStyle *page_1_style = [[ICETutorialLabelStyle alloc] init];
    [page_1_style setFont:[UIFont fontWithName:@"JosefinSans-Bold" size:24.0f]];
    [page_1_style setTextColor:[UIColor scarletColor]];
    [page_1_style setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
    [page_1_style setOffset:300];
    
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    
    [[ICETutorialStyle sharedInstance] setTitleStyle:page_1_style];

    ICETutorialLabelStyle *page_1_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_1_desc_style setFont:[UIFont fontWithName:@"Josefin Sans" size:20.0f]];
    [page_1_desc_style setTextColor:[UIColor whiteColor]];
    [page_1_desc_style setLinesNumber:0];
    [page_1_desc_style setOffset:260];
    
    [[ICETutorialStyle sharedInstance] setSubTitleStyle:page_1_desc_style];
    
    [layer1 setSubTitleStyle:page_1_desc_style];
    [layer1 setTitleStyle:page_1_style];
    
    // PAGE 2
    
    page_1_string_part_1 = @"Search through restaurants";
    page_1_string_part_2 = @"in your surrounding area";
    page_1_string_part_3 = @"and select one by";
    page_1_string_part_4 = @"tapping the tile.";

    page_1_string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n",page_1_string_part_1,page_1_string_part_2,page_1_string_part_3,page_1_string_part_4];
    
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"Select a restaurant" subTitle:page_1_string pictureName:@"page2.png" duration:5.0f];
    
    ICETutorialLabelStyle *page_2_style = [[ICETutorialLabelStyle alloc] init];
    [page_2_style setTextColor:[UIColor scarletColor]];
    [page_2_style setOffset:230];
    
    ICETutorialLabelStyle *page_2_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_2_desc_style setTextColor:[UIColor tutorialBrown]];
    [page_2_desc_style setOffset:200];

    [layer2 setSubTitleStyle:page_2_desc_style];
    [layer2 setTitleStyle:page_2_style];

    // PAGE 3
    
    page_1_string_part_1 = @"Get a quick overview of the";
    page_1_string_part_2 = @"restaurants details or";
    page_1_string_part_3 = @"tap a menu section.";
    
    page_1_string = [NSString stringWithFormat:@"%@\n%@\n%@\n",page_1_string_part_1,page_1_string_part_2,page_1_string_part_3];
    
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"Restaurant Storefront" subTitle:page_1_string pictureName:@"page3.png" duration:5.0f];
    
    ICETutorialLabelStyle *page_3_style = [[ICETutorialLabelStyle alloc] init];
    [page_3_style setTextColor:[UIColor scarletColor]];
    [page_3_style setOffset:230];
    
    ICETutorialLabelStyle *page_3_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_3_desc_style setTextColor:[UIColor almostBlackColor]];
    [page_3_desc_style setOffset:200];
    
    [layer3 setSubTitleStyle:page_3_desc_style];
    [layer3 setTitleStyle:page_3_style];
    

    // PAGE 4
    
    page_1_string_part_1 = @"Review the section dish by";
    page_1_string_part_2 = @"dish. Share pictures of";
    page_1_string_part_3 = @"your meal to accumulate";
    page_1_string_part_4 = @"DishCoins.";
    
    page_1_string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n",page_1_string_part_1,page_1_string_part_2,page_1_string_part_3,page_1_string_part_4];
    
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@"Browse & Upload Pics" subTitle:page_1_string pictureName:@"page4.png" duration:5.0f];
    
    ICETutorialLabelStyle *page_4_style = [[ICETutorialLabelStyle alloc] init];
    [page_4_style setTextColor:[UIColor scarletColor]];
    [page_4_style setOffset:230];
    
    ICETutorialLabelStyle *page_4_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_4_desc_style setTextColor:[UIColor almostBlackColor]];
    [page_4_desc_style setOffset:200];
    
    [layer4 setSubTitleStyle:page_4_desc_style];
    [layer4 setTitleStyle:page_4_style];
    
    // PAGE 5
    
	page_1_string_part_1 = @"Review the interactive dish";
	page_1_string_part_2 = @"including sizes and options.";
	page_1_string_part_3 = @"Submit you own rating to ";
	page_1_string_part_4 = @"collect extra DishCoins.";
    
    page_1_string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n",page_1_string_part_1,page_1_string_part_2,page_1_string_part_3,page_1_string_part_4];
    
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:@"Dish Details & Ratings" subTitle:page_1_string pictureName:@"page5.png" duration:5.0f];
    
    ICETutorialLabelStyle *page_5_style = [[ICETutorialLabelStyle alloc] init];
    [page_5_style setTextColor:[UIColor scarletColor]];
    [page_5_style setOffset:230];
    
    ICETutorialLabelStyle *page_5_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_5_desc_style setTextColor:[UIColor almostBlackColor]];
    [page_5_desc_style setOffset:200];
    
    [layer5 setSubTitleStyle:page_5_desc_style];
    [layer5 setTitleStyle:page_5_style];
    
    
    // Load into an array.
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5];
    

    ICETutorialController *tutorial_controller = [[ICETutorialController alloc] initWithPages:tutorialLayers delegate:self];
    
    UILabel *rightButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,130,36)];
    UIButton *rightButton = tutorial_controller.rightButton;
    rightButtonLabel.textAlignment = NSTextAlignmentCenter;
    rightButtonLabel.backgroundColor = [UIColor clearColor];
    rightButtonLabel.textColor = [UIColor whiteColor];
    
    
    NSMutableAttributedString *arrow_string = [[NSMutableAttributedString alloc] initWithString:@"Start  "];
    [arrow_string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"JosefinSans-Bold" size:24.0f] range:NSMakeRange(0,6)];
    FAKFontAwesome *arrow = [FAKFontAwesome caretRightIconWithSize:22.0f];
    [arrow addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [arrow_string appendAttributedString:[arrow attributedString]];
    [rightButtonLabel setAttributedText:arrow_string];
    [rightButton addSubview:rightButtonLabel];
    [rightButton bringSubviewToFront:rightButtonLabel];
    
    tutorial_controller.leftButton.hidden = true;
    
    self.window.rootViewController = tutorial_controller;

    // Run it.
//    [tutorial_controller startScrolling];
    
    return;
    
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
    NSLog(@"Button 1 pressed.");
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"tutorial"];
    [defaults synchronize];
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
