//
//  StorefrontTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 10/29/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "StorefrontTableViewController.h"
#import "Header.h"
#import "Footer.h"
#import "RAppDelegate.h"
#import <RestKit/RestKit.h>
#import "Dishes.h"
#import "Option.h"
#import "Options.h"
#import "Sections.h"
#import "User.h"
#import "Order_Order.h"
#import "DishViewCell.h"
#import "TableHeaderView.h"
#import "SectionTableViewController.h"
#import "Constant.h"
#import "REFrostedViewController.h"
#import "MenuTableViewController.h"
#import "DishScrollView.h"
#import "DishTableViewCell.h"
#import "UIColor+Custom.h"
#import "ContactViewController.h"
#import "LEColorPicker.h"
#import "UserSession.h"
#import "DishCellClean.h"
#import "PrizesController.h"
#import <GAI.h>
#import "DishSearchTableViewController.h"
#import "DishCoinButton.h"
#import <FAKFontAwesome.h>
#import "FilterDishButton.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#define DEFAULT_SIZE 128
#define HEADER_DEFAULT_SIZE 45

@interface StorefrontTableViewController ()
    @property (nonatomic, strong) UIView *backgroundView;
    @property (nonatomic, strong) UINavigationController *presentedNavigationController;
@end

@implementation StorefrontTableViewController
    NSMutableArray *sectionsList;
    @synthesize shoppingCart;
    NSMutableArray *cellList;
    NSMutableDictionary *cart_save;
    int initialFrame;
    NSArray *fetchedRestaurants;
    UIActivityIndicatorView *spinner;
    int current_page = 0;
    NSSet *defaultSectionsList;
    UserSession *session;
    UIView *spinnerView;
    UIWindow  *mainWindow;
    Header *header;
    BOOL enableCart;
    UIButton *retryFetch;
    UILabel *progress;
    UIImage *old_bg_image;
    UIImage *old_shadow_image;
    int initialImageHeight;
    FilterDishButton *dish_filter;
    StorefrontImageView *scroll_image_view;

- (void)showModalView
{
    [self showModal];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:old_bg_image
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = old_shadow_image;
    self.navigationController.navigationBar.translucent = NO;
    
    [dish_filter removeFromSuperview];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    old_bg_image = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    old_shadow_image = self.navigationController.navigationBar.shadowImage;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
    
    
    mainWindow = (((RAppDelegate *)[UIApplication sharedApplication].delegate).window);;
    dish_filter = [FilterDishButton x:5.0f y:5.0f];
    [dish_filter addTarget:self action:@selector(showDishSearch) forControlEvents:UIControlEventTouchUpInside];
    [mainWindow addSubview:dish_filter];
    [mainWindow bringSubviewToFront:dish_filter];
    if(spinnerView){
        [mainWindow bringSubviewToFront:spinnerView];
    }
}

- (void) showDishSearch {
    DishSearchTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"dishSearch"];
    viewController.restaurant = self.restaurant;
    viewController.shoppingCart = self.shoppingCart;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) showModal {
    ContactViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contactView"];
    viewController.restaurant = self.restaurant;
    viewController.pops = self;
    [viewController.view setNeedsLayout];
    _presentedNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    _presentedNavigationController.navigationBar.hidden = YES;
    _presentedNavigationController.view.layer.cornerRadius = 3;
    _presentedNavigationController.view.layer.masksToBounds = YES;
    _presentedNavigationController.view.layer.anchorPoint = CGPointMake(0.5f, 0);
    _presentedNavigationController.view.frame = CGRectMake(0, 0, viewController.view.frame.size.width, viewController.view.frame.size.height);
    CGRect frame = _presentedNavigationController.view.frame;
    frame.origin.y = (self.view.window.frame.size.height - frame.size.height) / 2;
    frame.origin.x = (self.view.window.frame.size.width - frame.size.width) / 2;
    _presentedNavigationController.view.frame = frame;
    _presentedNavigationController.view.backgroundColor = [UIColor bgColor];
    _presentedNavigationController.view.transform = CGAffineTransformMakeScale(0, 0);
    
    [mainWindow addSubview:_presentedNavigationController.view];
    [self unhidePresentedNavigationControllerCompletion:^{}];

}

