//
//  Option_Order.h
//  Restaurants
//
//  Created by Philip Tolton on 12/20/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol Option_Order

@end

@interface Option_Order : JSONModel
    @property (strong, nonatomic) NSString* name;
    @property BOOL selected;
    @property (strong, nonatomic) NSString* ident;
@end
