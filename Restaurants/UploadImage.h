//
//  UploadImage.h
//  DishGo
//
//  Created by Philip Tolton on 2014-05-21.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import <KVOController/FBKVOController.h>
#import "SectionDishViewCell.h"
#import "SexyView.h"

@interface UploadImage : JSONModel
    @property (nonatomic, copy) NSString *dishgo_token;
    @property (nonatomic, copy) NSString *image_data;
    @property (nonatomic, copy) NSData<Ignore> *raw_image_data;
    @property Dishes<Ignore> *dish;
    @property (nonatomic, copy) NSString *dish_id;
    @property (nonatomic, copy) NSString *restaurant_id;
    -(void) startUpload;
    -(void) startUploadAfn;
    @property (strong, nonatomic) id<Ignore> lastObject;
    @property (copy, nonatomic) NSString<Ignore> *lastKeyPath;
    @property SectionDishViewCell<Ignore> *section_dish_view;
    @property SexyView<Ignore> *progress_view;
    @property UITableViewController<Ignore> *uitableview;
    @property (copy, nonatomic) NSDictionary<Ignore> *lastChange;
@end
