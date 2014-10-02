//
//  Option.h
//  DishGo
//
//  Created by Philip Tolton on 2014-09-08.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol Options

@end

@class Options;

@protocol SizePrices

@end

@class SizePrices;

@protocol Option

@end

@interface Option : JSONModel
    @property (strong, nonatomic) NSString *id;
    @property (strong, nonatomic) NSString *name;
    @property (strong, nonatomic) NSNumber *price;
    @property BOOL price_according_to_size;

    @property (strong, nonatomic) Options *option_owner;
    @property (strong, nonatomic) NSArray<SizePrices> *size_prices;

@end
