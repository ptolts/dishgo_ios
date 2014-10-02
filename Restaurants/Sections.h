//
//  Sectuibs.h
//  DishGo
//
//  Created by Philip Tolton on 2014-09-08.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "JSONModel.h"
#import "Dishes.h"

@class Restaurant;

@protocol Sections

@end

@interface Sections : JSONModel
    @property (strong, nonatomic) Restaurant *restaurant;
    @property (strong, nonatomic) NSString *id;
    @property (strong, nonatomic) NSString *name;
    @property (strong, nonatomic) NSNumber *position;
    @property (strong, nonatomic) NSArray<Dishes> *dishes;
@end
