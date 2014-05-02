#import "Restaurant.h"
#import "Sections.h"
#import "Dishes.h"
//#import "Subsections.h"


@interface Restaurant ()
// Private interface goes here.
@end


@implementation Restaurant

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

@end
