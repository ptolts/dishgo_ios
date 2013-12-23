//
//  CartRowCell.m
//  Restaurants
//
//  Created by Philip Tolton on 11/19/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "CartRowCell.h"

@implementation CartRowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) buttonDash {
    [self dashButton:self.remove];
    [self dashButton:self.edit];
}

- (void) dashButton:(UIButton *) but {
    CGFloat kDashedBorderWidth     = (2.0f);
    CGFloat kDashedPhase           = (0.0f);
    CGFloat kDashedLinesLength[]   = {4.0f, 2.0f};
    size_t kDashedCount            = (2.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, kDashedBorderWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetLineDash(context, kDashedPhase, kDashedLinesLength, kDashedCount) ;
    CGContextAddRect(context, but.bounds);
    CGContextStrokePath(context);
    [but setNeedsDisplay];
}
@end
