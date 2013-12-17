//
//  RestoScrollView.m
//  Restaurants
//
//  Created by Philip Tolton on 10/25/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "RestoScrollView.h"

@implementation RestoScrollView

    @synthesize currentPage;
    @synthesize numberOfPages;
    NSTimer *scroll_timer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void) killScroll {
//    NSLog(@"Scrollview: %d stopping scroll",self.numberOfPages);    
//    [scroll_timer invalidate];
//    scroll_timer = nil;
//}
//
//- (void) scroll {
//    NSLog(@"Scrollview: %d starting scroll",self.numberOfPages);
//    currentPage = 0;
//    scroll_timer = [NSTimer scheduledTimerWithTimeInterval:5.0
//                                      target:self
//                                    selector:@selector(scrollPages)
//                                    userInfo:Nil
//                                     repeats:YES];
//    [scroll_timer fire];
//}



-(void)scrollToPage:(NSInteger)aPage{
    float myPageWidth = [self frame].size.width;
    float myPageY = [self frame].origin.y;
//    [self setContentOffset:CGPointMake(aPage*myPageWidth,myPageY) animated:YES];
    [UIView
        animateWithDuration:1.5
        delay:0
        options:UIViewAnimationOptionAllowUserInteraction
        animations:^{
        self.contentOffset = CGPointMake(aPage*myPageWidth,myPageY);
        }
        completion: nil
     ];
}

-(void)scrollPages{
    [self scrollToPage:currentPage%numberOfPages];
    currentPage++;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
