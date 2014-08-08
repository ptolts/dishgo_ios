//
//  Hours.h
//  DishGo
//
//  Created by Philip Tolton on 2014-06-10.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Days.h"

@interface Hours : NSObject
    @property (strong) Days *monday;
    @property (strong) Days *tuesday;
    @property (strong) Days *wednesday;
    @property (strong) Days *thursday;
    @property (strong) Days *friday;
    @property (strong) Days *saturday;
    @property (strong) Days *sunday;
    @property (strong) NSString *name;
@end