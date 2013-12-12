//
//  BillingView.m
//  Restaurants
//
//  Created by Philip Tolton on 12/12/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "BillingView.h"

@implementation BillingView

@synthesize u;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setup {
    self.street_number.text = u.street_number;
    self.street_address.text = u.street_address;
    self.city.text = u.city;
    self.postal_code.text = u.postal_code;
    self.province.text = u.province;
    self.apartment_number.text = u.apartment_number;
    //        self.first_name.text = u.first_name;
    //        self.last_name.text = u.last_name;
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
