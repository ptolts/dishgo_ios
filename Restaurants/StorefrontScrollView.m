//
//  StorefrontScrollView.m
//  Restaurants
//
//  Created by Philip Tolton on 10/29/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "StorefrontScrollView.h"
#import "StorefrontImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "StorefrontTableViewController.h"

@implementation StorefrontScrollView {

    NSMutableArray *imageViews;
    
}

-(void)setupImages {
    self.delegate = self;
    imageViews = [[NSMutableArray alloc] init];
    int i = 0;
    NSMutableArray *list = [self.restaurant dishList];
    for (Dishes *dish in list) {
        
        if([dish.images count] == 0){
            continue;
        }
        
        Images *img = [dish.images firstObject];
        
        CGRect frame;
        frame.origin.x = self.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.frame.size;
        
        StorefrontImageView *image = [[StorefrontImageView alloc] initWithFrame:frame];
        image.dish = dish;
        image.controller = (StorefrontTableViewController *) self.img_delegate;
        
        image.clipsToBounds = YES;
        image.autoresizingMask = UIViewAutoresizingNone;
        [imageViews addObject:image];
        image.userInteractionEnabled = YES;
        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",img.url]]
              placeholderImage:[UIImage imageNamed:@"Default.png"]];
        image.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:image];
        if(i==0){
            [_img_delegate currentImageView:image];
        }
        i++;
    }
    if(i == 0){
        [self setupRestoImages];
    }
    self.contentSize = CGSizeMake(self.frame.size.width * ([self.subviews count] - 1), self.frame.size.height);
    self.pagingEnabled = YES;

}

-(void)setupRestoImages {
    self.delegate = self;
    imageViews = [[NSMutableArray alloc] init];
    int i = 0;
    for (Images *img in self.restaurant.images) {
        CGRect frame;
        frame.origin.x = self.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.frame.size;
        StorefrontImageView *image = [[StorefrontImageView alloc] initWithFrame:frame];
        image.clipsToBounds = YES;
        image.autoresizingMask = UIViewAutoresizingNone;
        [imageViews addObject:image];
        image.userInteractionEnabled = YES;
        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",img.url]]
              placeholderImage:[UIImage imageNamed:@"Default.png"]];
        image.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:image];
        if(i==0){
            [_img_delegate currentImageView:image];
        }
        i++;
    }
    self.contentSize = CGSizeMake(self.frame.size.width * ([self.subviews count] - 1), self.frame.size.height);
    self.pagingEnabled = YES;
}

-(void)setupDishImages {
    self.delegate = self;
    imageViews = [[NSMutableArray alloc] init];
    int i = 0;
    for (Images *img in self.dish.images) {
        CGRect frame;
        frame.origin.x = self.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.frame.size;
        StorefrontImageView *image = [[StorefrontImageView alloc] initWithFrame:frame];
        image.clipsToBounds = YES;
        image.autoresizingMask = UIViewAutoresizingNone;
        [imageViews addObject:image];
        image.userInteractionEnabled = NO;
        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",img.url]]
              placeholderImage:[UIImage imageNamed:@"Default.png"]];
        image.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:image];
        if(i==0){
            [_img_delegate currentImageView:image];
        }
        i++;
    }
    self.contentSize = CGSizeMake(self.frame.size.width * ([self.subviews count] - 1), self.frame.size.height);
    self.pagingEnabled = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(int) currentPage{
    CGFloat pageWidth = self.frame.size.width;
    return floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (([imageViews count] - 1) < [self currentPage]){
        return;
    }
    [_img_delegate currentImageView:[imageViews objectAtIndex:[self currentPage]]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (([imageViews count] - 1) < [self currentPage]){
        return;
    }
    [_img_delegate currentImageView:[imageViews objectAtIndex:[self currentPage]]];
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
        [self.nextResponder touchesMoved: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}

@end
