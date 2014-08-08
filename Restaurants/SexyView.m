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
@synthesize progress = _progress;

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
    [self.spinna removeFromSuperview];
    [close removeFromSuperview];
    [self setProgress:1.0f];
}

- (void)setProgress:(float)progress {
    
    if( _progress != progress ){
        
        _progress = progress;
        [super performSelector:@selector(animateProgress)];
        
        if(_progress == 1.0f){
            self.spinna = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.spinna.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
            [self addSubview:self.spinna];
            [self.spinna startAnimating];
            return;
        }
        
        if( _progress > 1.0f ){
            [super performSelector:@selector(outroAnimation)];
        }
    }
}

@end
