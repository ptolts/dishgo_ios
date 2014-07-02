//
//  SectionTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "SectionTableViewController.h"
#import "Sections.h"
//#import "Subsections.h"
#import "Options.h"
#import "TableHeaderView.h"
#import "Dishes.h"
#import "Option.h"
#import "DishTableViewCell.h"
#import "Options.h"
#import "REFrostedViewController.h"
#import "MenuTableViewController.h"
#import "OptionsView.h"
#import "DishView.h"
#import "DishTableViewController.h"
#import "SectionDishViewCell.h"
#import "CartButton.h"
#import "UserSession.h"
#import "Images.h"
#import "FontAwesomeKit/FAKFontAwesome.h"
#import "CameraButton.h"
#import "UIColor+Custom.h"
#import "User.h"
#import "UploadImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import "TWRBorderedView.h"

#define DEFAULT_SIZE 275
#define SECOND_SIZE 160
#define HEADER_DEFAULT_SIZE 45

@interface SectionTableViewController ()

@end

@implementation SectionTableViewController

    NSMutableArray *subsectionList;
    NSMutableDictionary *heights;
    Dishes *selected_dish;
    Dishes *camera_dish;
    SectionDishViewCell *camera_cell;
    User *user;
    UploadImage *up_img;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    _KVOController = KVOController;
    return self;
}


- (IBAction)takePhoto:(UITapGestureRecognizer *)sender {
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    CameraButton *but = (CameraButton *) sender.view;
    camera_dish = but.dish;
    camera_cell = but.parent_cell;
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
//    [self presentViewController:picker animated:YES completion:NULL];
    
}

-(void) test {
    NSLog(@"boobbbbbs");
}

- (void) captureImageDidFinish:(UIImage *)chosenImage withMetadata:(NSDictionary *)metadata
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage,1.0);
    NSString *imageDataEncodedeString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    up_img = [[UploadImage alloc] init];
    up_img.section_dish_view = camera_cell;
    camera_cell.progress.hidden = NO;
    camera_cell.dishDescription.hidden = YES;
    camera_cell.dishImage.hidden = YES;
    camera_cell.dishImage.image = chosenImage;
    up_img.dishgo_token = user.foodcloud_token;
    up_img.raw_image_data = imageData;
    up_img.restaurant_id = self.restaurant.id;
    up_img.image_data = imageDataEncodedeString;
    up_img.dish_id = camera_dish.id;
    [up_img startUploadAfn];
}

- (void) setupBackButtonAndCart {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]; // <-- Use your own image
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
    [backBtn setImage:backBtnImage];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = -16;// it was -6 in iOS 6
//    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, backBtn, nil] animated:NO];
    //	self.navigationItem.leftBarButtonItem = backBtn;
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    
    CartButton *cartButton = [[CartButton alloc] init];
    [cartButton.button addTarget:self action:@selector(cartClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:cartButton.button];
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, customItem, nil] animated:NO];
    [self.navigationItem setRightBarButtonItem:customItem];
    //    self.navigationItem.rightBarButtonItem = customItem;
    self.cart = cartButton;
}

-(void) myCustomBack {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBackButtonAndCart];
    
    user = [[UserSession sharedManager] fetchUser];
    heights = [[NSMutableDictionary alloc] init];
    subsectionList = [[NSMutableArray alloc] init];
    [subsectionList addObject:self.section];
    int current_page_section = 0;
    int current_page_dish_count = 0;
    int counter = 1;
    int row = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:current_page_section] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    self.tableView.backgroundColor = [UIColor bgColor];
}

