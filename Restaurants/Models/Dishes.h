#import "_Dishes.h"

@class RestaurantOld;

@interface Dishes : _Dishes {}
    // Custom logic goes here.
    @property RestaurantOld *restaurant;
    - (NSMutableArray *) priceRange;
@end
