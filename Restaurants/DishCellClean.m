//
//  DishCellClean.m
//  DishGo
//
//  Created by Philip Tolton on 2014-06-23.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "DishCellClean.h"
#import "Dishes.h"
#import "FontAwesomeKit/FAKFontAwesome.h"
#import "TWRBorderedView.h"
#import "UIColor+Custom.h"

@implementation DishCellClean

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setup {
    self.title.font = [UIFont fontWithName:@"Josefin Sans" size:22.0f];
    self.title.text = self.section.name;
    self.dish_count.text = [NSString stringWithFormat:@"%d",[self.section.dishes count]];
    float high = -1;
    float low = -1;
    float total_rating = 0;
    int total_dishes_with_ratings = 0;
    for(Dishes *d in self.section.dishes){
        NSMutableArray *range = [d priceRange];
        float dish_high = [range[1] floatValue];
        float dish_low = [range[0] floatValue];
        if(high == -1 || dish_high > high){
            high = dish_high;
        }
        if(low == -1 || dish_low < low){
            low = dish_low;
        }
        if([d.rating intValue] > 0){
            total_dishes_with_ratings++;
            total_rating += [d.rating floatValue];
        }
    }
    
    total_rating = total_rating / total_dishes_with_ratings;
    NSNumber *total_rating_num = [NSNumber numberWithFloat:total_rating];
    
    if([[NSNumber numberWithFloat:low] intValue] == 0 && [[NSNumber numberWithFloat:high] intValue] == 0){
        self.price_range.text = @"NA";
    } else if([[NSNumber numberWithFloat:low] intValue] == 0){
        self.price_range.text = [NSString stringWithFormat:@"$%.0f",high];
    } else if([[NSNumber numberWithFloat:high] intValue] == 0){
        self.price_range.text = [NSString stringWithFormat:@"$%.0f",low];
    } else {
        self.price_range.text = [NSString stringWithFormat:@"$%.0f-%.0f",low,high];
    }
    
    self.price_range.font = [UIFont fontWithName:@"Josefin Sans" size:18.0f];
    self.dish_count.font = [UIFont fontWithName:@"Josefin Sans" size:18.0f];
    [self.price_range setTextColor:[UIColor grayColor]];
    [self.dish_count setTextColor:[UIColor grayColor]];

    NSMutableAttributedString *attributionMas = [[NSMutableAttributedString alloc] init];
    FAKFontAwesome *star = [FAKFontAwesome starIconWithSize:16];
    
    [star addAttribute:NSForegroundColorAttributeName value:[UIColor starColor]];
    for(int i=0;i<[total_rating_num intValue];i++){
        [attributionMas appendAttributedString:[star attributedString]];
    }
    [star addAttribute:NSForegroundColorAttributeName value:[UIColor seperatorColor]];
    int left_over_stars = 5 - [total_rating_num intValue];
    for(int i=0;i<left_over_stars;i++){
        [attributionMas appendAttributedString:[star attributedString]];
    }
    
    self.rating.attributedText = attributionMas;
    
    self.dishes_count_label.font = [UIFont fontWithName:@"Josefin Sans" size:12.0f];
    self.range_label.font = [UIFont fontWithName:@"Josefin Sans" size:12.0f];
    self.rating_label.font = [UIFont fontWithName:@"Josefin Sans" size:12.0f];
    
    [self.dishes_count_label setTextColor:[UIColor grayColor]];
    [self.range_label setTextColor:[UIColor grayColor]];
    [self.rating_label setTextColor:[UIColor grayColor]];
    
//    CGRect borderedViewRect = CGRectMake(0, 0, 320, 1);
//    TWRBorderMask mask = TWRBorderMaskBottom;
//    TWRBorderedView *borderedView = [[TWRBorderedView alloc] initWithFrame:borderedViewRect
//                                                               borderWidth:1.0f
//                                                                     color:[UIColor colorWithRed:102.0f green:102.0f blue:102.0f alpha:1]
//                                                                   andMask:mask];
//    [self addSubview:borderedView];
    self.separator.backgroundColor = [UIColor seperatorColor];
}


@end