-(void) viewDidAppear:(BOOL)animated {
    if([self.shoppingCart count] != 0){
        int tots = 0;
        for(DishTableViewCell *d in self.shoppingCart){
            tots += (int) d.dishFooterView.stepper.value;
        }
        [self.cart setCount:[NSString stringWithFormat:@"%d", tots]];
    } else {
        [self.cart setCount:@"0"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cartClick:sender
{
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping = YES;
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping_cart = self.shoppingCart;
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).restaurant = self.restaurant;
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    [self.frostedViewController presentMenuViewController];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // unwrap the controller if it's embedded in the nav controller.
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    
    if ([segue.destinationViewController isKindOfClass:[DishTableViewController class]]) {
        DishTableViewController *vc = (DishTableViewController *)controller;
        vc.shoppingCart = self.shoppingCart;
        vc.restaurant = self.restaurant;
        vc.dish = selected_dish;
    } else {
        NSLog(@"Class: %@",segue.destinationViewController);
        NSAssert(NO, @"Unknown segue. All segues must be handled.");
    }
    
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Dishes *dish = [((Subsections *)[subsectionList objectAtIndex:indexPath.section]).dishes.array objectAtIndex:indexPath.row];
    Dishes *dish = [_section.dishes.array objectAtIndex:indexPath.row];
    SectionDishViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SectionDishViewCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.dish = dish;

    cell.dishTitle.text = dish.name;
    cell.dishTitle.font = [UIFont fontWithName:@"Josefin Sans" size:18.0f];
    cell.dishDescription.text = dish.description_text;
    [cell.dishDescription setFont:[UIFont fontWithName:@"Merriweather Regular" size:16.0f]];
    
    CGSize maxSize = CGSizeMake(280.0f, CGFLOAT_MAX);
    CGSize requiredSize = [cell.dishDescription sizeThatFits:maxSize];
    CGRect descFrame = CGRectMake(20, 30, 280.0f, requiredSize.height);
    cell.dishDescription.frame = descFrame;
    
    cell.dishTitle.textColor = [UIColor textColor];
    cell.seperator.backgroundColor = [UIColor seperatorColor];
    cell.seperator2.backgroundColor = [UIColor seperatorColor];
    
    NSLog(@"owned_resto_id: %@",user.owns_restaurant_id);
    NSLog(@"resto_id: %@",self.restaurant.id);
    
    
    NSMutableAttributedString *attributionMas = [[NSMutableAttributedString alloc] init];
    FAKFontAwesome *info = [FAKFontAwesome infoIconWithSize:20.0f];
    [info addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    [attributionMas appendAttributedString:[info attributedString]];
    cell.plus.attributedText = attributionMas;
    cell.plus.layer.cornerRadius = 15.0f;
    cell.plus.layer.borderWidth = 1.0f;
    cell.plus.backgroundColor = [[UIColor bgColor] colorWithAlphaComponent:0.9f];
    cell.plus.layer.borderColor = [UIColor seperatorColor].CGColor;

    
    NSMutableAttributedString *attributionStars = [[NSMutableAttributedString alloc] init];
    FAKFontAwesome *star = [FAKFontAwesome starIconWithSize:15.0f];
    NSNumber *total_rating_num = dish.rating;
    [star addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor]];
    for(int i=0;i<[total_rating_num intValue];i++){
        [attributionStars appendAttributedString:[star attributedString]];
    }
    [star addAttribute:NSForegroundColorAttributeName value:[UIColor seperatorColor]];
    int left_over_stars = 5 - [total_rating_num intValue];
    for(int i=0;i<left_over_stars;i++){
        [attributionStars appendAttributedString:[star attributedString]];
    }
    cell.rating_label.attributedText = attributionStars;
    
    
    NSMutableAttributedString *attributionCamera = [[NSMutableAttributedString alloc] init];
    FAKFontAwesome *cam = [FAKFontAwesome cameraIconWithSize:20.0f];
    [cam addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    [attributionCamera appendAttributedString:[cam attributedString]];
    cell.camera.attributedText = attributionCamera;
    cell.camera.layer.cornerRadius = 20.0f;
//    cell.camera.layer.borderWidth = 1.0f;
    cell.camera.backgroundColor = [[UIColor bgColor] colorWithAlphaComponent:0.9f];
//    cell.camera.layer.borderColor = [UIColor seperatorColor].CGColor;
    
    if([user.owns_restaurant_id isEqualToString:self.restaurant.id] || user.is_admin){
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
        [cell.camera_view setUserInteractionEnabled:YES];
        [cell.camera_view addGestureRecognizer:gesture];
        cell.camera_view.dish = dish;
        cell.camera_view.parent_cell = cell;
        [cell bringSubviewToFront:cell.camera_view];
    } else {
        [cell.camera_view removeFromSuperview];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSMutableArray *range = [dish priceRange];
    float high = [range[1] floatValue];
    float low = [range[0] floatValue];
    
    if([[NSNumber numberWithFloat:low] intValue] == 0 && [[NSNumber numberWithFloat:high] intValue] == 0){
        cell.priceLabel.text = @"NA";
    } else if([[NSNumber numberWithFloat:low] intValue] == 0){
        cell.priceLabel.text = [NSString stringWithFormat:@"$%.0f",high];
    } else if([[NSNumber numberWithFloat:high] intValue] == 0){
        cell.priceLabel.text = [NSString stringWithFormat:@"$%.0f",low];
    } else {
        cell.priceLabel.text = [NSString stringWithFormat:@"$%.0f-%.0f",low,high];
    }
    
    
    cell.priceLabel.font = [UIFont fontWithName:@"Josefin Sans" size:18.0f];
    cell.dish = dish;
    cell.dishImage.clipsToBounds = YES;
    cell.full_height = cell.contentView.frame.size.height;
    cell.backgroundColor = [UIColor bgColor];
    if([dish.images count] > 0){
        [cell.dishDescription removeFromSuperview];
        [cell.seperator removeFromSuperview];
        Images *img = [dish.images firstObject];
        __weak typeof(cell.dishImage) weakImage = cell.dishImage;
        [cell.dishImage          setImageWithURL:[NSURL URLWithString:img.url]
                           placeholderImage:[UIImage imageNamed:@"camera_mark.png"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      if (image && cacheType == SDImageCacheTypeNone)
                                      {
                                          weakImage.alpha = 0.0;
                                          [UIView animateWithDuration:1.0
                                                           animations:^{
                                                               weakImage.alpha = 1.0;
                                                           }];
                                      }
                                  }
         ];
    } else {
        cell.dishImage.hidden = YES;
    }
    cell.clipsToBounds = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionDishViewCell *c = (SectionDishViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    selected_dish = c.dish;
    NSLog(@"FRAME: %@",CGRectCreateDictionaryRepresentation(c.dishImage.frame));
    [self performSegueWithIdentifier:@"dishSelectClick" sender:self];
//    [tableView beginUpdates];
//    NSString *key = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
//    if([[heights valueForKey:key] doubleValue] == DEFAULT_SIZE){
//        DishTableViewCell *c = (DishTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//        int size = c.full_height;
//        for(id kkey in [heights allKeys]) {
//            [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:kkey];
//        }
//        [heights setObject:[NSNumber numberWithInteger:size] forKey:key];
//    } else {
//        [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:key];
//    }
//    [tableView endUpdates];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if ([[subsectionList objectAtIndex:sectionIndex] isKindOfClass:[Sections class]]){
        return [self headerView:sectionIndex tableView:tableView];
    }
//    else if ([[subsectionList objectAtIndex:sectionIndex] isKindOfClass:[Subsections class]]){
//        return [self subheaderView:sectionIndex tableView:tableView];
//    }
    else {
        return nil;
    }
}

- (UIView *) headerView:(NSInteger)sectionIndex tableView:(UITableView *)tableView
{
    Sections *section = [subsectionList objectAtIndex:sectionIndex];
    if([section.name length] == 0){
        return nil;
    }
    
    TableHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] objectAtIndex:0];
    view.headerTitle.text = section.name;
    //    view.headerTitle.font = [UIFont fontWithName:@"Copperplate-Bold" size:20.0f];
    view.headerTitle.font = [UIFont fontWithName:@"Josefin Sans" size:22.0f];
    view.headerTitle.textColor = [UIColor textColor];
    view.headerTitle.backgroundColor = [UIColor bgColor];
    [view.headerTitle sizeToFit];
    CGRect frame = view.headerTitle.frame;
    frame.size.width += 20;
    view.headerTitle.frame = frame;
    view.headerTitle.center = view.center;
    view.backgroundColor = [UIColor bgColor];
    
    CGRect borderedViewRect = CGRectMake(0, view.frame.size.height - 1, 320, 1);
    TWRBorderMask mask = TWRBorderMaskBottom;
    TWRBorderedView *borderedView = [[TWRBorderedView alloc] initWithFrame:borderedViewRect
                                                               borderWidth:1.0f
                                                                     color:[UIColor seperatorColor]
                                                                   andMask:mask];
    [view  addSubview:borderedView];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"header_line.png"]];
//    [view addSubview:imageView ];
//    [view sendSubviewToBack:imageView ];
    return view;
    
}

