//
//  JSONValueTransformer+Days.m
//  DishGo
//
//  Created by Philip Tolton on 2014-09-09.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "JSONValueTransformer+Days.h"

@implementation JSONValueTransformer (Days)
    - (id)JSONObjectFromDays:(Days *) days {
        return [days toJSONString];
    }
    - (id)DaysFromNSString:(NSString*) string {
        return [[Days alloc] initWithString:string error:nil];
    }
@end
