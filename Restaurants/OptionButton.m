//
//  OptionButton.m
//  DishGo
//
//  Created by Philip Tolton on 2014-05-30.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "OptionButton.h"
#import "SizePrices.h"
#import "OptionButtonView.h"
#import <FontAwesomeKit/FAKFontAwesome.h>

@implementation OptionButton {

    NSMutableDictionary *backgroundStates;
    OptionButtonView *option_button_view;

}
    
- (id)initWithFrame:(CGRect)frame
{
    self = [super initRaisedWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setup {
    option_button_view.description.font = [UIFont fontWithName:@"Josefin Sans" size:18.0f];
    option_button_view.price.font = [UIFont fontWithName:@"Josefin Sans" size:18.0f];
    option_button_view = [[[NSBundle mainBundle] loadNibNamed:@"OptionButtonView" owner:self options:nil] objectAtIndex:0];
    option_button_view.description.text = self.option.name;
    option_button_view.backgroundColor = [UIColor unselectedButtonColor];
    if([self.option.price floatValue] != 0.0){
        option_button_view.price.text = [NSString stringWithFormat:@"%.02f",[self.option.price floatValue]];
    } else {
        option_button_view.price.text = @"";
    }
//    NSMutableAttributedString *attributionMas = [[NSMutableAttributedString alloc] init];
//    FAKFontAwesome *check = [FAKFontAwesome checkCircleIconWithSize:16.0f];
//    [check addAttribute:NSForegroundColorAttributeName value:[UIColor scarletColor]];
//    [attributionMas appendAttributedString:[check attributedString]];
//    option_button_view.checkmark_label.attributedText = attributionMas;
    option_button_view.userInteractionEnabled = NO;
    [self addSubview:option_button_view];
    [self bringSubviewToFront:option_button_view];
}

- (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        option_button_view.backgroundColor = [UIColor selectedButtonColor];
//        [option_button_view.checkmark_label setHidden:NO];
    } else {
        option_button_view.backgroundColor = [UIColor unselectedButtonColor];
//        [option_button_view.checkmark_label setHidden:YES];
    }
    [option_button_view setNeedsDisplay];
}

-(void) updatePrice: (NSString *)size_id {
    Option *opt = self.option;
    for(SizePrices *size_price in opt.size_prices){
        if([size_price.related_to_size isEqualToString:size_id]){
            self.option.price = size_price.price;
            self.price = [size_price.price floatValue];
            if([self.option.price floatValue] != 0.0){
                option_button_view.price.text = [NSString stringWithFormat:@"%.02f",[size_price.price floatValue]];
            } else {
                option_button_view.price.text = @"";
            }
//            [self setTitle:[NSString stringWithFormat:@"%@\n$%@",self.option.name,size_price.price ] forState:UIControlStateNormal];
//            [self setTitle:[NSString stringWithFormat:@"%@\n$%@",self.option.name,size_price.price ] forState:UIControlStateSelected];
        }
    }
}

@end
