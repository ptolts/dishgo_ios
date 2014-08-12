//
//  TutorialViewController.h
//  DishGo
//
//  Created by Philip Tolton on 2014-08-11.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ICETutorial/ICETutorialController.h>

@interface TutorialViewController : ICETutorialController <ICETutorialControllerDelegate>
    +(TutorialViewController *) setup;
@end
