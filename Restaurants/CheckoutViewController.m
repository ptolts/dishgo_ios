//
//  CheckoutViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 11/21/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "CheckoutViewController.h"
#import "PKView.h"

@interface CheckoutViewController ()

@end

@implementation CheckoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scanCard addTarget:self action:@selector(scanCardMethod:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) scanCardMethod: sender{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"4827b4c8bc7646e08c699c9bd2ebde76"; // get your app token from the card.io website
    [self presentModalViewController:scanViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissModalViewControllerAnimated:YES];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    STPCard *card = [[STPCard alloc] init];
    card.number = info.cardNumber;
    card.expMonth = info.expiryMonth;
    card.expYear = info.expiryYear;

    
    STPCompletionBlock completionHandler = ^(STPToken *token, NSError *error)
    {
        if (error) {
            NSLog(@"Error trying to create token %@", [error
                                                       localizedDescription]);
        } else {
            NSLog(@"Token created with ID: %@", token.tokenId);
        }
    };
    
    [Stripe createTokenWithCard:card
                 publishableKey:@"pk_test_cfUGIxN4SeoRDJaeyHNOxblH"
                     completion:completionHandler];
    
    [scanViewController dismissModalViewControllerAnimated:YES];
}

@end
