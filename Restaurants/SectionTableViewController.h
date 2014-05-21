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


@interface SectionTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
    @property(nonatomic, strong) Sections *section;
    @property Restaurant *restaurant;
    @property (nonatomic, strong) RKManagedObjectStore *managedObjectStore;
    @property int current_page;
    @property (nonatomic, strong) NSMutableArray *shoppingCart;
    @property (nonatomic, strong) CartButton *cart;
@end
