//
//  DishScrollView.m
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "DishScrollView.h"
#import "Sections.h"
//#import "Subsections.h"
#import "DishView.h"
#import "Dishes.h"
#import "UIColor+Custom.h"

@implementation DishScrollView

    @synthesize dishArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupViews {
    dishArray = [[NSMutableArray alloc] init];
    int i = 0;
    int dd = 0;
//    for (Subsections *sec in self.section.subsections) {
        int d = 0;
        for (Dishes *dish in _section.dishes) {
            [dishArray addObject:dish];
            DishView *dish_view = [[[NSBundle mainBundle] loadNibNamed:@"DishView" owner:self options:nil] objectAtIndex:0];
            
            CGRect frame = dish_view.frame;
            
            frame.origin.x = self.frame.size.width * dd;
            
            if (d == 0) {
                [dish_view.right_arrow removeFromSuperview];
            }
            
//            if ((i + 1) == [self.section.subsections count] && (d + 1) == [_section.dishes count]) {
            if ((d + 1) == [_section.dishes count]) {
                [dish_view.left_arrow removeFromSuperview];
            }
            
            d++;
            dd++;
            dish_view.frame = frame;
            dish_view.dishDescription.text = dish.description_text;
            [dish_view.dishDescription sizeToFit];
            dish_view.dishDescription.font = [UIFont fontWithName:@"Newtext RG Bt" size:16.0f];
            dish_view.dishDescription.textColor = [UIColor textColor];
            dish_view.dishTitle.text = dish.name;
            dish_view.dishTitle.textColor = [UIColor textColor];
            [dish_view.more removeFromSuperview];
            dish_view.seperator.backgroundColor = [UIColor seperatorColor];
            dish_view.backgroundColor = [UIColor bgColor];
            
            dish_view.controller = self.controller;
            
            [self addSubview:dish_view];
            
        }
//        i++;
//    }
    _total_pages = d;
//    NSLog(@"Secion: %@ Dishes: %d Subviews: %d",self.section.name,dd,[self.subviews count]);
    self.contentSize = CGSizeMake(self.frame.size.width * ([self.subviews count] - 1), self.frame.size.height);
    self.pagingEnabled = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesBegan: touches withEvent:event];
    }
    else{
        [super touchesBegan: touches withEvent: event];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesMoved: touches withEvent:event];
    }
    else{
        [super touchesMoved: touches withEvent: event];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesEnded: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}

-(int) currentPage{
    CGFloat pageWidth = self.frame.size.width;
    return floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

-(Dishes *) currentDish {
    return [dishArray objectAtIndex:[self currentPage]];
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
