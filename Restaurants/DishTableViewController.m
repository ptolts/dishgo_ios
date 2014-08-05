//
//  DishTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 11/19/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "DishTableViewController.h"
#import "Dishes.h"
#import "DishTableViewCell.h"
#import "OptionsView.h"
#import "REFrostedViewController.h"
#import "MenuTableViewController.h"
#import "UIColor+Custom.h"
#import "SectionDishViewCell.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "Header.h"
#import "StorefrontImageView.h"
#import "UserSession.h"
#import "User.h"
#import "SetRating.h"


@interface DishTableViewController ()

@end

@implementation DishTableViewController {
    Dishes *dish;
    DishTableViewCell *dish_logic;
    bool editing;
    Header *header;
    int initialFrame;
    int initialImageHeight;
    StorefrontImageView *scroll_image_view;
    EDStarRating *starRatingImage;
    SignInStars *starRating;
}

- (void) preloadDishCell:(DishTableViewCell *) d{
    dish_logic = d;
    dish_logic.parent = self;
    self.restaurant = d.restaurant;
    dish = dish_logic.dish;
    editing = YES;
}

- (void) setupBackButtonAndCart {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]; // <-- Use your own image
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
    [backBtn setImage:backBtnImage];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    FAKFontAwesome *starIcon = [FAKFontAwesome starIconWithSize:25];
    starRating.backgroundColor = [UIColor scarletColor];
    starRating = [[SignInStars alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    starRating.vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
    starRating.navigationController = self.navigationController;
    [starIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    starRating.starImage = [starIcon imageWithSize:CGSizeMake(25, 25)];
    [starIcon addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor]];
    starRating.starHighlightedImage = [starIcon imageWithSize:CGSizeMake(25, 25)];
    starRating.maxRating = 5.0;
    starRating.delegate = self;
    starRating.horizontalMargin = 12;
    starRating.editable=YES;
//    displayMode=EDStarRatingDisplayFull;
    UserSession *session = [UserSession sharedManager];
    SetRating *rate = session.current_restaurant_ratings;
    if(rate && [[rate current_rating:self.dish.id] intValue] >= 0){
        starRating.rating = [[rate current_rating:self.dish.id] intValue];
    } else {
        starRating.rating = [self.dish.rating intValue];
    }
    [self.navigationItem setTitleView:starRating];
    self.navigationItem.titleView.backgroundColor = [UIColor almostBlackColor];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor scarletColor];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor almostBlackColor];
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    User *user = [[UserSession sharedManager] fetchUser];
    SetRating *setRating = [[SetRating alloc] init];
    setRating.dishgo_token = user.foodcloud_token;
    setRating.restaurant_id = self.restaurant.id;
    setRating.dish_id = self.dish.id;
    setRating.rating = [NSString stringWithFormat:@"%0.0f",rating];
    [setRating setRating];
}