-(void) pushDish:(Dishes *)dish {
    DishTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"dishEditViewController"];
    vc.shoppingCart = self.shoppingCart;
    vc.dish = dish;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dismissPresentedNavigationController {
    UINavigationController *reference = _presentedNavigationController;
    [self hidePresentedNavigationControllerCompletion:^{
        [reference.view removeFromSuperview];
    }];
    _presentedNavigationController = nil;
}

- (void)unhidePresentedNavigationControllerCompletion:(void(^)())completionBlock
{
    CGAffineTransform transformStep1 = CGAffineTransformMakeScale(1.1f, 1.1f);
    CGAffineTransform transformStep2 = CGAffineTransformMakeScale(1, 1);
    
    _backgroundView = [[UIView alloc] initWithFrame:[mainWindow bounds]];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5f];
    _backgroundView.alpha = 0.0f;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPresentedNavigationController)];
    [_backgroundView addGestureRecognizer:tgr];
                                   
    [mainWindow insertSubview:_backgroundView belowSubview:_presentedNavigationController.view];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _presentedNavigationController.view.layer.affineTransform = transformStep1;
        _backgroundView.alpha = 1.0f;
    }completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.3f animations:^{
                _presentedNavigationController.view.layer.affineTransform = transformStep2;
            }];
        }
    }];
}

