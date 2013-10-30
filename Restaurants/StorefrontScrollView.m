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

-(void)setupImages {
    int i = 0;
    for (Images *img in self.restaurant.images) {
        CGRect frame;
        frame.origin.x = self.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.frame.size;
        
        StorefrontImageView *image = [[StorefrontImageView alloc] initWithFrame:frame];
        image.userInteractionEnabled = NO;
        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://dev.foodcloud.ca:3000/assets/sources/%@",img.url]]
              placeholderImage:[UIImage imageNamed:@"Default.png"]];
        image.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:image];
//        [self sendSubviewToBack:image];
        i++;
    }
    self.contentSize = CGSizeMake(self.frame.size.width * [self.subviews count], self.frame.size.height);
    self.pagingEnabled = YES;
    NSLog(@"Total Views: %d",self.subviews.count);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