-(void) myCustomBack {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    Header *head = header;
    
    head.backgroundColor = [UIColor clearColor];
    
    if(head.button_view_original_frame.size.height == 0){
        head.button_view_original_frame = CGRectMake(head.button_view.frame.origin.x,head.button_view.frame.origin.y,head.button_view.frame.size.width,head.button_view.frame.size.height);
    }
    
    if(head.scroll_view_original_frame.size.height == 0){
        head.scroll_view_original_frame = CGRectMake(head.scroll_view.frame.origin.x,head.scroll_view.frame.origin.y,head.scroll_view.frame.size.width,head.scroll_view.frame.size.height);
    }
    
    if(initialFrame == 0){
        initialFrame = self.tableView.tableHeaderView.frame.size.height;
    }
    
    scroll_image_view.contentMode = UIViewContentModeScaleAspectFill;
    
    CGFloat yPos = -scrollView.contentOffset.y;
    if (yPos >= 0) {
        CGRect imgRect = head.frame;
        imgRect.origin.y = scrollView.contentOffset.y;
        imgRect.size.height = initialFrame+yPos;
        head.frame = imgRect;
        
        imgRect = head.scroll_view_original_frame;
        imgRect.size.height += yPos;
        imgRect.origin.y = scrollView.contentOffset.y;
        head.scroll_view.frame = imgRect;
        
        imgRect = scroll_image_view.frame;
        imgRect.size.height = initialImageHeight + yPos;
        scroll_image_view.frame = imgRect;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.view.autoresizingMask = UIViewAutoresizingNone;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupViews];

    [self setupBackButtonAndCart];    
    
    self.tableView.backgroundColor = [UIColor bgColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    int tots = 0;
    for(DishTableViewCell *d in self.shoppingCart){
        tots += (int) d.dishFooterView.stepper.value;
    }
    [self.cart setCount:[NSString stringWithFormat:@"%d", tots]];
    
    if([self.dish.images count] > 0){
        header = [[[NSBundle mainBundle] loadNibNamed:@"Header" owner:self options:nil] objectAtIndex:0];
        [header.button_view removeFromSuperview];
        header.label.text = self.restaurant.name;
        header.label.font = [UIFont fontWithName:@"JosefinSans-Bold" size:25.0f];
        header.scroll_view.dish = self.dish;
        header.scroll_view.img_delegate = self;
        [header.scroll_view setupDishImages];
        header.autoresizingMask = UIViewAutoresizingNone;
        header.scroll_view.autoresizingMask = UIViewAutoresizingNone;
        header.button_view.backgroundColor = [UIColor complimentaryBg];
        header.spacer.backgroundColor = [UIColor seperatorColor];
        header.spacer2.backgroundColor = [UIColor seperatorColor];
        header.backgroundColor = [UIColor almostBlackColor];
        [header.gradient removeFromSuperview];
        CGRect frame = header.frame;
        frame.size.height -= 98;
        header.frame = frame;
        header.scroll_view.frame = frame;
//        header.clipsToBounds = YES;
        self.tableView.tableHeaderView = header;
    }
}

//-(void) viewDidAppear:(BOOL)animated {
//    [self.shoppingCart saveShoppingCart];
//}

- (void) currentImageView:(StorefrontImageView *)current {
    if(current == scroll_image_view){
        return;
    }
    scroll_image_view = current;
    initialImageHeight = current.frame.size.height;
}

-(void) setupViews{
    
    int junkHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    // IF THE VIEW ISNT EDITING FROM THE CART, WE NEED TO BUILD ALL THE VIEWS;
    if(dish_logic == nil) {
        dish = self.dish;
        dish_logic = [[[NSBundle mainBundle] loadNibNamed:@"DishTableViewCell" owner:self options:nil] objectAtIndex:0];
        dish_logic.dish = dish;
        dish_logic.restaurant = self.restaurant;
        dish_logic.dishTitle.text = dish.name;
        dish_logic.parent = self;
        dish_logic.backgroundColor = [UIColor almostBlackColor];
        dish_logic.priceLabel.backgroundColor = [UIColor bgColor];
        [dish_logic setupLowerHalf];
    }
    
    [dish_logic.priceLabel.layer setCornerRadius:5.0f];    
    CGRect frame = dish_logic.dishFooterView.frame;
    frame.origin.y = junkHeight - frame.size.height;
    dish_logic.dishFooterView.frame = frame;
    
    CGRect make = CGRectMake(0, (dish_logic.frame.origin.y + dish_logic.frame.size.height), 320, junkHeight - dish_logic.dishFooterView.frame.size.height - dish_logic.frame.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:make style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview: dish_logic.dishFooterView];
    [self.view addSubview: dish_logic];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!dish_logic){
        [self setupViews];
    }
    return dish_logic.lower_half;
}

-(void)addDish:(DishTableViewCell *)dish_cell
{
    [self.shoppingCart addObjectThenSave:dish_cell];
//    [self.shoppingCart saveShoppingCart];
    [self.cart setCount:[NSString stringWithFormat:@"%lu", (unsigned long)[self.shoppingCart count]]];
}

- (void)cartClick:sender
{
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping = YES;
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping_cart = self.shoppingCart;
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).restaurant = self.restaurant;
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    [self.frostedViewController presentMenuViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!dish_logic){
        [self setupViews];
    }
    return dish_logic.lower_half.full_height;
}



@end
