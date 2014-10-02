//
//  JSONValueTransformer+Hours.h
//  DishGo
//
//  Created by Philip Tolton on 2014-09-09.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "JSONValueTransformer.h"
#import "Hours.h"
@interface JSONValueTransformer (Hours)
- (id)HoursFromNSString:(NSString*)string;
- (id)JSONObjectFromHours:(Hours*)hours;
@end


