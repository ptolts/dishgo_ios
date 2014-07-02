//
//  SignInStars.h
//  DishGo
//
//  Created by Philip Tolton on 2014-06-27.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "EDStarRating.h"
#import "SignInViewController.h"

@interface SignInStars : EDStarRating
    @property SignInViewController *vc;
    @property UINavigationController *navigationController;
@end
