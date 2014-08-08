//
//  DishSearchTableViewController.m
//  DishGo
//
//  Created by Philip Tolton on 2014-07-31.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "DishSearchTableViewController.h"
#import "Dishes.h"
#import "SectionDishViewCell.h"
#import <FAKFontAwesome.h>
#import "SetRating.h"
#import "UserSession.h"
#import "DishTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SexyView.h"
#import "UploadImage.h"
#import <DBCameraContainerViewController.h>

@interface DishSearchTableViewController ()

@end

@implementation DishSearchTableViewController

BOOL isSearching;
NSString *searchTxt;
NSArray *filteredDishList;
NSArray *dishList;
UserSession *session;
Dishes *selected_dish;
int sortBy;
SetRating *rate;
UploadImage *up_img;
User *user;
Dishes *camera_dish;
SectionDishViewCell *camera_cell;

#define DEFAULT_SIZE 235
#define SECOND_SIZE 160
#define HEADER_DEFAULT_SIZE 10


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)filteredDishes {
    
    if([searchTxt length] != 0) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchTxt];
        filteredDishList = [dishList filteredArrayUsingPredicate:resultPredicate];
    } else {
        filteredDishList = dishList;
    }
    
    NSSortDescriptor *sortByRating = [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByRating];
    
    switch(sortBy)
    {
        case 0:
            filteredDishList = [filteredDishList sortedArrayUsingDescriptors:sortDescriptors];
            break;
        default:
            
            break;
    }
    
//    if(isOpened){
//        NSPredicate *testForTrue = [NSPredicate predicateWithFormat:@"isOpened == 1"];
//        filteredDishList = [filteredDishList filteredArrayUsingPredicate:testForTrue];
//    }
//    
//    if(doesDelivery){
//        NSPredicate *testForTrue = [NSPredicate predicateWithFormat:@"does_delivery == 1"];
//        filteredDishList = [filteredDishList filteredArrayUsingPredicate:testForTrue];
//    }
    
    [self.tableView reloadData];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText length] != 0) {
        isSearching = YES;
        searchTxt = searchText;
        [self filteredDishes];
    }
    else {
        isSearching = NO;
        searchTxt = @"";
        [self filteredDishes];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchTxt = @"";
    [self filteredDishes];
    isSearching = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISearchDisplayController *mySearchDisplayController;
    self.search_bar = mySearchDisplayController;
    self.bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 250, 0)];
    self.bar.tintColor = [UIColor scarletColor];
    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.bar contentsController:self];
    mySearchDisplayController.delegate = self;
    mySearchDisplayController.searchResultsDataSource = self;
    mySearchDisplayController.searchResultsDelegate = self;
    self.bar.delegate = self;
    [self setSearch_bar:mySearchDisplayController];
    
    UITextField *txfSearchField = [self.bar valueForKey:@"_searchField"];
    //    [txfSearchField setBackgroundColor:[[UIColor scarletColor] colorWithAlphaComponent:0.95]];
    [txfSearchField setLeftView:UITextFieldViewModeNever];
    [txfSearchField setBorderStyle:UITextBorderStyleRoundedRect];
    txfSearchField.layer.borderWidth = 1.0f;
    txfSearchField.layer.cornerRadius = 5.0f;
    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;
    
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.bar];
    self.navigationItem.rightBarButtonItem = searchBarItem;
    
    if(!session){
        session = [UserSession sharedManager];
    }
    rate = session.current_restaurant_ratings;
    user = [session fetchUser];
    dishList = [[self.restaurant dishList] copy];
    filteredDishList = dishList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredDishList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    Dishes *dish = [((Subsections *)[subsectionList objectAtIndex:indexPath.section]).dishes.array objectAtIndex:indexPath.row];
    Dishes *dish = [filteredDishList objectAtIndex:indexPath.row];
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

