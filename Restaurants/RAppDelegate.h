//
//  RAppDelegate.h
//  Restaurants
//
//  Created by Philip Tolton on 2013-10-08.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ICETutorialController.h>

@interface RAppDelegate : UIResponder <UIApplicationDelegate>

    @property (strong, nonatomic) UIWindow *window;

    @property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
    @property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
    @property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
    @property NSMutableDictionary *cart_save;

    - (void)saveContext;
    - (void) saveCart;
    - (NSURL *)applicationDocumentsDirectory;

@end
