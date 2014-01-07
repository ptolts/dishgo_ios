//
//  DishViewCell.m
//  Restaurants
//
//  Created by Philip Tolton on 10/31/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "DishViewCell.h"

@implementation DishViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) trackPage {
    self.page_tracker = [[UIPageControl alloc] initWithFrame:CGRectMake(0,0,50,50)];
    self.page_tracker.center = self.contentView.center;
    CGRect frame = self.page_tracker.frame;
    frame.origin.y = self.frame.size.height - 5 - frame.size.height;
    self.page_tracker.userInteractionEnabled = NO;
    self.page_tracker.frame = frame;
    self.page_tracker.pageIndicatorTintColor = [UIColor textColor];
    self.page_tracker.currentPageIndicatorTintColor = [UIColor scarletColor];
    self.page_tracker.numberOfPages = self.dishScrollView.total_pages;
    NSLog(@"Total Pages: %d",self.dishScrollView.total_pages);
    self.page_tracker.currentPage = 0;
    self.dishScrollView.delegate = self;
    [self addSubview:self.page_tracker];
    [self bringSubviewToFront:self.page_tracker];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.page_tracker.currentPage = [self.dishScrollView currentPage]; // you need to have a **iVar** with getter for pageControl
}

@end
