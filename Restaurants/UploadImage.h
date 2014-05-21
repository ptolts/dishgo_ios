//
//  UploadImage.h
//  DishGo
//
//  Created by Philip Tolton on 2014-05-21.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface UploadImage : JSONModel
    @property (nonatomic, copy) NSString *facebook_token;
    @property (nonatomic, copy) NSString *image;
    @property (nonatomic, copy) NSString *dish_id;
@end
