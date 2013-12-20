//
//  Options_Order.h
//  Restaurants
//
//  Created by Philip Tolton on 12/20/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Option_Order.h"

@protocol Options_Order

@end

@interface Options_Order : JSONModel
    @property (strong, nonatomic) NSString* ident;
    @property (strong, nonatomic) NSString* name;
    @property (strong, nonatomic) NSArray<Option_Order> *options;
@end