//- (UIView *) subheaderView:(NSInteger)sectionIndex tableView:(UITableView *)tableView
//{
//    Subsections *section = [subsectionList objectAtIndex:sectionIndex];
//    if([section.name length] == 0){
//        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
//    }
//    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    //    view.backgroundColor = [UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0];
//    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    //    label.text = section.name;
//    //    label.font = [UIFont systemFontOfSize:15];
//    //    label.textColor = [UIColor whiteColor];
//    //    label.backgroundColor = [UIColor clearColor];
//    //    [label sizeToFit];
//    //    [view addSubview:label];
//    
//    TableHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] objectAtIndex:0];
//    view.headerTitle.text = section.name;
//    return view;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Dishes *dish = [((Subsections *)[subsectionList objectAtIndex:indexPath.section]).dishes.array objectAtIndex:indexPath.row];
    Dishes *dish = [_section.dishes.array objectAtIndex:indexPath.row];
    if([dish.images count] > 0){
        return DEFAULT_SIZE;
    } else {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.text = dish.description_text;
        [label setFont:[UIFont fontWithName:@"Newtext RG Bt" size:16.0f]];
        CGSize maxSize = CGSizeMake(280.0f, CGFLOAT_MAX);
        CGSize requiredSize = [label sizeThatFits:maxSize];
        return requiredSize.height + 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
//    Subsections *section = [subsectionList objectAtIndex:sectionIndex];
//    if([section.name length] == 0){
//        return 0;
//    }
    
    return HEADER_DEFAULT_SIZE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [subsectionList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    // Return the number of rows in the section.
//    
//    if([[subsectionList objectAtIndex:section] isKindOfClass:[Subsections class]]){
//        return [((Subsections *)[subsectionList objectAtIndex:section]).dishes count];
//    }

    return [_section.dishes count];
    
//    return 0;

    
}

@end
