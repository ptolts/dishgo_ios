//
//  JSONValueTransformer+Hours.m
//  DishGo
//
//  Created by Philip Tolton on 2014-09-09.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "JSONValueTransformer+Hours.h"

@implementation JSONValueTransformer (Hours)

- (id)JSONObjectFromHours:(Hours *) hours {
    return [hours toJSONString];
}
- (id)HoursFromNSString:(NSString*) string {
    return [[Hours alloc] initWithString:string error:nil];
}

@end

