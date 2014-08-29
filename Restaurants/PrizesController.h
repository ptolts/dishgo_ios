//
//  PrizesController.h
//  DishGo
//
//  Created by Philip Tolton on 2014-07-29.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface PrizesController : UIViewController <UIWebViewDelegate, MFMessageComposeViewControllerDelegate>
    @property (strong, nonatomic) IBOutlet UIWebView *webview;
    @property NSString *restaurant;
@end
