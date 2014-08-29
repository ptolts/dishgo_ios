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
#import <JSONHTTPClient.h>
#import "User.h"
#import "Constant.h"
#import "UploadImage.h"
#import "SexyView.h"
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
    SetRating *starRatingObject;
    StorefrontImageView *scroll_image_view;
    EDStarRating *starRatingImage;
    SignInStars *starRating;
    SetRating *rate;
    
    User *user;
    Dishes *camera_dish;
    SectionDishViewCell *camera_cell;
    UploadImage *up_img;
}

- (IBAction)takePhoto:(UITapGestureRecognizer *)sender {
    if(![[UserSession sharedManager] logged_in]){
        SignInViewController *signin = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
        [self.navigationController pushViewController:signin animated:YES];
        return;
    }
    camera_dish = self.dish;
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void) captureImageDidFinish:(UIImage *)chosenImage withMetadata:(NSDictionary *)metadata
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage,1.0);
    NSString *imageDataEncodedeString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    SexyView *progress_view = [[SexyView alloc] init];
    progress_view.radius = 100;
    progress_view.progressBorderThickness = -10;
    progress_view.trackColor = [UIColor blackColor];
    progress_view.progressColor = [UIColor whiteColor];
    progress_view.imageToUpload = chosenImage;
    
    up_img = [[UploadImage alloc] init];
    up_img.dish = camera_dish;
    up_img.progress_view = progress_view;
    up_img.dishgo_token = user.dishgo_token;
    up_img.uitableview = self;
    up_img.raw_image_data = imageData;
    up_img.restaurant_id = self.restaurant.id;
    up_img.image_data = imageDataEncodedeString;
    up_img.dish_id = camera_dish.id;
    [progress_view show];
    [up_img startUploadAfn];
}

- (void) preloadDishCell:(DishTableViewCell *) d{
    dish_logic = d;
    dish_logic.parent = self;
    self.restaurant = d.restaurant;
    dish = dish_logic.dish;
    editing = YES;
}

- (void) setupBackButtonAndCart {
    FAKFontAwesome *back = [FAKFontAwesome chevronLeftIconWithSize:22.0f];
    [back addAttribute:NSForegroundColorAttributeName value:[UIColor scarletColor]];
    UIImage *image = [back imageWithSize:CGSizeMake(32.0,32.0)];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(myCustomBack) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:item];
    
    FAKFontAwesome *starIcon = [FAKFontAwesome starIconWithSize:25];
    starRating.backgroundColor = [UIColor scarletColor];
    starRating = [[SignInStars alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    starRating.vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
    starRating.navigationController = self.navigationController;
    [starIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    starRating.starImage = [starIcon imageWithSize:CGSizeMake(25, 25)];
    [starIcon addAttribute:NSForegroundColorAttributeName value:[UIColor starColor]];
    starRating.starHighlightedImage = [starIcon imageWithSize:CGSizeMake(25, 25)];
    starRating.maxRating = 5.0;
    starRating.delegate = self;
    starRating.horizontalMargin = 12;
    starRating.editable=YES;
//    displayMode=EDStarRatingDisplayFull;
    UserSession *session = [UserSession sharedManager];
    rate = session.current_restaurant_ratings;
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
    starRatingObject = [[SetRating alloc] init];
    starRatingObject.dishgo_token = user.dishgo_token;
    starRatingObject.restaurant_id = self.restaurant.id;
    starRatingObject.dish_id = self.dish.id;
    starRatingObject.rating = [NSString stringWithFormat:@"%0.0f",rating];
    [starRatingObject setRating];
    self.dish.rating = [NSNumber numberWithFloat:rating];
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
    
    [self logDishView];
    
    [self setupHeader];
    
    user = [[UserSession sharedManager] fetchUser];
}

- (void) logDishView {
    User *u = [[UserSession sharedManager] fetchUser];
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@/app/api/v1/dish/log_view?dish_id=%@&dishgo_token=%@",dishGoUrl,self.dish.id,u.dishgo_token]
                                       params:nil
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       NSLog(@"Logged Dish View");
                                   }];
}

-(void) setupHeader {
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
        frame.size.height -= 82;
        header.frame = frame;
        //        header.scroll_view.frame = frame;
        //        header.clipsToBounds = YES;
        self.tableView.tableHeaderView = header;
    } else {
        UIView *upload_pic = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,250)];
        FAKFontAwesome *camera = [FAKFontAwesome cameraIconWithSize:75.0f];
        [camera addAttribute:NSForegroundColorAttributeName value:[UIColor almostBlackColor]];
        UIImage *cam = [camera imageWithSize:CGSizeMake(250.0f, 250.0f)];
        UIImageView *c = [[UIImageView alloc] initWithImage:cam];
        [upload_pic addSubview:c];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
        [c addGestureRecognizer:tap];
        c.userInteractionEnabled = YES;
        c.contentMode = UIViewContentModeCenter;
        CGRect frame = c.frame;
        frame.origin.x = (self.view.frame.size.width / 2) - (frame.size.width / 2);
        c.frame = frame;
        self.tableView.tableHeaderView = upload_pic;
    }
}

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
    
//    CGRect make = CGRectMake(0, (dish_logic.frame.origin.y + dish_logic.frame.size.height), 320, junkHeight - dish_logic.dishFooterView.frame.size.height - dish_logic.frame.size.height);
    CGRect make = CGRectMake(0, (dish_logic.frame.origin.y + dish_logic.frame.size.height), 320, junkHeight - dish_logic.frame.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:make style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
//    [self.view addSubview: dish_logic.dishFooterView];
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
