//
//  Options.h
//  DishGo
//
//  Created by Philip Tolton on 2014-09-08.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "JSONModel.h"
#import "Option.h"

@protocol Dishes

@end

@class Dishes;

@protocol Options

@end

@interface Options : JSONModel
    @property BOOL advanced;
    @property (strong, nonatomic) NSString *id;
    @property (strong, nonatomic) NSString *name;
    @property (strong, nonatomic) NSString *type;
    @property (strong, nonatomic) NSNumber *max_selections;
    @property (strong, nonatomic) NSNumber *min_selections;
    @property (strong, nonatomic) Dishes *dish_owner;
    @property (strong, nonatomic) NSArray<Option> *list;
    @property (strong, nonatomic) Dishes *sizes_owner;
@end