- (void)hidePresentedNavigationControllerCompletion:(void(^)())completionBlock
{
    UIView *viewToDisplay = _backgroundView;
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _presentedNavigationController.view.transform = CGAffineTransformMakeScale(0, 0);
        _presentedNavigationController.view.alpha = 0.0f;
        _backgroundView.alpha = 0.0f;
    } completion:^(BOOL finished){
        if (finished) {
            [viewToDisplay removeFromSuperview];
            if (viewToDisplay == _backgroundView) {
                _backgroundView = nil;
            }
            completionBlock();
        }
    }];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) startLoading {
    enableCart = NO;
    int junk = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    junk = 0;
    mainWindow = (((RAppDelegate *)[UIApplication sharedApplication].delegate).window);
    spinnerView = [[UIView alloc] initWithFrame:CGRectMake(0, junk, mainWindow.frame.size.width, mainWindow.frame.size.height - junk)];
    spinnerView.backgroundColor = [UIColor whiteColor];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((mainWindow.frame.size.width/2.0) - 75, ((mainWindow.frame.size.height - junk)/2.0) - 95, 150, 150)];
    [logo setContentMode:UIViewContentModeCenter];
    logo.image = [UIImage imageNamed:@"loading.png"];
    logo.backgroundColor = [UIColor whiteColor];
    [spinnerView addSubview:logo];
    
    FAKFontAwesome *check = [FAKFontAwesome timesCircleIconWithSize:22.0f];
    [check addAttribute:NSForegroundColorAttributeName value:[UIColor almostBlackColor]];
    UIImage *b = [check imageWithSize:CGSizeMake(22.0,22.0)];
    UIImageView *a = [[UIImageView alloc] initWithImage:b];
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(10,15,44,44)];
    [c addSubview:a];
    [c addTarget:self action:@selector(myCustomBack) forControlEvents:UIControlEventTouchUpInside];
    
    [spinnerView addSubview:c];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setColor:[UIColor almostBlackColor]];
    spinner.frame = CGRectMake((mainWindow.frame.size.width/2.0) - 12, logo.frame.origin.y + 240, 24, 24);
    [spinnerView addSubview:spinner];
    [spinner startAnimating];
    
    progress = [[UILabel alloc] init];
    [progress setText: NSLocalizedString(@"FETCHING MENU",nil)];
    [progress setFont:[UIFont fontWithName:@"JosefinSans-Bold" size:12.0f]];
    progress.textAlignment = NSTextAlignmentCenter;
    [progress setTextColor:[UIColor blackColor]];
    CGRect rect = progress.frame;
    rect.origin.y = logo.frame.origin.y + 210;
    rect.size.width = mainWindow.frame.size.width;
    rect.size.height = 30;
    progress.frame = rect;
    [spinnerView addSubview:progress];
    
    retryFetch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [retryFetch addTarget:self
                   action:@selector(restartFetch:)
         forControlEvents:UIControlEventTouchUpInside];
    [retryFetch setTitle:NSLocalizedString(@"RETRY",nil) forState:UIControlStateNormal];
    [retryFetch.titleLabel setFont:[UIFont fontWithName:@"JosefinSans-Bold" size:12.0f]];
    [retryFetch.titleLabel setTintColor:[UIColor whiteColor]];
    retryFetch.frame = CGRectMake((mainWindow.frame.size.width / 2) - 110, logo.frame.origin.y + 160, 220.0 , 30.0);
    retryFetch.backgroundColor = [UIColor almostBlackColor];
    [retryFetch setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [retryFetch setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [retryFetch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    retryFetch.hidden = YES;
    [spinnerView addSubview:retryFetch];
    [mainWindow addSubview:spinnerView];
    [mainWindow bringSubviewToFront:spinnerView];
    
    if([[UserSession sharedManager] logged_in]){
        [[UserSession sharedManager] fetch_ratings: self.restaurant.id];
    }
}

- (void) restartFetch:(id) sender {
    [UIView animateWithDuration:1.0
                     animations:^{
                         retryFetch.alpha = 1.0f;
                         retryFetch.alpha = 0.0f;
                         retryFetch.hidden = YES;
                         progress.alpha = 0.0f;
                         [progress setText: NSLocalizedString(@"FETCHING MENU",nil)];
                         progress.alpha = 1.0f;
                         spinner.alpha = 1.0;
                         spinner.hidden = NO;
                     }];
    [self loadMenu];
}

- (void) stopLoading{
    [UIView animateWithDuration:0.5
                     animations:^{spinnerView.alpha = 0.0;}
                     completion:^(BOOL finished){
                         [spinnerView removeFromSuperview];
                     }];
    enableCart = YES;
}



-(void) viewDidAppear:(BOOL)animated {
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:@"Storefront Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
//    [self matchColor];
    if([shoppingCart count] != 0){
        int tots = 0;
        for(DishTableViewCell *d in shoppingCart){
            tots += (int) d.dishFooterView.stepper.value;
        }
        [self.cart setCount:[NSString stringWithFormat:@"%d", tots]];
    } else {
        [self.cart setCount:@"0"];
    }
}

-(void) myCustomBack {
	// Some anything you need to do before leaving
    [spinnerView removeFromSuperview];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) setupBackButtonAndCart {
//	self.navigationItem.hidesBackButton = YES;
    FAKFontAwesome *back = [FAKFontAwesome chevronLeftIconWithSize:22.0f];
    [back addAttribute:NSForegroundColorAttributeName value:[UIColor scarletColor]];
    UIImage *image = [back imageWithSize:CGSizeMake(45.0,45.0)];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(myCustomBack) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:item];
    
    shoppingCart = [[NSMutableArray alloc] init];
    [shoppingCart setIdent:self.restaurant.id];
    
    CartButton *cartButton = [[CartButton alloc] init];
    self.cart = cartButton;
    [self.cart setCount:[NSString stringWithFormat:@"%d", [shoppingCart count]]];
    
    DishCoinButton *dc = [[DishCoinButton alloc] init:self];
    [self.navigationItem setRightBarButtonItem:dc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLoading];
    enableCart = NO;

    [self setupBackButtonAndCart];
    
    session = [UserSession sharedManager];
    
    header = [[[NSBundle mainBundle] loadNibNamed:@"Header" owner:self options:nil] objectAtIndex:0];
    header.restaurant_name.text = self.restaurant.name;
    header.restaurant_name.textColor = [UIColor textColor];
    header.label.text = self.restaurant.name;
    header.label.font = [UIFont fontWithName:@"Copperplate-Bold" size:25.0f];
    header.scroll_view.restaurant = self.restaurant;
    header.scroll_view.img_delegate = self;
    header.autoresizingMask = UIViewAutoresizingNone;
    header.scroll_view.autoresizingMask = UIViewAutoresizingNone;
    header.button_view.backgroundColor = [UIColor bgColor];
    header.spacer.backgroundColor = [UIColor seperatorColor];
    header.spacer2.backgroundColor = [UIColor seperatorColor];
    header.seperator.backgroundColor = [UIColor seperatorColor];
    header.separator2.backgroundColor = [UIColor clearColor];
    header.map_label.textColor = [UIColor textColor];
    header.phone_label.textColor = [UIColor textColor];
    header.backgroundColor = [UIColor bgColor];
    self.tableView.tableHeaderView = header;
    
    NSMutableAttributedString *attributionMas = [[NSMutableAttributedString alloc] init];
    FAKFontAwesome *check = [FAKFontAwesome mapMarkerIconWithSize:18.0f];
    [check addAttribute:NSForegroundColorAttributeName value:[UIColor scarletColor]];
    [attributionMas appendAttributedString:[check attributedString]];
    header.map_fa.attributedText = attributionMas;
    
    check = [FAKFontAwesome phoneIconWithSize:18.0f];
    [check addAttribute:NSForegroundColorAttributeName value:[UIColor scarletColor]];
    attributionMas = [[NSMutableAttributedString alloc] init];
    [attributionMas appendAttributedString:[check attributedString]];
    header.phone_fa.attributedText = attributionMas;
    
    check = [FAKFontAwesome clockOIconWithSize:18.0f];
    [check addAttribute:NSForegroundColorAttributeName value:[UIColor scarletColor]];
    attributionMas = [[NSMutableAttributedString alloc] init];
    [attributionMas appendAttributedString:[check attributedString]];
    header.hours_fa.attributedText = attributionMas;
    
    [header.tap_info addTarget:self action:@selector(showModalView)];
    
    self.tableView.backgroundColor = [UIColor bgColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,45)];
    
    [self loadMenu];
}

