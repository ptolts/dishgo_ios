//
//  JSONValueTransformer+Days.h
//  DishGo
//
//  Created by Philip Tolton on 2014-09-09.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "JSONValueTransformer.h"
#import "Days.h"

@interface JSONValueTransformer (Days)
    - (id)DaysFromNSString:(NSString*)string;
    - (id)JSONObjectFromDays:(Days*)days;
@end
