//
//  SectionDishViewCell.h
//  Restaurants
//
//  Created by Philip Tolton on 11/19/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraButton.h"

@interface SectionDishViewCell : UITableViewCell
    @property (nonatomic, strong) IBOutlet UILabel *dishTitle;
    @property (nonatomic, strong) IBOutlet UILabel *dishDescription;
    @property (strong, nonatomic) IBOutlet UIImageView *dishImage;
    @property (strong, nonatomic) IBOutlet UIView *seperator2;
    @property (nonatomic, nonatomic) IBOutlet UILabel *priceLabel;
    @property (nonatomic, nonatomic) IBOutlet UIView *seperator;
    @property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
    @property (strong, nonatomic) IBOutlet CameraButton *camera_view;
    @property (strong, nonatomic) IBOutlet UILabel *camera;
    @property (strong, nonatomic) IBOutlet UIProgressView *progress;
    @property (strong, nonatomic) IBOutlet UILabel *plus;
    @property (nonatomic, strong) Dishes *dish;
    @property int full_height;
    -(NSString *) getPrice;
    -(NSString *) getPriceFast;
    @property (strong, nonatomic) IBOutlet UILabel *rating_label;
    -(void) setPrice;
@end