- (IBAction)takePhoto:(UITapGestureRecognizer *)sender {
    if(![[UserSession sharedManager] logged_in]){
        SignInViewController *signin = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
        [self.navigationController pushViewController:signin animated:YES];
        return;
    }
    CameraButton *but = (CameraButton *) sender.view;
    camera_dish = but.dish;
    camera_cell = but.parent_cell;
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
    //    [self presentViewController:picker animated:YES completion:NULL];
    
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
    up_img.uitableview = self;
    up_img.progress_view = progress_view;
    up_img.dishgo_token = user.foodcloud_token;
    up_img.raw_image_data = imageData;
    up_img.restaurant_id = self.restaurant.id;
    up_img.image_data = imageDataEncodedeString;
    up_img.dish_id = camera_dish.id;
    [progress_view show];
    [up_img startUploadAfn];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Dishes *dish = [filteredDishList objectAtIndex:indexPath.row];
    SectionDishViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SectionDishViewCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.dish = dish;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 5.0f);
    cell.progress.transform = transform;
    
    cell.dishTitle.text = dish.name;
    cell.dishTitle.font = [UIFont fontWithName:@"JosefinSans-Bold" size:20.0f];
    cell.dishDescription.text = dish.description_text;
    
    [cell.dishDescription setFont:[UIFont fontWithName:@"Merriweather" size:14.0f]];
    
    CGSize maxSize = CGSizeMake(304.0f, CGFLOAT_MAX);
    CGSize requiredSize = [cell.dishDescription sizeThatFits:maxSize];
    CGRect descFrame = CGRectMake(8, 30, 304.0f, requiredSize.height);
    cell.dishDescription.frame = descFrame;
    
    cell.dishTitle.textColor = [UIColor textColor];
    cell.seperator.backgroundColor = [UIColor seperatorColor];
    cell.seperator2.backgroundColor = [UIColor seperatorColor];
    
    //    NSLog(@"owned_resto_id: %@",user.owns_restaurant_id);
    //    NSLog(@"resto_id: %@",self.restaurant.id);
    
    NSMutableAttributedString *attributionMas = [[NSMutableAttributedString alloc] init];
    FAKFontAwesome *info = [FAKFontAwesome infoIconWithSize:15.0f];
    [info addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    [attributionMas appendAttributedString:[info attributedString]];
    cell.plus.attributedText = attributionMas;
    cell.plus.layer.cornerRadius = 15.0f;
    
    cell.plus.backgroundColor = [[UIColor bgColor] colorWithAlphaComponent:0.9f];
    cell.plus.layer.borderColor = [UIColor seperatorColor].CGColor;
    
    
    NSMutableAttributedString *attributionStars = [[NSMutableAttributedString alloc] init];
    FAKFontAwesome *star = [FAKFontAwesome starIconWithSize:15.0f];
    
    NSNumber *total_rating_num = dish.rating;
    
    if(rate && [[rate current_rating:dish.id] intValue] >= 0){
        total_rating_num = [rate current_rating:dish.id];
    } else {
        total_rating_num = dish.rating;
    }
    
    [star addAttribute:NSForegroundColorAttributeName value:[UIColor starColor]];
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
    FAKFontAwesome *cam = [FAKFontAwesome cameraIconWithSize:15.0f];
    [cam addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    [attributionCamera appendAttributedString:[cam attributedString]];
    cell.camera.attributedText = attributionCamera;
    cell.camera.layer.cornerRadius = 15.0f;
    cell.camera.backgroundColor = [[UIColor bgColor] colorWithAlphaComponent:0.9f];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    [cell.camera_view setUserInteractionEnabled:YES];
    [cell.camera_view addGestureRecognizer:gesture];
    cell.camera_view.dish = dish;
    cell.camera_view.parent_cell = cell;
    [cell bringSubviewToFront:cell.camera_view];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if([dish.sizes boolValue]){
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
    } else {
        if([dish.price intValue] == 0){
            cell.priceLabel.text = @"Ask";
        } else {
            cell.priceLabel.text = [NSString stringWithFormat:@"$%.0f",[dish.price floatValue]];
        }
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
        cell.dishTitle.textColor = [UIColor whiteColor];
    } else {
        cell.dishImage.hidden = YES;
        cell.gradient.hidden = YES;
        cell.dishTitle.textColor = [UIColor blackColor];
    }
    cell.clipsToBounds = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionDishViewCell *c = (SectionDishViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    selected_dish = c.dish;
    [self performSegueWithIdentifier:@"dishSelectClick" sender:self];
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
@end
