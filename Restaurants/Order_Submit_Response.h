//
//  Order_Submit_Response.h
//  Restaurants
//
//  Created by Philip Tolton on 12/31/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface Order_Submit_Response  : JSONModel
    @property (strong, nonatomic) NSString *order_id;
@end
