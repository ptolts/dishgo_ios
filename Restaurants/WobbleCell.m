//
//  WobbleCell.m
//  Restaurants
//
//  Created by Philip Tolton on 12/19/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "WobbleCell.h"
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@implementation WobbleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) wobble {
    CGFloat degrees = 8.0;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 0.6;
    animation.cumulative = YES;
    animation.repeatCount = 1;
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat: 0.0],
                        [NSNumber numberWithFloat: RADIANS(-degrees) * 0.25],
                        [NSNumber numberWithFloat: 0.0],
                        [NSNumber numberWithFloat: RADIANS(degrees) * 0.5],
                        [NSNumber numberWithFloat: 0.0],
                        [NSNumber numberWithFloat: RADIANS(-degrees)],
                        [NSNumber numberWithFloat: 0.0],
                        [NSNumber numberWithFloat: RADIANS(degrees)],
                        [NSNumber numberWithFloat: 0.0],
                        [NSNumber numberWithFloat: RADIANS(-degrees) * 0.5],
                        [NSNumber numberWithFloat: 0.0],
                        [NSNumber numberWithFloat: RADIANS(degrees) * 0.25],
                        [NSNumber numberWithFloat: 0.0], nil];
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = YES;
    
    [self.layer addAnimation:animation forKey:@"wobble"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
