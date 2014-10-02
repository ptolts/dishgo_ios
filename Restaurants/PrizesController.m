//
//  PrizesController.m
//  DishGo
//
//  Created by Philip Tolton on 2014-07-29.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "PrizesController.h"
#import "Constant.h"
#import "UserSession.h"
#import <FAKFontAwesome.h>
#import <GAI.h>
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "WebViewJavascriptBridge.h"
#import "SignInViewController.h"

@interface PrizesController ()

@end

@implementation PrizesController {
    UIActivityIndicatorView *spinner;
    NSString *prize_url;
    UIImage *old_bg_image;
    UIImage *old_shadow_image;
    WebViewJavascriptBridge *bridge;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled: break;
            
        case MessageComposeResultFailed:
            NSLog(@"Error sending sms");
            break;
            
        case MessageComposeResultSent: break;
            
        default: break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendSMS: (NSString *) message {
    //check if the device can send text messages
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //set receipients
    NSArray *recipients = [NSArray arrayWithObjects: nil];

    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipients];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)sharePromoCode:(NSString *) msg {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:msg]];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) myCustomBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!self.restaurant){
        self.restaurant = @"";
    }
    self.view.backgroundColor = [UIColor almostBlackColor];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"has_seen_prize_page"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.webview.autoresizingMask = UIViewAutoresizingNone;

    FAKFontAwesome *back = [FAKFontAwesome timesCircleIconWithSize:22.0f];
    [back addAttribute:NSForegroundColorAttributeName value:[UIColor scarletColor]];
    UIImage *image = [back imageWithSize:CGSizeMake(45.0,45.0)];
    CGRect buttonFrame = CGRectMake(self.view.frame.size.width - image.size.width, 10, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(myCustomBack) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [self.view addSubview: button];
    [self.view bringSubviewToFront:button];
    
    self.webview.backgroundColor = [UIColor almostBlackColor];
    
    
    bridge = [WebViewJavascriptBridge bridgeForWebView:self.webview webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@",data);
        
        if([data isKindOfClass:[NSString class]]){
            if([data isEqualToString:@"sign_in"]){
                UINavigationController *nc = self.navigationController;
                SignInViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
                [[self navigationController] setNavigationBarHidden:NO animated:NO];
                [nc pushViewController:vc animated:YES];
            }
            if([data isEqualToString:@"app_version"]){
                responseCallback([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
            }
        }
        
        if([data isKindOfClass:[NSDictionary class]]){
            NSDictionary *result = (NSDictionary *) data;
            if([result objectForKey:@"sendSMS"]){
                NSString *text = [result objectForKey:@"sendSMS"];
                [self sendSMS:text];
            }
            if([result objectForKey:@"sharePromoCode"]){
                NSString *text = [result objectForKey:@"sharePromoCode"];
                [self sharePromoCode:text];
            }
        }
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.webview stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"].length < 1)
    {
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:prize_url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0]];
    } else {
        [spinner removeFromSuperview];
    }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Prizes Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    UserSession *user_session = [UserSession sharedManager];
    User *user = [user_session fetchUser];
    NSString *tok = user.dishgo_token;
    if(!tok){
        tok = @"";
    }
    prize_url = [NSString stringWithFormat:@"%@/app/prizes/list?token=%@&restaurant=%@&lat=%@&lon=%@",dishGoUrl,tok,self.restaurant,user_session.lat,user_session.lon];
    NSLog(@"Looking up prizes at: %@",prize_url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL
                                                          URLWithString:prize_url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:60.0];
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.webview.center;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    [self.webview loadRequest:request];
}


@end
