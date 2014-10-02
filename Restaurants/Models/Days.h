//
//  Days.h
//  DishGo
//
//  Created by Philip Tolton on 2014-06-10.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface Days : JSONModel
    @property (strong) NSString *day;
    @property (strong) NSString *opens_1;
    @property (strong) NSString *closes_1;
    @property BOOL closed;
    - (BOOL) opened;
    - (NSString *) toString;
@end
