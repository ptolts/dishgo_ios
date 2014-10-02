//
//  Restaurant.m
//  DishGo
//
//  Created by Philip Tolton on 2014-09-08.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "Sections.h"
#import "Dishes.h"
#import "Hours.h"

@implementation Restaurant

@synthesize isOpened;

// Custom logic goes here.
- (NSMutableDictionary *) dishDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for(Sections *sec in self.menu){
        //        for(Subsections *subsec in sec.subsections){
        for(Dishes *d in sec.dishes){
            [dict setObject:d forKey:d.id];
        }
        //        }
    }
    return dict;
}

- (NSMutableArray *) allDishes {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for(Sections *sec in self.menu){
        for(Dishes *d in sec.dishes){
            [list addObject:d];
        }
    }
    return list;
}

- (NSMutableArray *) dishList {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    int i = 0;
    for(Sections *sec in self.menu){
        for(Dishes *d in sec.dishes){
            [list addObject:d];
            if(i > 15){
                break;
            }
        }
        if(i > 15){
            break;
        }
    }
    return list;
}

-(Hours *) gHours {
    return (Hours *) self.hours;
}

-(BOOL) opened {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday] - 1;
    NSArray *days_of_the_week = @[@"sunday",@"monday",@"tuesday",@"wednesday",@"thursday",@"friday",@"saturday"];
    Days *current_day = [self.hours valueForKey:[days_of_the_week objectAtIndex:weekday]];
    BOOL is_it_opened = [current_day opened];
    //    NSLog(@"day: %@ is %hhd",[days_of_the_week objectAtIndex:weekday], is_it_opened);
    self.isOpened = is_it_opened;
    return true;
}

- (BOOL) setup_prizes {
    if([self.prizes intValue] > 0){
        self.hasPrize = YES;
        return YES;
    }
    return NO;
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"image": @"images",
                                                       @"address_line_1": @"address",
                                                       @"_id":@"id",                                                        
                                                       }];
}

@end
