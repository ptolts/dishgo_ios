//
//  DishScrollView.m
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "DishScrollView.h"
#import "Sections.h"
#import "Subsections.h"
#import "DishView.h"
#import "Dishes.h"

@implementation DishScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupViews:(NSIndexPath *)indexPath {
    int i = 0;
    for (Subsections *sec in self.section.subsections) {
       for (Dishes *dish in sec.dishes) {
            DishView *dish_view = [[[NSBundle mainBundle] loadNibNamed:@"DishView" owner:self options:nil] objectAtIndex:0];
            CGRect frame = dish_view.frame;
            frame.origin.x = self.frame.size.width * i;
           if (i == 0 && indexPath.section == 0) {
               CABasicAnimation *theAnimation;
               theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
               theAnimation.duration=2.0;
               theAnimation.repeatCount=2;
               theAnimation.autoreverses=YES;
               theAnimation.fromValue=[NSNumber numberWithFloat:0.0];
               theAnimation.toValue=[NSNumber numberWithFloat:1.0];
               [dish_view.arrow.layer addAnimation:theAnimation forKey:@"animateOpacity"];
           }
            i++;
            dish_view.frame = frame;
            dish_view.dishDescription.text = dish.description_text;
            dish_view.dishTitle.text = dish.name;
           
            [self addSubview:dish_view];
//            for(Options *options in dish.options){
//                NSMutableArray *itemArray = [[NSMutableArray alloc] init];
//                for(Option *option in options.list){
//                    [itemArray addObject:[NSString stringWithFormat:@"%@: %@$",option.name,option.price]];
//                }
//                UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
//                segmentedControl.frame = CGRectMake(5, cell.frame.size.height + 5, cell.frame.size.width - 10, 50);
//                segmentedControl.selectedSegmentIndex = 1;
//                segmentedControl.tag = 12345;
//                [cell.contentView addSubview:segmentedControl];
//            }
       }
    }
    self.contentSize = CGSizeMake(self.frame.size.width * [self.subviews count], self.frame.size.height);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
