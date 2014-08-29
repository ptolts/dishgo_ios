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
#import "TutorialViewController.h"


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
    if([[url scheme] isEqualToString:@"dishgo"]){
        NSString *query = [url query]; // replace this with [url query];
        NSArray *components = [query componentsSeparatedByString:@"&"];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        for (NSString *component in components) {
            NSArray *subcomponents = [component componentsSeparatedByString:@"="];
            [parameters setObject:[[subcomponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                           forKey:[[subcomponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        [[UserSession sharedManager] loadUserFromToken:[parameters objectForKey:@"dishgo_token"]];
        return YES;
    } else {
        attemptingFacebookLogin = YES;
        return [FBSession.activeSession handleOpenURL:url];
    }
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
    
    [UserSession sharedManager];

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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    REFrostedViewController *rootViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = rootViewController;
}

- (void) tutorial {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normal) name:@"HideTutorial" object:nil];
    TutorialViewController *tutorial_view_controller = [TutorialViewController setup];
    self.window.rootViewController = tutorial_view_controller;
    return;
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
