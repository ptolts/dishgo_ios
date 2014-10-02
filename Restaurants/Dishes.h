//
//  Dishes.h
//  DishGo
//
//  Created by Philip Tolton on 2014-09-08.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "JSONModel.h"
#import "Options.h"
#import "Sections.h"

@protocol Images

@end

@class Images;

@protocol Dishes

@end

@interface Dishes : JSONModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description_text;
@property (strong, nonatomic) NSNumber *position;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSNumber *rating_count;
@property BOOL sizes;

@property (strong, nonatomic) NSArray<Images> *images;
@property (strong, nonatomic) NSArray<Options> *options;
@property (strong, nonatomic) Options *sizes_object;
@property (strong, nonatomic) Sections *section;
- (NSMutableArray *) priceRange;
@end
