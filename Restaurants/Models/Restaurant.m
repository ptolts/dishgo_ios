#import "Restaurant.h"
#import "Sections.h"
#import "Dishes.h"
//#import "Subsections.h"


@interface Restaurant ()
// Private interface goes here.
@end


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

@end
