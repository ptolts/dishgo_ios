//
//  SignInViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 11/22/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "SignInViewController.h"
#import "RAppDelegate.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClickHandler:(id)sender {
    
    NSLog(@"Logging in!");
    
    // get the app delegate so that we can access the session property
    RAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
        }];
    }
}

@end