- (void) loadCart {
    RAppDelegate *del = (RAppDelegate *)[UIApplication sharedApplication].delegate;
    cart_save = del.cart_save;
//    NSLog(@"LOADED DEFAULTS: %@",cart_save);
    if([cart_save objectForKey:self.restaurant.id] != nil){
        NSString *json = [cart_save objectForKey:self.restaurant.id];
        NSError* err = nil;
        NSLog(@"Json from defaults: %@",json);
        Order_Order *object_order = [[Order_Order alloc] initWithString:json error:&err];
        NSLog(@"ERROR LOADING CART FROM NSUSERDEFAULTS: %@",err);
        shoppingCart = [object_order reverseJsonWithRestaurant:self.restaurant];
        [shoppingCart setIdent:self.restaurant.id];
//        NSLog(@"CART SIZE: %d",[shoppingCart count]);
    }
    if([shoppingCart count] != 0){
        int tots = 0;
        for(DishTableViewCell *d in shoppingCart){
            tots += (int) d.dishFooterView.stepper.value;
        }
        [self.cart setCount:[NSString stringWithFormat:@"%d", tots]];
    } else {
        [self.cart setCount:@"0"];
    }
}

- (void)cartClick:sender
{
//    if(!enableCart){
//        return;
//    }
//    
//    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping = YES;
//    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping_cart = shoppingCart;
//    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).restaurant = self.restaurant;
//    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
//    [self.frostedViewController presentMenuViewController];
    
    if(![[UserSession sharedManager] logged_in]){
        SignInViewController *signin = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
        [self.navigationController pushViewController:signin animated:YES];
        return;
    }

    PrizesController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"prizesController"];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    [navigationController pushViewController:vc animated:YES];
    [self.frostedViewController hideMenuViewController];

}



- (void) currentImageView:(StorefrontImageView *)current {
    
    if(current == scroll_image_view){
        return;
    }
    
    scroll_image_view = current;
    initialImageHeight = current.frame.size.height;
    
//    [self matchColor];
    
}

