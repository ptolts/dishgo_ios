//
//  Order_Status.h
//  Restaurants
//
//  Created by Philip Tolton on 12/31/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>


@protocol Order_Status

@end

@interface Order_Status : JSONModel
    @property (strong, nonatomic) NSString<Optional> *order_id;
    @property (strong, nonatomic) NSString<Optional> *foodcloud_token;
    @property int confirmed;
@end
