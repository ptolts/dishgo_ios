//
//  CheckoutView.m
//  Restaurants
//
//  Created by Philip Tolton on 11/13/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "CheckoutView.h"

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
