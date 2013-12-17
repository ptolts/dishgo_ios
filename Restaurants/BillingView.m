//
//  BillingView.m
//  Restaurants
//
//  Created by Philip Tolton on 12/12/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "BillingView.h"
#import "UserSession.h"
#import "AddressForDeliveryViewController.h"

@implementation BillingView

@synthesize u;
@synthesize pay;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BillingView" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}


- (void) setup {

    self.street_address.text = [NSString stringWithFormat:@"%@, %@",u.street_number, u.street_address];
    self.province.text = [NSString stringWithFormat:@"%@, %@",u.city, u.province];
    self.postal_code.text = u.postal_code;
    if([u.apartment_number length] > 0) {
        self.apartment_number.text = [NSString stringWithFormat:@"Appt # %@", u.apartment_number];
    } else {
        self.apartment_number.text = @"";
    }
    self.first_name.text = [NSString stringWithFormat:@"%@ %@",u.first_name, u.last_name];

}

- (IBAction)change_billingaddress:(id)sender {
    NSLog(@"Clicked Change Billing Address");
    AddressForDeliveryViewController *vc = [pay.storyboard instantiateViewControllerWithIdentifier:@"addressViewController"];
    vc.main_user = [[UserSession sharedManager] fetchUser];
    vc.bill_user = u;
    vc.nav_title = @"Billing Address";
    [pay.navigationController pushViewController:vc animated:YES];
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