-(void) matchColor {
//    LEColorPicker *colorPicker = [[LEColorPicker alloc] init];
//    LEColorScheme *colorScheme = [colorPicker colorSchemeFromImage:scroll_image_view.image];
//    
//    Header *head = (Header *)self.tableView.tableHeaderView;
//    
//    [head.button_view.layer removeAllAnimations];
//    
//    [UIView animateWithDuration:0.5
//                     animations:^{
//                         head.button_view.backgroundColor = [[colorScheme backgroundColor] colorWithAlphaComponent:0.8f];
//                         head.map_label.textColor = [colorScheme primaryTextColor];
//                         head.phone_label.textColor = [colorScheme primaryTextColor];
//                         head.favorite_label.textColor = [colorScheme primaryTextColor];
//                         for(UIImageView *i in [head.button_view subviews]){
//                             if([i isKindOfClass:[UIImageView class]]){
//                                 UIColor *color = [colorScheme primaryTextColor];
//                                 if(i.tag == 1){
//                                     i.image = [self ipMaskedImageNamed:@"tele.png" color:color];
//                                 } else if(i.tag == 2){
//                                     i.image = [self ipMaskedImageNamed:@"loc.png" color:color];
//                                 } else if(i.tag == 3){
//                                     i.image = [self ipMaskedImageNamed:@"heart.png" color:color];
//                                 }
//                             }
//                         }
//                     }];
}

- (UIImage *)ipMaskedImageNamed:(NSString *)name color:(UIColor *)color
{
	UIImage *image = [UIImage imageNamed:name];
	CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
	CGContextRef c = UIGraphicsGetCurrentContext();
	[image drawInRect:rect];
	CGContextSetFillColorWithColor(c, [color CGColor]);
	CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
	CGContextFillRect(c, rect);
	UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return result;
}



- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    CGImageRef imgRef = [image CGImage];
    CGImageRef maskRef = [maskImage CGImage];
    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                              CGImageGetHeight(maskRef),
                                              CGImageGetBitsPerComponent(maskRef),
                                              CGImageGetBitsPerPixel(maskRef),
                                              CGImageGetBytesPerRow(maskRef),
                                              CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef masked = CGImageCreateWithMask(imgRef, actualMask);
    return [UIImage imageWithCGImage:masked];
}

- (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    Header *head = header;//(Header *)self.tableView.tableHeaderView;
    
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
        
        imgRect = head.gradient.frame;
        imgRect.origin.y = scrollView.contentOffset.y;
        head.gradient.frame = imgRect;

        imgRect = scroll_image_view.frame;
        imgRect.size.height = initialImageHeight + yPos;
        scroll_image_view.frame = imgRect;
        
        imgRect = head.button_view_original_frame;
        // the static number below is hte height of hte contact card
        imgRect.origin.y = head.frame.size.height - 90 + scrollView.contentOffset.y;
        head.button_view.frame = imgRect;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 0.1;
    if([sectionsList count] == 0){
        return 0.1;
    }
    
    Sections *section = [sectionsList objectAtIndex:sectionIndex];
    if([section.name length] == 0){
        NSLog(@"Zero Height!");
        return 0.1;
    }
    return HEADER_DEFAULT_SIZE;
}


//////////////////////
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}
///////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return DEFAULT_SIZE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([cellList count] == 0){
        return 0;
    }
    return [cellList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if([cellList count] == 0){
        return 0;
    }
    
    return 1;
    
}

- (void) buildCells {
    cellList = [[NSMutableArray alloc] init];
//    for(Sections *section in sectionsList){
//        DishViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DishViewCell" owner:self options:nil] objectAtIndex:0];
//        [cell setRestorationIdentifier:@"DishViewCell"];
//        cell.controller = self;
//        cell.dishScrollView.section = section;
//        cell.dishScrollView.controller = self;
//        [cell.dishScrollView setupViews];
//        [cell trackPage];
//        cell.backgroundColor = [UIColor bgColor];
//        [cellList addObject:cell];
//    }
    for(Sections *section in sectionsList){
        DishCellClean *cell = [[[NSBundle mainBundle] loadNibNamed:@"DishCellClean" owner:self options:nil] objectAtIndex:0];
        [cell setRestorationIdentifier:@"DishCellClean"];
        cell.section = section;
        [cell setup];
        cell.backgroundColor = [UIColor bgColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segueToSection:)];
        [cell addGestureRecognizer:tgr];
        [cellList addObject:cell];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [cellList objectAtIndex:indexPath.section];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    return [[UIView alloc] initWithFrame:CGRectZero];
    UIView *blank = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,1.0)];
    if([sectionsList count] == 0){
        return blank;
    }
    
    if ([[sectionsList objectAtIndex:sectionIndex] isKindOfClass:[Sections class]]){
        return [self headerView:sectionIndex tableView:tableView];
    }
    else {
        return blank;
    }
}

