//
//  DishViewCell.m
//  Restaurants
//
//  Created by Philip Tolton on 10/31/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "DishViewCell.h"
#import "DishTableViewController.h"
#import "StorefrontTableViewController.h"
#import <SMPageControl/SMPageControl.h>

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
    self.page_tracker = [[SMPageControl alloc] initWithFrame:CGRectMake(0,0,50,50)];
    self.page_tracker.numberOfPages = self.dishScrollView.total_pages;
    if(self.dishScrollView.total_pages < 10){
        self.page_tracker.indicatorMargin = 5.0f;
        self.page_tracker.indicatorDiameter = 5.0f;
    } else {
        self.page_tracker.indicatorMargin = 3.0f;
        self.page_tracker.indicatorDiameter = 3.0f;
    }
    [self.page_tracker sizeToFit];
    self.page_tracker.center = self.contentView.center;
    CGRect frame = self.page_tracker.frame;
    frame.origin.y = self.frame.size.height - frame.size.height + 2;
    self.page_tracker.userInteractionEnabled = NO;
    self.page_tracker.frame = frame;
    self.page_tracker.pageIndicatorTintColor = [UIColor textColor];
    self.page_tracker.currentPageIndicatorTintColor = [UIColor scarletColor];

    self.page_tracker.currentPage = 0;
    self.dishScrollView.delegate = self;
    [self addSubview:self.page_tracker];
    [self bringSubviewToFront:self.page_tracker];
    
    self.plus.layer.cornerRadius = 3.0f;
    self.plus.backgroundColor = [UIColor textColor];
    self.plus.layer.borderWidth = 1.0f;
    self.plus.layer.borderColor = [UIColor textColor].CGColor;
    
    self.see_more.layer.cornerRadius = 3.0f;
    self.see_more.backgroundColor = [UIColor textColor];
    self.see_more.layer.borderWidth = 1.0f;
    self.see_more.layer.borderColor = [UIColor textColor].CGColor;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupDish)];
    self.plus.clipsToBounds = YES;
    //    self.plus.backgroundColor = [UIColor scarletColor];
    singleTap.numberOfTapsRequired = 1;
    self.plus.userInteractionEnabled = YES;
    [self.plus_area addGestureRecognizer:singleTap];
    [self bringSubviewToFront:self.plus_area];
    
}

-(void)setupDish{
    DishTableViewController *vc = [_controller.storyboard instantiateViewControllerWithIdentifier:@"dishEditViewController"];
    vc.shoppingCart = _controller.shoppingCart;
    vc.dish = [self.dishScrollView currentDish];
    [_controller.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.page_tracker.currentPage = [self.dishScrollView currentPage]; // you need to have a **iVar** with getter for pageControl
}

@end
