#import "Dishes.h"
#import "Options.h"
#import "Option.h"

@class RestaurantOld;

@interface Dishes ()

// Private interface goes here.

@end


@implementation Dishes

- (NSMutableArray *) priceRange {
    NSMutableArray *range = [[NSMutableArray alloc] init];
    float high = -1;
    float low = -1;
    if([self.sizes intValue] == 1){
        for(Option *s in self.sizes_object.list){
            float p = [s.price floatValue];
            if(high == -1){
                high = p;
            }
            if(low == -1){
                low = p;
            }
            if(p < low){
                low = p;
            }
            if(p > high){
                high = p;
            }
        }
    } else {
        high = [self.price floatValue];
        low = [self.price floatValue];
    }
    [range insertObject:[NSNumber numberWithFloat:low] atIndex:0];
    [range insertObject:[NSNumber numberWithFloat:high] atIndex:1];
    return range;
}

@end
