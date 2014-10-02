//
//  SizePrices.h
//  DishGo
//
//  Created by Philip Tolton on 2014-09-08.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "JSONModel.h"
#import "Option.h"

@protocol SizePrices

@end

@interface SizePrices : JSONModel
    @property (strong, nonatomic) NSString *id;
    @property (strong, nonatomic) NSString *related_to_size;
    @property (strong, nonatomic) NSNumber *price;
    @property (strong, nonatomic) Option *sizes_prices;
    @property (strong, nonatomic) Option *size_option;
@end
