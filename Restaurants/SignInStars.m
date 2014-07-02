//
//  SignInStars.m
//  DishGo
//
//  Created by Philip Tolton on 2014-06-27.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "SignInStars.h"
#import "UserSession.h"

@implementation SignInStars

@synthesize vc;
@synthesize navigationController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[UserSession sharedManager] logged_in]){
        [super touchesBegan:touches withEvent:event];
    } else {
        [navigationController pushViewController:vc animated:YES];
    }
}

@end
