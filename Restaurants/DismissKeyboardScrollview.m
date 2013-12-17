//
//  DismissKeyboardScrollview.m
//  Restaurants
//
//  Created by Philip Tolton on 12/16/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "DismissKeyboardScrollview.h"

@implementation DismissKeyboardScrollview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nextResponder touchesBegan: touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nextResponder touchesMoved: touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nextResponder touchesEnded: touches withEvent:event];
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
