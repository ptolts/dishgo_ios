//
//  DishCoins.m
//  DishGo
//
//  Created by Philip Tolton on 2014-07-28.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "DishCoins.h"
#import "UserSession.h"
#import "User.h"

@implementation DishCoins

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) layoutSubviews {
    User *user = [[UserSession sharedManager] fetchUser];
    self.dishcoin_count.text = [user.dishcoins stringValue];
    [super layoutSubviews];
}

@end
