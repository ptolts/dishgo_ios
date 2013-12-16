//
//  PaymentTableViewCell.m
//  Restaurants
//
//  Created by Philip Tolton on 12/12/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "PaymentTableViewCell.h"
#import "PKView.h"
#import <PKTextField.h>

@implementation PaymentTableViewCell

@synthesize controller;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self killKeyboard];
}

-(IBAction)dissmissKeyboard:(id)sender{
    [sender resignFirstResponder];
}

- (void) setup
{
    [self.scan_card addTarget:self action:@selector(scanCardMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.paymentView.delegate = self;
    
    [self killKeyboard];
    
    BillingView *bill_view = [[BillingView alloc] init];
    bill_view.u = _bill_user;
    bill_view.frame = self.b_view.frame;
    [self.b_view removeFromSuperview];
    self.b_view = bill_view;
    [self addSubview:bill_view];
    self.b_view = bill_view;
    bill_view.pay = controller;
    [bill_view setup];
}

-(void) killKeyboard {
    for (UIView * txt in self.paymentView.innerView.subviews){
        if ([txt respondsToSelector:@selector(resignFirstResponder)]) {
            [txt resignFirstResponder];
        }
    }
}

-(void) scanCardMethod: sender{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"4827b4c8bc7646e08c699c9bd2ebde76"; // get your app token from the card.io website
    if ([controller respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [controller presentViewController:scanViewController animated:YES completion:nil];
    } else {
        [controller presentModalViewController:scanViewController animated:YES];
    }
    //    [self presentModalViewController:scanViewController animated:YES];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissModalViewControllerAnimated:YES];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    
    self.paymentView.cardNumberField.text = [[PKCardNumber cardNumberWithString:info.cardNumber] formattedString];
    //    [self.paymentView performSelector:@selector(stateCardNumber)];
    //    [self.paymentView performSelector:@selector(stateMeta)];
    NSString *year = [NSString stringWithFormat:@"@%d",info.expiryYear];
    self.paymentView.cardExpiryField.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)info.expiryMonth,[year substringFromIndex:year.length-2]];
    self.paymentView.cardCVCField.text = info.cvv;
    [self.paymentView performSelector:@selector(stateMeta)];
    
    [self killKeyboard];
    //    STPCard *card = [[STPCard alloc] init];
    //    card.number = info.cardNumber;
    //    card.expMonth = info.expiryMonth;
    //    card.expYear = info.expiryYear;
    //
    //
    //    STPCompletionBlock completionHandler = ^(STPToken *token, NSError *error)
    //    {
    //        if (error) {
    //            NSLog(@"Error trying to create token %@", [error
    //                                                       localizedDescription]);
    //        } else {
    //            NSLog(@"Token created with ID: %@", token.tokenId);
    //        }
    //    };
    //
    //    [Stripe createTokenWithCard:card
    //                 publishableKey:@"pk_test_cfUGIxN4SeoRDJaeyHNOxblH"
    //                     completion:completionHandler];
    
    [scanViewController dismissModalViewControllerAnimated:YES];
}


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

@end
