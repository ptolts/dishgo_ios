//
//  Hours.m
//  DishGo
//
//  Created by Philip Tolton on 2014-06-10.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "Hours.h"

@implementation Hours
- (void)encodeWithCoder:(NSCoder *) coder
{
    [coder encodeObject:self.monday forKey:@"monday"];
    [coder encodeObject:self.tuesday forKey:@"tuesday"];
    [coder encodeObject:self.wednesday forKey:@"wednesday"];
    [coder encodeObject:self.thursday forKey:@"thursday"];
    [coder encodeObject:self.friday forKey:@"friday"];
    [coder encodeObject:self.saturday forKey:@"saturday"];
    [coder encodeObject:self.sunday forKey:@"sunday"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    // Init first.
    if(self = [self init]){
        self.monday = [decoder decodeObjectForKey:@"monday"];
        self.tuesday = [decoder decodeObjectForKey:@"tuesday"];
        self.wednesday = [decoder decodeObjectForKey:@"wednesday"];
        self.thursday = [decoder decodeObjectForKey:@"thursday"];
        self.friday = [decoder decodeObjectForKey:@"friday"];
        self.saturday = [decoder decodeObjectForKey:@"saturday"];
        self.sunday = [decoder decodeObjectForKey:@"sunday"];
    }
    
    return self;
}

@end
