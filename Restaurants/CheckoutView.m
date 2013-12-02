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
        [self.checkout.layer setCornerRadius:5.0f];
        self.total_cost.font = [UIFont fontWithName:@"6809 Chargen" size:18.0f];
        self.total_label.font = [UIFont fontWithName:@"6809 Chargen" size:18.0f];
        self.seperator.backgroundColor = [UIColor textColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
