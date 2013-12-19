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
#import <ALAlertBanner/ALAlertBanner.h>

#define StripeToken @"pk_test_cfUGIxN4SeoRDJaeyHNOxblH"
#define CardColor [UIColor creditCardColor]

@implementation PaymentTableViewCell

@synthesize controller;
@synthesize main_user;
@synthesize bill_user;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self killKeyboard];
}

-(IBAction)dissmissKeyboard:(id)sender{
    [sender resignFirstResponder];
}

- (void) setup
{
    [self.scan_card addTarget:self action:@selector(scanCardMethod:) forControlEvents:UIControlEventTouchUpInside];

    self.card_bg.backgroundColor = CardColor;
    [self.card_bg.layer setCornerRadius:7.0f];
    
    self.paymentView = [[PKView alloc] initWithFrame:CGRectMake(15, 25, 290, 55)];
    self.paymentView.delegate = self;
    self.paymentView.cardNumberField = self.card_field;
    self.paymentView.cardExpiryField = self.card_date;
    self.paymentView.placeholderView = self.card_image;
    self.paymentView.cardCVCField = self.card_cvv;
    
    [self.paymentView performSelector:@selector(setup)];
    
    [self.card_field setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.card_date setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.card_cvv setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.card_field.textColor = [UIColor whiteColor];
    self.card_date.textColor = [UIColor whiteColor];
    self.card_cvv.textColor = [UIColor whiteColor];
    
    [self killKeyboard];
    
    self.bg.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.75f];
    [self.bg.layer setCornerRadius:5.0f];
    
    BillingView *bill_view = [[BillingView alloc] init];
    bill_view.u = bill_user;
    bill_view.frame = self.b_view.frame;
    [self.b_view removeFromSuperview];
    self.b_view = bill_view;
    [self.bg addSubview:bill_view];
    self.b_view = bill_view;
    bill_view.pay = controller;
    [bill_view setup];
    
    self.b_view.backgroundColor = [UIColor creditCardColor];
    [self.b_view.layer setCornerRadius:7.0f];
    
    self.backgroundColor = [UIColor clearColor];
    [self.secured_image.layer setCornerRadius:7.0f];    
    
}

-(void) killKeyboard {
//    NSLog(@"Killin Keyboard");
    [self endEditing:YES];
//    for (UIView * txt in [self subviews]){
//        if ([txt respondsToSelector:@selector(resignFirstResponder)]) {
//            [txt resignFirstResponder];
//        }
//    }
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
//    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissModalViewControllerAnimated:YES];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {

    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    
    self.paymentView.cardNumberField.text = [[PKCardNumber cardNumberWithString:info.cardNumber] formattedString];
    
    self.paymentView.cardNumberField.placeholder = @"";
    self.paymentView.cardExpiryField.placeholder = @"";
    self.paymentView.cardCVCField.placeholder = @"";
    
    [self.paymentView performSelector:@selector(setPlaceholderToCardType)];
    
    [self.paymentView.cardNumberField setNeedsDisplay];
    [self.paymentView.cardExpiryField setNeedsDisplay];
    [self.paymentView.cardCVCField setNeedsDisplay];
    
    NSString *year = [NSString stringWithFormat:@"@%d",info.expiryYear];
    self.paymentView.cardExpiryField.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)info.expiryMonth,[year substringFromIndex:year.length-2]];
    self.paymentView.cardCVCField.text = info.cvv;

    
    [self killKeyboard];
    
    //    [self.paymentView performSelector:@selector(stateMeta)];
    //    [self.paymentView performSelector:@selector(stateCardNumber)];
    //    [self.paymentView performSelector:@selector(stateMeta)];
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

- (void)launchDialog:(NSString *)msg
{
    // Here we need to pass a full frame
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
    message.text = msg;
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
    [alertView setContainerView:message];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Ok", nil]];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

- (void)launchAlert:(NSString *)msg
{
//    NSLog(@"CONTROLLER NAMED: %@", controller.navigationController.topViewController.class);
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:controller.navigationController.topViewController.view
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionTop
                                                        title:@"Success!"
                                                     subtitle:msg];
    
    
    banner.secondsToShow = 3.0f;
    
    [banner show];
}

- (IBAction)completeButtonTapped:(id)sender {
    
    //1
    main_user.stripeCard = [[STPCard alloc] init];
    main_user.stripeCard.name = [bill_user get_full_name];
    main_user.stripeCard.number = [self.paymentView.cardNumber formattedString];
    main_user.stripeCard.cvc = [self.paymentView.cardCVC string];
    main_user.stripeCard.expMonth = [self.paymentView.cardExpiry month];
    main_user.stripeCard.expYear = [self.paymentView.cardExpiry year];
    
    //2
    if ([self validateCustomerInfo]) {
        [self performStripeOperation];
        main_user.validCreditCard = YES;
        [controller.navigationController popViewControllerAnimated:YES];
        [self launchAlert:@"Payment Information Accepted"];        
    }
}

- (BOOL)validateCustomerInfo {
    
    
    //1. Validate name & email
    if (main_user.stripeCard.name.length == 0) {
        [self launchDialog:@"Please enter all information."];
        return NO;
    }
    
    //2. Validate card number, CVC, expMonth, expYear
    NSError* error = nil;
    [self.main_user.stripeCard validateCardReturningError:&error];
    
    //3
    if (error) {
        [self launchDialog:[error localizedDescription]];
        return NO;
    }
    
    return YES;
}

- (void)performStripeOperation {
    
    //1
    self.completeButton.enabled = NO;
    
    //2
    /*
     [Stripe createTokenWithCard:self.stripeCard
     publishableKey:STRIPE_TEST_PUBLIC_KEY
     success:^(STPToken* token) {
     [self postStripeToken:token.tokenId];
     } error:^(NSError* error) {
     [self handleStripeError:error];
     }];
     */
    [Stripe createTokenWithCard:self.main_user.stripeCard
                 publishableKey:StripeToken
                     completion:^(STPToken* token, NSError* error) {
                         if(error)
                             NSLog(@"Error: %@",error);
                         else
//                           [self postStripeToken:token.tokenId];
                             NSLog(@"Party Time: %@",token.tokenId);
                     }];
}

@end
