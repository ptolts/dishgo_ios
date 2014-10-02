#import "Dishes.h"
#import "Options.h"
#import "Option.h"


@implementation Dishes

//- (Dishes *) init {
//    self = [super init];
//    self.sizes = NO;
//    return self;
//}

- (NSMutableArray *) priceRange {
    NSMutableArray *range = [[NSMutableArray alloc] init];
    float high = -1;
    float low = -1;
    if(self.sizes){
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

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"has_multiple_sizes": @"sizes",
                                                       @"sizes":@"sizes_object",
                                                       @"image":@"images",
                                                       @"description":@"description_text",
                                                       @"_id":@"id",                                                       
                                                       }];
}

-(BOOL)validate:(NSError**)err
{
    for(Options *o in self.options){
        o.dish_owner = self;
        o.sizes_owner = self;
    }
    
    if(self.sizes_object){
        self.sizes_object.sizes_owner = self;
        self.sizes_object.dish_owner = self;
    }
    
    return YES;
}
@end
