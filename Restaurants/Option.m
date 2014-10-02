//
//  Restaurant.m
//  DishGo
//
//  Created by Philip Tolton on 2014-09-08.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Option.h"

@implementation Option

    +(BOOL)propertyIsOptional:(NSString*)propertyName
    {
        return YES;
    }

    +(JSONKeyMapper*)keyMapper
    {
        return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                           @"_id":@"id", 
                                                           }];
    }

@end
