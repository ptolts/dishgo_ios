//
//  ReviewPopup.h
//  DishGo
//
//  Created by Philip Tolton on 2014-08-07.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewPopup : UIView
@property (strong, nonatomic) IBOutlet UILabel *review_label;
@property (strong, nonatomic) IBOutlet UITextView *review_text;
@property (strong, nonatomic) IBOutlet UIButton *submit_button;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *close;
- (IBAction)close:(id)sender;
- (IBAction)submit:(id)sender;
-(void) setup;
@end