- (UIView *) headerView:(NSInteger)sectionIndex tableView:(UITableView *)tableView
{
    UIView *blank = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,1.0)];
    
    Sections *section = [sectionsList objectAtIndex:sectionIndex];
    if([section.name length] == 0){
        return blank;
    }
    
    TableHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] objectAtIndex:0];
    view.headerTitle.text = section.name;
//    view.headerTitle.font = [UIFont fontWithName:@"Copperplate-Bold" size:20.0f];
    view.headerTitle.font = [UIFont fontWithName:@"East Market NF" size:22.0f];
    view.headerTitle.textColor = [UIColor textColor];
    view.headerTitle.backgroundColor = [UIColor bgColor];
    [view.headerTitle sizeToFit];
    CGRect frame = view.headerTitle.frame;
    if(frame.size.width > 250){
        frame.size.width = 250;
    }
    view.headerTitle.frame = frame;
    view.headerTitle.minimumScaleFactor = 0.5f;
    view.headerTitle.adjustsFontSizeToFitWidth = YES;
    frame = view.headerTitle.frame;
    frame.size.width += 20;
    view.headerTitle.frame = frame;
    view.headerTitle.center = view.center;
    view.backgroundColor = [UIColor bgColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"header_line.png"]];
    
    [view addSubview:imageView ];
    [view sendSubviewToBack:imageView ];
    
//    for (UIView * txt in view.subviews){
//        if ([txt isKindOfClass:[UILabel class]] && [txt isFirstResponder]) {
//            ((UILabel *)txt).textColor = [UIColor textColor];
//        }
//    }
    return view;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    current_page = [((DishViewCell *)([(UITableView *)self.tableView cellForRowAtIndexPath:indexPath])).dishScrollView currentPage];
//    NSLog(@"ScrollViewOffset Current_Page: %d",current_page);
//    [self performSegueWithIdentifier:@"menuSectionClick" sender:self];
}

