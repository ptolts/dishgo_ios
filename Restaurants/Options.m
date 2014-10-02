//
//  Restaurant.m
//  DishGo
//
//  Created by Philip Tolton on 2014-09-08.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Options.h"

@implementation Options

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"individual_options":@"list",
                                                       @"_id":@"id",                                                        
                                                       }];
}

-(BOOL)validate:(NSError**)err
{
    for(Option *o in self.list){
        o.option_owner = self;
    }
    return YES;
}

@end
