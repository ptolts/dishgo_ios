//
//  Restaurant.h
//  DishGo
//
//  Created by Philip Tolton on 2014-09-08.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "JSONModel.h"
#import "JSONValueTransformer+Hours.h"
#import "Hours.h"
#import "Images.h"
#import "Sections.h"

@protocol Restaurant

@end

@interface Restaurant : JSONModel
    @property (strong, nonatomic) NSString *address;
    @property (strong, nonatomic) NSString *city;
    @property (strong, nonatomic) NSString *id;
    @property (strong, nonatomic) NSString *name;
    @property (strong, nonatomic) NSString *phone;
    @property (strong, nonatomic) NSString *postal_code;
    @property (strong, nonatomic) NSNumber *prizes;
    @property (strong, nonatomic) NSNumber *distance;
    @property (strong, nonatomic) NSNumber *lat;
    @property (strong, nonatomic) NSNumber *lon;
    @property BOOL does_delivery;
    @property (strong, nonatomic) Hours *hours;
    @property (strong, nonatomic) NSArray<Sections> *menu;
    @property (strong, nonatomic) NSArray<Images> *images;

    - (NSMutableDictionary *) dishDictionary;
    -(Hours *) gHours;
    -(BOOL) opened;
    -(BOOL) setup_prizes;
    @property BOOL isOpened;
    @property BOOL hasPrize;
    - (NSMutableArray *) dishList;
    - (NSMutableArray *) allDishes;
@end