- (void) segueToSection: (id) dishcellclean {
    DishCellClean *dish_cell = (DishCellClean *)((UITapGestureRecognizer *) dishcellclean).view;
    [self performSegueWithIdentifier:@"menuSectionClick" sender: dish_cell.section];
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
    
    if ([controller isKindOfClass:[SectionTableViewController class]]) {
        Sections *s = (Sections *) sender;
        SectionTableViewController *vc = (SectionTableViewController *)controller;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"Section ID: %@",[[sectionsList objectAtIndex:indexPath.row] objectID]);
        vc.section = s;
        vc.current_page = current_page;
        vc.restaurant = self.restaurant;
        vc.shoppingCart = shoppingCart;
        vc.managedObjectStore = self.managedObjectStore;
    } else {
        NSLog(@"Class: %@",segue.destinationViewController);
        NSAssert(NO, @"Unknown segue. All segues must be handled.");
    }
    
}
- (void) loadMenu {
    
    NSLog(@"SUBVIEW RESTAURANT ID: %@",self.restaurant.objectID);
    sectionsList = (NSMutableArray *)[self.restaurant.menu array];

//    [self buildCells];
//    [self.tableView reloadData];
    
    
    ////////// QUERY NEW DATA AND UPDATE TABLE.
    
    RKManagedObjectStore *managedObjectStore = self.managedObjectStore;
    
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    ///// MAPPINGS
    RKEntityMapping *dishesMapping = [RKEntityMapping mappingForEntityForName:@"Dishes" inManagedObjectStore:managedObjectStore];
    [dishesMapping addAttributeMappingsFromDictionary:@{
                                                        @"name": @"name",
                                                        @"_id": @"id",
                                                        @"price": @"price",
                                                        @"rating":@"rating",
                                                        @"index":@"position",
                                                        @"description": @"description_text",
                                                        @"has_multiple_sizes":@"sizes",
                                                        }];
    dishesMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *sectionsMapping = [RKEntityMapping mappingForEntityForName:@"Sections" inManagedObjectStore:managedObjectStore];
    [sectionsMapping addAttributeMappingsFromDictionary:@{
                                                          @"name": @"name",
                                                          @"_id": @"id",
                                                          @"index":@"position",
                                                          }];
    sectionsMapping.identificationAttributes = @[ @"id" ];
    
    
    RKEntityMapping *sizePricesMapping = [RKEntityMapping mappingForEntityForName:@"SizePrices" inManagedObjectStore:managedObjectStore];
    [sizePricesMapping addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"price":@"price",
                                                          @"size_id":@"related_to_size",
                                                          }];
    sizePricesMapping.identificationAttributes = @[ @"id" ];
    
    
    RKEntityMapping *optionMapping = [RKEntityMapping mappingForEntityForName:@"Option" inManagedObjectStore:managedObjectStore];
    [optionMapping addAttributeMappingsFromDictionary:@{
                                                        @"name": @"name",
                                                        @"price": @"price",
                                                        @"_id": @"id",
                                                        @"price_according_to_size":@"price_according_to_size",
                                                        }];
    optionMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *optionsMapping = [RKEntityMapping mappingForEntityForName:@"Options" inManagedObjectStore:managedObjectStore];
    [optionsMapping addAttributeMappingsFromDictionary:@{
                                                         @"name": @"name",
                                                         @"_id": @"id",
                                                         @"min_selections":@"min_selections",
                                                         @"max_selections":@"max_selections",
                                                         @"advanced":@"advanced",                                                         
                                                         @"type": @"type",
                                                         }];
    optionsMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *imagesMapping = [RKEntityMapping mappingForEntityForName:@"Images" inManagedObjectStore:managedObjectStore];
    [imagesMapping addAttributeMappingsFromDictionary:@{
                                                        @"medium": @"url",
                                                        @"id":@"id",
                                                        }];
    imagesMapping.identificationAttributes = @[ @"id" ];
    
    [sectionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dishes" toKeyPath:@"dishes" withMapping:dishesMapping]];
    [dishesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"sizes" toKeyPath:@"sizes_object" withMapping:optionsMapping]];
    [dishesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"options" toKeyPath:@"options" withMapping:optionsMapping]];
    [optionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"size_prices" toKeyPath:@"size_prices" withMapping:sizePricesMapping]];
    [dishesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"image" toKeyPath:@"images" withMapping:imagesMapping]];
    [optionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"individual_options" toKeyPath:@"list" withMapping:optionMapping]];
    
    NSString *query = [NSString stringWithFormat:@"/app/api/v1/restaurants/menu"]; //?id=%@",self.restaurant.id];

    NSString *url = [NSString stringWithFormat:@"%@/app/api/v1/restaurants/menu?id=%@&language=%@&lat=%@&lon=%@",dishGoUrl,self.restaurant.id,[[NSLocale preferredLanguages] objectAtIndex:0],session.lat,session.lon];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:sectionsMapping method:RKRequestMethodAny pathPattern:query keyPath:@"menu" statusCodes:statusCodes];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:10];
    
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    operation.managedObjectCache = managedObjectStore.managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        
        
        sectionsList = (NSMutableArray *)[result array];
        
        [sectionsList sortUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES], nil]];

        self.restaurant = (Restaurant *)[[[[result array] firstObject] managedObjectContext] objectWithID:[self.restaurant objectID]];
        self.restaurant.menu = [NSOrderedSet orderedSetWithArray:[result array]];

        [self buildCells];
        [header.scroll_view setupImages];
//        [self matchColor];
        [self.tableView reloadData];
        
        [self loadCart];        
        [self stopLoading];
        
    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
        [UIView animateWithDuration:1.5
                         animations:^{
                             retryFetch.alpha = 0.0f;
                             spinner.alpha = 1.0f;
                             retryFetch.hidden = NO;
                             retryFetch.alpha = 1.0f;
                             spinner.alpha = 0.0f;
                             spinner.hidden = YES;
                             progress.alpha = 0.0f;
                             progress.text = @"NETWORK ERROR";
                             progress.alpha = 1.0f;
                         }];
    }];
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
    
}


@end
