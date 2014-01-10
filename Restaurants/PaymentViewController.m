//
//  PaymentTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 12/12/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "PaymentViewController.h"
//#import "PaymentTableViewCell.h"
#import "PKView.h"
#import <PKTextField.h>
#import <ALAlertBanner/ALAlertBanner.h>
#import "BillingView.h"

#define CELL_SIZE 532
#define StripeToken @"pk_test_cfUGIxN4SeoRDJaeyHNOxblH"
#define CardColor [UIColor creditCardColor]

@interface PaymentViewController ()

@end

@implementation PaymentViewController

@synthesize main_user;
@synthesize bill_user;
@synthesize next_view;

//PaymentTableViewCell *cellConfirm;
int cellHeight;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self killKeyboard];
}

-(IBAction)dissmissKeyboard:(id)sender{
    [sender resignFirstResponder];
}

-(void) viewWillAppear:(BOOL)animated {
    [self setup];
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
    
    
    BillingView *bill_view = [[BillingView alloc] init];
    bill_view.u = bill_user;
    bill_view.frame = self.b_view.frame;
    [self.b_view removeFromSuperview];
    self.b_view = bill_view;
    [self.scroll_view addSubview:bill_view];
    bill_view.pay = self;
    [bill_view setup];

    NSLog(@"Card View Size: %@",CGRectCreateDictionaryRepresentation(self.card_bg.frame));
    NSLog(@"Bill View Size: %@",CGRectCreateDictionaryRepresentation(bill_view.frame));
    
    self.b_view.backgroundColor = [UIColor creditCardColor];
    [self.b_view.layer setCornerRadius:7.0f];
    
}

-(void) killKeyboard {
    //    NSLog(@"Killin Keyboard");
    [self.view endEditing:YES];
    //    for (UIView * txt in [self subviews]){
    //        if ([txt respondsToSelector:@selector(resignFirstResponder)]) {
    //            [txt resignFirstResponder];
    //        }
    //    }
}

-(void) scanCardMethod: sender{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"4827b4c8bc7646e08c699c9bd2ebde76"; // get your app token from the card.io website
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:scanViewController animated:YES completion:nil];
    } else {
        [self presentModalViewController:scanViewController animated:YES];
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
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.navigationController.topViewController.view
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionTop
                                                        title:@"Success!"
                                                     subtitle:msg];
    
    
    banner.secondsToShow = 3.0f;
    
    [banner show];
}

- (void) confirmDetails {
    
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
        UINavigationController *n = self.navigationController;
        [self.navigationController popViewControllerAnimated:NO];
        [n.topViewController performSelector:NSSelectorFromString(@"next")];
//        [self launchAlert:@"Payment Information Accepted"];
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

- (void) viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;    
//    [self setup];
    [self setupBackButtonAndCart];
    self.view.backgroundColor = [UIColor bgColor];
    self.next_view.backgroundColor = [UIColor bgColor];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    UIImage *img = [UIImage imageNamed:@"background_signup.jpg"];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
//    [imageView setFrame:self.tableView.frame];
//    imageView.contentMode = UIViewContentModeScaleToFill;
//    self.tableView.backgroundView = imageView;
    self.scroll_view.backgroundColor = [UIColor bgColor];
}

- (void) setupBackButtonAndCart {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]; // <-- Use your own image
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
    [backBtn setImage:backBtnImage];
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
    //                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    //                                       target:nil action:nil];
    //    negativeSpacer.width = -16;// it was -6 in iOS 6
    //    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, backBtn, nil] animated:NO];
    //	self.navigationItem.leftBarButtonItem = backBtn;
    [self.navigationItem setLeftBarButtonItem:backBtn];
    // FOOD CLOUD TITLE
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Copperplate-Bold" size:20.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"Payment Method";
    self.navigationItem.titleView = label;
}

-(void) myCustomBack {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 1;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"paymentCell";
//    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    cell.controller = self;
//    cell.main_user = main_user;
//    cell.bill_user = bill_user;
//    [cell setup];
//    
//    [cell.contentView setNeedsLayout];
//
//    CGRect frame = cell.contentView.frame;
//    frame.size.height = cellHeight;
//    cell.contentView.frame = frame;
//
//    int available = cellHeight;
//    
//    int subcount = [[cell.contentView subviews] count];
//    
//    for(UIView *v in [cell.contentView subviews]){
//        available -= v.frame.size.height;
//    }
//    
//    NSComparator comparatorBlock = ^(UIView *obj1, UIView *obj2) {
//        if (obj1.frame.origin.y > obj2.frame.origin.y) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }
//        
//        if (obj1.frame.origin.y < obj2.frame.origin.y) {
//            return (NSComparisonResult)NSOrderedAscending;
//        }
//        return (NSComparisonResult)NSOrderedSame;
//    };
//    
//    int new_offset = 0;
//    int add_offset = (int)(available / subcount);
//    
//    for(UIView *v in [[cell.contentView subviews] sortedArrayUsingComparator:comparatorBlock]){
//        NSLog(@"Fixing Layout: %@",v.class);
//        new_offset += add_offset;
//        CGRect frame = v.frame;
//        frame.origin.y += new_offset;
//        v.frame = frame;
//    }
//    
//    cellConfirm = cell;
//    return cell;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return cellHeight;
//}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupNextButton];
}

- (void) setupNextButton {
    if([[next_view subviews] count] == 0){
        next_view.backgroundColor = [UIColor clearColor];
        NSLog(@"Adding Next");
        int total_height = self.view.frame.size.height;
        int view_height = 60;
        int button_height = 38;
        int view_position = total_height - view_height;
        
        CGRect frame = next_view.frame;
        frame.origin.y = view_position;
        frame.size.height = view_height;
        next_view.frame = frame;
        
        frame = self.scroll_view.frame;
        frame.size.height = self.view.frame.size.height - view_height;
        self.scroll_view.frame = frame;
        
        UILabel *next_but = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, button_height)];
        next_but.text = @"Next";
        [next_but setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
        next_but.textColor = [UIColor bgColor];
        next_but.textAlignment = NSTextAlignmentCenter;
        [next_but setUserInteractionEnabled:NO];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20, ((view_height - button_height) / 2.0), self.view.frame.size.width - 40, button_height)];
        btn.backgroundColor = [UIColor nextColor];
        btn.layer.cornerRadius = 3.0f;
        [btn addSubview:next_but];
        [btn addTarget:self action:@selector(confirmDetails) forControlEvents:UIControlEventTouchUpInside];
        [next_view addSubview:btn];
        
        [self equalSpace];
    }
}

- (void) equalSpace {
    
    int available = self.scroll_view.frame.size.height;
    
    int subcount = [[self.scroll_view subviews] count];
    for(UIView *v in [self.scroll_view subviews]){
        available -= v.frame.size.height;
    }
    
    NSComparator comparatorBlock = ^(UIView *obj1, UIView *obj2) {
        if (obj1.frame.origin.y > obj2.frame.origin.y) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (obj1.frame.origin.y < obj2.frame.origin.y) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    int new_offset = 0;
    int add_offset = (int)(available / subcount);
    
    NSLog(@"Add_offset: %d",add_offset);
    
    for(UIView *v in [[self.scroll_view subviews] sortedArrayUsingComparator:comparatorBlock]){
        new_offset += add_offset;
        CGRect frame = v.frame;
        frame.origin.y += new_offset;
        v.frame = frame;
    }
}

@end
