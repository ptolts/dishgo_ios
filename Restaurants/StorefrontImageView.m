//
//  StorefrontImageView.m
//  Restaurants
//
//  Created by Philip Tolton on 10/29/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "StorefrontImageView.h"
#import "DishTableViewController.h"
#import "StorefrontTableViewController.h"

@implementation StorefrontImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupDish{
    [self.controller pushDish: self.dish];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nextResponder touchesBegan: touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nextResponder touchesMoved: touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setupDish];
//    [self.nextResponder touchesEnded: touches withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
