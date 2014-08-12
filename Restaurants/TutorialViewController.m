//
//  TutorialViewController.m
//  DishGo
//
//  Created by Philip Tolton on 2014-08-11.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "RAppDelegate.h"
#import "TutorialViewController.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import <FAKFontAwesome.h>

@interface TutorialViewController ()

@end

@implementation TutorialViewController


+(TutorialViewController *) setup {
    
    NSString *page_1_string = NSLocalizedString(@"Rate dishes, share pictures and collect DishCoins. Redeem them for great prizes.",nil);
    
    NSString *page_title = NSLocalizedString(@"Browse Restaurant Menus", nil);
    
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:page_title subTitle:page_1_string pictureName:@"page1.png" duration:5.0f];
    
    ICETutorialLabelStyle *page_1_style = [[ICETutorialLabelStyle alloc] init];
    [page_1_style setFont:[UIFont fontWithName:@"JosefinSans-Bold" size:24.0f]];
    [page_1_style setTextColor:[UIColor scarletColor]];
    [page_1_style setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
    [page_1_style setOffset:300];
    
    //    for (NSString* family in [UIFont familyNames])
    //    {
    //        NSLog(@"%@", family);
    //
    //        for (NSString* name in [UIFont fontNamesForFamilyName: family])
    //        {
    //            NSLog(@"  %@", name);
    //        }
    //    }
    
    [[ICETutorialStyle sharedInstance] setTitleStyle:page_1_style];
    
    ICETutorialLabelStyle *page_1_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_1_desc_style setFont:[UIFont fontWithName:@"Josefin Sans" size:20.0f]];
    [page_1_desc_style setTextColor:[UIColor whiteColor]];
    [page_1_desc_style setLinesNumber:0];
    [page_1_desc_style setOffset:260];
    
    [[ICETutorialStyle sharedInstance] setSubTitleStyle:page_1_desc_style];
    
    [layer1 setSubTitleStyle:page_1_desc_style];
    [layer1 setTitleStyle:page_1_style];
    
    // PAGE 2
    
    page_1_string = NSLocalizedString(@"Search through restaurants in your surrounding area and select one by tapping the tile.",nil);
    
    page_title = NSLocalizedString(@"Select a Restaurant",nil);
    
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:page_title subTitle:page_1_string pictureName:@"page2.png" duration:5.0f];
    
    ICETutorialLabelStyle *page_2_style = [[ICETutorialLabelStyle alloc] init];
    [page_2_style setTextColor:[UIColor scarletColor]];
    [page_2_style setOffset:230];
    
    ICETutorialLabelStyle *page_2_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_2_desc_style setTextColor:[UIColor tutorialBrown]];
    [page_2_desc_style setOffset:200];
    
    [layer2 setSubTitleStyle:page_2_desc_style];
    [layer2 setTitleStyle:page_2_style];
    
    // PAGE 3
    
    page_1_string = NSLocalizedString(@"Browse the restaurant details. Tap a menu section or dish image.",nil);
    
    page_title =  NSLocalizedString(@"Restaurant Storefront",nil);
    
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:page_title subTitle:page_1_string pictureName:@"page3.png" duration:5.0f];
    
    ICETutorialLabelStyle *page_3_style = [[ICETutorialLabelStyle alloc] init];
    [page_3_style setTextColor:[UIColor scarletColor]];
    [page_3_style setOffset:230];
    
    ICETutorialLabelStyle *page_3_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_3_desc_style setTextColor:[UIColor tutorialBrown]];
    [page_3_desc_style setOffset:200];
    
    [layer3 setSubTitleStyle:page_3_desc_style];
    [layer3 setTitleStyle:page_3_style];
    
    
    // PAGE 4
    
    page_1_string = NSLocalizedString(@"Browse the dishes and share pictures of your meal to accumulate DishCoins.",nil);
    
    page_title = NSLocalizedString(@"Browse & Upload Pics",nil);
    
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:page_title subTitle:page_1_string pictureName:@"page4.png" duration:5.0f];
    
    ICETutorialLabelStyle *page_4_style = [[ICETutorialLabelStyle alloc] init];
    [page_4_style setTextColor:[UIColor scarletColor]];
    [page_4_style setOffset:230];
    
    ICETutorialLabelStyle *page_4_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_4_desc_style setTextColor:[UIColor tutorialBrown]];
    [page_4_desc_style setOffset:200];
    
    [layer4 setSubTitleStyle:page_4_desc_style];
    [layer4 setTitleStyle:page_4_style];
    
    // PAGE 5
    
    page_1_string = NSLocalizedString(@"Review the dish details including sizes and options. Submit you own rating to collect extra DishCoins.",nil);
    
    page_title = NSLocalizedString(@"Dish Details & Ratings",nil);
    
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:page_title subTitle:page_1_string pictureName:@"page5.png" duration:5.0f];
    
    ICETutorialLabelStyle *page_5_style = [[ICETutorialLabelStyle alloc] init];
    [page_5_style setTextColor:[UIColor scarletColor]];
    [page_5_style setOffset:230];
    
    ICETutorialLabelStyle *page_5_desc_style = [[ICETutorialLabelStyle alloc] init];
    [page_5_desc_style setTextColor:[UIColor tutorialBrown]];
    [page_5_desc_style setOffset:200];
    
    [layer5 setSubTitleStyle:page_5_desc_style];
    [layer5 setTitleStyle:page_5_style];
    
    
    // Load into an array.
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5];
    
    TutorialViewController *tutorial_view = [[TutorialViewController alloc] initWithPages:tutorialLayers];
    tutorial_view.delegate = tutorial_view;

    
    UILabel *rightButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,130,36)];
    UIButton *rightButton = tutorial_view.rightButton;
    rightButtonLabel.textAlignment = NSTextAlignmentCenter;
    rightButtonLabel.backgroundColor = [UIColor clearColor];
    rightButtonLabel.textColor = [UIColor whiteColor];
    
    
    NSString *start_button = NSLocalizedString(@"Start  ",nil);
    NSMutableAttributedString *arrow_string = [[NSMutableAttributedString alloc] initWithString:start_button];
    [arrow_string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"JosefinSans-Bold" size:20.0f] range:NSMakeRange(0,[start_button length]-1)];
    FAKFontAwesome *arrow = [FAKFontAwesome caretRightIconWithSize:20.0f];
    [arrow addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [arrow_string appendAttributedString:[arrow attributedString]];
    [rightButtonLabel setAttributedText:arrow_string];
    [rightButton addSubview:rightButtonLabel];
    [rightButton bringSubviewToFront:rightButtonLabel];
    
    tutorial_view.leftButton.hidden = YES;
    tutorial_view.rightButton.hidden = YES;
    
    return tutorial_view;
    
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
    NSLog(@"Button 1 pressed.");
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"tutorial"];
    [defaults synchronize];
    [self hide];
}

- (void) hide {
    UIWindow *mainWindow = (((RAppDelegate *)[UIApplication sharedApplication].delegate).window);
    if(mainWindow.rootViewController == self){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTutorial" object:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tutorialControllerDidReachLastPage:(ICETutorialController *)tutorialController {
    self.rightButton.hidden = NO;
}


@end
