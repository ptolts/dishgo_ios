//
//  User.h
//  Restaurants
//
//  Created by Philip Tolton on 11/28/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
    @property (nonatomic, copy) NSString *facebook_token;
    @property (nonatomic, copy) NSString *facebook_id;
    @property (nonatomic, copy) NSString *facebook_name;
    @property (nonatomic, copy) NSString *foodcloud_token;
    @property (nonatomic, copy) NSString *email;
    @property (nonatomic, copy) NSString *password;
@end
