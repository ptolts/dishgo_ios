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

@implementation StorefrontScrollView

    NSMutableArray *imageViews;

-(void)setupImages {
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
@end
