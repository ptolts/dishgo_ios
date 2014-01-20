//
//  CheckoutView.m
//  Restaurants
//
//  Created by Philip Tolton on 11/13/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "CheckoutView.h"
#import "UIColor+Custom.h"

@implementation CheckoutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CheckoutView" owner:self options:nil] objectAtIndex:0];
        [self.checkout.layer setCornerRadius:2.0f];
//        self.total_cost.font = [UIFont fontWithName:@"6809 Chargen" size:18.0f];
//        self.total_label.font = [UIFont fontWithName:@"6809 Chargen" size:18.0f];
//        self.tax_amount.font = [UIFont fontWithName:@"6809 Chargen" size:14.0f];
//        self.tax_label.font = [UIFont fontWithName:@"6809 Chargen" size:14.0f];
        self.total_cost.font = [UIFont fontWithName:@"Copperplate-Bold" size:18.0f];
        self.total_label.font = [UIFont fontWithName:@"Copperplate-Bold" size:18.0f];
        self.tax_amount.font = [UIFont fontWithName:@"Copperplate-Bold" size:14.0f];
        self.tax_label.font = [UIFont fontWithName:@"Copperplate-Bold" size:14.0f];
    }
    return self;
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor almostBlackColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, self.seperator.frame.origin.x, self.seperator.frame.origin.y);
    CGContextAddLineToPoint(context, self.seperator.frame.origin.x + self.seperator.frame.size.width, self.seperator.frame.origin.y);
    CGFloat lengths[2];
    lengths[0] = 2;
    lengths[1] = 2;
    CGContextSetLineDash(context, 0.0f, lengths, 2);
    CGContextStrokePath(context);
    self.seperator.backgroundColor = [UIColor clearColor];
}


@end
