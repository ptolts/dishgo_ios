//
//  ReviewPopup.m
//  DishGo
//
//  Created by Philip Tolton on 2014-08-07.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "ReviewPopup.h"

@implementation ReviewPopup

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ReviewPopup" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ReviewPopup" owner:self options:nil] objectAtIndex:0];
    if (self) {

    }
    return self;
}

- (IBAction)submit:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"submitReview" object:nil];
}

- (void) setup {
    self.review_text.layer.cornerRadius = 3.0f;
    self.review_text.layer.borderWidth = 1.0f;
    self.review_text.layer.shadowColor = [UIColor almostBlackColor].CGColor;
    self.review_text.layer.masksToBounds = NO;
}

-(IBAction)close:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideAFPopup" object:nil];
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
