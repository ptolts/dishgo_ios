//
//  CartButton.m
//  Restaurants
//
//  Created by Philip Tolton on 11/21/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "CartButton.h"
#import "UIColor+Custom.h"
#import "FontAwesomeKit/FAKFontAwesome.h"

@implementation CartButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setCount:(NSString *)newText {
    if([newText isEqualToString:self.cart_count.text]){
        return;
    }
//    [UIView animateWithDuration:1.0
//                     animations:^{
//                         self.cart_count.alpha = 0.0f;
//                         self.cart_count.text = newText;
//                         self.cart_count.alpha = 1.0f;
//                     }];
    [UIView transitionWithView: self.cart_count
                      duration: 0.5f
                       options: UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^(void)
     {
         self.cart_count.text = newText;
     }
                    completion: ^(BOOL isFinished)
     {
         
     }];
    
    
}

- (id)init {
    
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];

    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CartButton" owner:self options:nil] objectAtIndex:0];
        [self.background.layer setCornerRadius:5.0f];
    }
//    FAKFontAwesome *fileO = [FAKFontAwesome fileIconWithSize:24];
//    [fileO addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
//    UIImage *iconImage = [fileO imageWithSize:CGSizeMake(24, 24)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.cart_count.backgroundColor = [UIColor textColor];
//    self.cart_count.layer.borderColor = [UIColor textColor].CGColor;
//    [btn setBackgroundImage:iconImage forState:UIControlStateNormal];
    [btn addSubview:self];
    [btn setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.background setBackgroundColor:[UIColor whiteColor]];
    self.button = btn;
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

@end
