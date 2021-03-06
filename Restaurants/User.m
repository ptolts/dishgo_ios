//
//  User.m
//  Restaurants
//
//  Created by Philip Tolton on 11/28/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "User.h"

@implementation User
- (NSString *) get_full_name {
    return [NSString stringWithFormat:@"%@ %@",self.first_name, self.last_name];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
