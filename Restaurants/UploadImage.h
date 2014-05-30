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
    @property (nonatomic, copy) NSString *dishgo_token;
    @property (nonatomic, copy) NSString *image_data;
    @property (nonatomic, copy) NSData<Ignore> *raw_image_data;
    @property float progress;
    @property (nonatomic, copy) NSString *dish_id;
    @property (nonatomic, copy) NSString *restaurant_id;
    -(void) startUpload;
    -(void) startUploadAfn;
@end
