//
//  Days.m
//  DishGo
//
//  Created by Philip Tolton on 2014-06-10.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "Days.h"

@implementation Days
- (void)encodeWithCoder:(NSCoder *) coder
{
    [coder encodeObject:self.opens_1 forKey:@"open_1"];
    [coder encodeObject:self.closes_1 forKey:@"close_1"];
    [coder encodeObject:self.day forKey: @"day"];
    [coder encodeBool:self.closed forKey: @"closed"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    // Init first.
    if(self = [self init]){
        self.day = [decoder decodeObjectForKey:@"day"];
        self.opens_1 = [decoder decodeObjectForKey:@"open_1"];
        self.closes_1 = [decoder decodeObjectForKey:@"close_1"];
        self.closed = [decoder decodeBoolForKey:@"closed"];
    }
    
    return self;
}

- (BOOL) opened {
    
    if(self.closed){
        return false;
    }
    
    if(self.opens_1 == NULL || self.closes_1 == NULL){
        return false;
    }
    
    NSString *start = [NSString stringWithFormat:@"2012-06-01:%@:00",self.opens_1];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd:HH:mm:ss"];
    NSDate *start_time = [dateFormatter dateFromString:start];
    
    NSString *end = [NSString stringWithFormat:@"2012-06-01:%@:00",self.closes_1];
    NSDate *end_time = [dateFormatter dateFromString:end];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSString *now = [NSString stringWithFormat:@"2012-06-01:%ld:%ld:00",(long)hour,(long)minute];
    NSDate *now_time = [dateFormatter dateFromString:now];
    
    int now_int = [now_time timeIntervalSince1970];
    int start_int = [start_time timeIntervalSince1970];
    int end_int = [end_time timeIntervalSince1970];
    
    if(start_int > end_int){
        NSDate *midnight = [dateFormatter dateFromString:@"2012-06-01:23:59:00"];
        int midnight_int = [midnight timeIntervalSince1970];
        NSDate *one_second_after_midnight = [dateFormatter dateFromString:@"2012-06-01:00:01:00"];
        int one_second_after_midnight_int = [one_second_after_midnight timeIntervalSince1970];
        if((now_int > start_int && now_int < midnight_int) || (now_int > one_second_after_midnight_int && now_int < end_int)) {
            return true;
        }
        else {
            return false;
        }
    } else {
        if( (start_int < now_int ) && (now_int < end_int )) {
            return true;
        }
        else {
            return false;
        }
    }
    
}

- (NSString *) toString {
    if(self.closed){
        return @"Closed";
    }
    NSString *day_of_week = self.day;
    day_of_week = [day_of_week stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[day_of_week substringToIndex:1] uppercaseString]];
    if([day_of_week isEqualToString:@"Friday"]){
        day_of_week = @"Friday  ";
    }
    NSString *opens = [NSString stringWithFormat:@"%@",self.opens_1];
    NSString *closes = [NSString stringWithFormat:@"%@", self.closes_1];
    return [NSString stringWithFormat:@"%@:\t %@ - %@",day_of_week,opens,closes];
}
@end
