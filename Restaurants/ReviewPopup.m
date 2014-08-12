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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.review_text.text isEqualToString:NSLocalizedString(@"Type your review here!",nil)]) {
        self.review_text.text = @"";
        self.review_text.textColor = [UIColor almostBlackColor]; //optional
    }
    [self.review_text becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.review_text.text isEqualToString:@""]) {
        self.review_text.text = NSLocalizedString(@"Type your review here!",nil);
        self.review_text.textColor = [UIColor lightGrayColor]; //optional
    }
    [self.review_text resignFirstResponder];
}

- (void) setup {
    self.review_text.layer.cornerRadius = 3.0f;
    self.review_text.layer.borderWidth = 1.0f;
    self.review_text.layer.shadowColor = [UIColor almostBlackColor].CGColor;
    self.review_text.layer.masksToBounds = NO;
    self.review_text.tintColor = [UIColor scarletColor];
    self.review_text.text = NSLocalizedString(@"Type your review here!",nil);
    self.review_text.textColor = [UIColor lightGrayColor];
    self.review_text.delegate = self;
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
