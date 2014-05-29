//
//  UploadImage.m
//  DishGo
//
//  Created by Philip Tolton on 2014-05-21.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "UploadImage.h"
#import <JSONHTTPClient.h>
@implementation UploadImage
    -(void) startUpload {
        [JSONHTTPClient postJSONFromURLWithString:@"http://192.168.1.132:3000/app/api/v1/restaurant_admin/upload_image"
                                           params:[self toDictionary]
                                       completion:^(id json, JSONModelError *err) {
                                           
                                           
                                       }];
    }
@end
