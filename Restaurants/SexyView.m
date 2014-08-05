//
//  SexyView.m
//  DishGo
//
//  Created by Philip Tolton on 2014-08-01.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "SexyView.h"
#import <FAKFontAwesome.h>

@implementation SexyView

@synthesize close;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)show {
    [super show];
    close = [[UILabel alloc] initWithFrame:CGRectMake(240,125,60,60)];
    [close setUserInteractionEnabled:YES];
    FAKFontAwesome *closeIcon = [FAKFontAwesome timesCircleIconWithSize:50.0f];
    [closeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor almostBlackColor]];
    UITapGestureRecognizer *stop_upload = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stop_upload)];
    close.attributedText = [closeIcon attributedString];
    [close addGestureRecognizer:stop_upload];
    [self addSubview:close];
    [self bringSubviewToFront:close];
}

- (void) stop_upload {
    [close removeFromSuperview];
    [super setProgress:1.0f];
}

@end
