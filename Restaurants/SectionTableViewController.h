//
//  SectionTableViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "CartButton.h"
#import "DBCameraViewController.h"
#import <DBCamera/DBCameraContainerViewController.h>
#import <KVOController/FBKVOController.h>

@interface SectionTableViewController : UITableViewController <DBCameraViewControllerDelegate>
    @property(nonatomic, strong) Sections *section;
    @property Restaurant *restaurant;
    @property (nonatomic, strong) RKManagedObjectStore *managedObjectStore;
    @property int current_page;
    @property (nonatomic, strong) NSMutableArray *shoppingCart;
    @property (nonatomic, strong) CartButton *cart;
    @property  FBKVOController *KVOController;
@end
