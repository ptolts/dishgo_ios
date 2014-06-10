#import "_Restaurant.h"
#import "Hours.h"

@interface Restaurant : _Restaurant {}
    - (NSMutableDictionary *) dishDictionary;
    -(Hours *) gHours;
    -(BOOL) opened;
    @property BOOL isOpened;
    - (NSMutableArray *) dishList;
@end
