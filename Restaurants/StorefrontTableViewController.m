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
#import "Subsections.h"
#import "DishViewCell.h"
#import "TableHeaderView.h"
#import "SectionTableViewController.h"
#import "REFrostedViewController.h"
#import "MenuTableViewController.h"
#import "DishScrollView.h"
#import "DishTableViewCell.h"
#import "UIColor+Custom.h"
#import "StorefrontImageView.h"
#import "ContactViewController.h"
#import "LEColorPicker.h"

#define DEFAULT_SIZE 148
#define HEADER_DEFAULT_SIZE 44

@interface StorefrontTableViewController ()
    @property (nonatomic, strong) UIView *backgroundView;
    @property (nonatomic, strong) UINavigationController *presentedNavigationController;
@end

@implementation StorefrontTableViewController
    NSMutableArray *sectionsList;
    NSMutableArray *shoppingCart;
    NSMutableArray *cellList;
    int initialFrame;
    NSArray *fetchedRestaurants;
    int current_page = 0;
    NSSet *defaultSectionsList;
    // io Card pin: 4827b4c8bc7646e08c699c9bd2ebde76
//    CLLocationManager *locationManager;
//    MKMapView *mapView;
    UIView *spinnerView;
    UIWindow  *mainWindow;
    BOOL enableCart;
    int initialImageHeight;
    StorefrontImageView *scroll_image_view;

- (void)showModalView
{
    [self showModal];
}

- (void) showModal {
    ContactViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contactView"];
    viewController.restaurant = self.restaurant;
    _presentedNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    _presentedNavigationController.navigationBar.hidden = YES;
    _presentedNavigationController.view.layer.cornerRadius = 3;
    _presentedNavigationController.view.layer.masksToBounds = YES;
    _presentedNavigationController.view.layer.anchorPoint = CGPointMake(0.5f, 0);
//    _presentedNavigationController.view.frame = [self _navigationControllerFrame];
    _presentedNavigationController.view.frame = CGRectMake(0, 0, viewController.view.frame.size.height, viewController.view.frame.size.width);
//    _presentedNavigationController.view.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
    CGRect frame = _presentedNavigationController.view.frame;
    frame.origin.y = (self.view.frame.size.height - frame.size.height) / 2;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2;
    _presentedNavigationController.view.frame = frame;
    _presentedNavigationController.view.transform = CGAffineTransformMakeScale(0, 0);
    
    [mainWindow addSubview:_presentedNavigationController.view];
    [self unhidePresentedNavigationControllerCompletion:^{}];

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
    mainWindow = (((RAppDelegate *)[UIApplication sharedApplication].delegate).window);
    spinnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWindow.frame.size.width, mainWindow.frame.size.height - junk)];
    spinnerView.backgroundColor = [UIColor whiteColor];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((mainWindow.frame.size.width/2.0) - 75, ((mainWindow.frame.size.height - junk)/2.0) - 95, 150, 150)];
    [logo setContentMode:UIViewContentModeCenter];
    logo.image = [UIImage imageNamed:@"loading.png"];
    [spinnerView addSubview:logo];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setColor:[UIColor almostBlackColor]];
    spinner.frame = CGRectMake((mainWindow.frame.size.width/2.0) - 12, logo.frame.origin.y + 160, 24, 24);
    [spinnerView addSubview:spinner];
    [spinner startAnimating];
    
    [self.view addSubview:spinnerView];
}

- (void) stopLoading{
    [UIView animateWithDuration:0.5
                     animations:^{spinnerView.alpha = 0.0;}
                     completion:^(BOOL finished){
                         [spinnerView removeFromSuperview];
                     }];
    // THIS ADD STUFF TO THE CART FOR TESTING.
    bool kill = NO;
    for(Sections *sec in sectionsList){
        for(Subsections *subsec in sec.subsections){
            for(Dishes *d in subsec.dishes){
                DishTableViewCell *dish_logic = [[[NSBundle mainBundle] loadNibNamed:@"DishTableViewCell" owner:self options:nil] objectAtIndex:0];
                dish_logic.dish = d;
                dish_logic.dishTitle.text = d.name;
                dish_logic.parent = self;
                dish_logic.priceLabel.backgroundColor = [UIColor bgColor];
                [dish_logic setupLowerHalf];
                [dish_logic setupShoppingCart];
                [shoppingCart addObject:dish_logic];
                if([shoppingCart count] > 15){
                    kill = YES;
                    break;
                }
            }
            if (kill)
                break;
        }
        if (kill)
            break;
    }
    enableCart = YES;
}



-(void) viewDidAppear:(BOOL)animated {
    [self matchColor];
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
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) setupBackButtonAndCart {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]; // <-- Use your own image
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
    [backBtn setImage:backBtnImage];

    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    shoppingCart = [[NSMutableArray alloc] init];
    CartButton *cartButton = [[CartButton alloc] init];
    [cartButton.button addTarget:self action:@selector(cartClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:cartButton.button];
    [self.navigationItem setRightBarButtonItem:customItem];
    self.cart = cartButton;
    [self.cart setCount:[NSString stringWithFormat:@"%d", [shoppingCart count]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLoading];
    enableCart = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.autoresizingMask = UIViewAutoresizingNone;
    
    [self setupBackButtonAndCart];
    
    // FOOD CLOUD TITLE
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Freestyle Script Bold" size:30.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = self.restaurant.name;
    self.navigationItem.titleView = label;
    
    Header *header = [[[NSBundle mainBundle] loadNibNamed:@"Header" owner:self options:nil] objectAtIndex:0];
    header.label.text = self.restaurant.name;
//    header.label.font = [UIFont fontWithName:@"Freestyle Script Bold" size:40.0f];
    header.scroll_view.restaurant = self.restaurant;
    header.scroll_view.img_delegate = self;
    [header.scroll_view setupImages];
    header.autoresizingMask = UIViewAutoresizingNone;
    header.scroll_view.autoresizingMask = UIViewAutoresizingNone;
    header.button_view.backgroundColor = [UIColor complimentaryBg];
    header.spacer.backgroundColor = [UIColor seperatorColor];
    header.spacer2.backgroundColor = [UIColor seperatorColor];
    header.backgroundColor = [UIColor bgColor];
    self.tableView.tableHeaderView = header;
    [header.tap_info addTarget:self action:@selector(showModalView)];
    
    self.tableView.backgroundColor = [UIColor bgColor];
    
    [self loadMenu];
}

- (void)cartClick:sender
{
    if(!enableCart){
        return;
    }
    
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping = YES;
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping_cart = shoppingCart;
//    [((MenuTableViewController *)(self.frostedViewController.menuViewController)) setupMenu];
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    [self.frostedViewController presentMenuViewController];
}

- (void) currentImageView:(StorefrontImageView *)current {
    
    if(current == scroll_image_view){
        return;
    }
    
    scroll_image_view = current;
    initialImageHeight = current.frame.size.height;
    
    [self matchColor];
    
}

-(void) matchColor {
    LEColorPicker *colorPicker = [[LEColorPicker alloc] init];
    LEColorScheme *colorScheme = [colorPicker colorSchemeFromImage:scroll_image_view.image];
    
    Header *head = (Header *)self.tableView.tableHeaderView;
    
    [head.button_view.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         head.button_view.backgroundColor = [[colorScheme backgroundColor] colorWithAlphaComponent:0.8f];
                         for(UIImageView *i in [head.button_view subviews]){
                             if([i isKindOfClass:[UIImageView class]]){
                                 UIColor *color = [colorScheme primaryTextColor];
                                 if(i.tag == 1){
                                     i.image = [self ipMaskedImageNamed:@"tele.png" color:color];
                                 } else if(i.tag == 2){
                                     i.image = [self ipMaskedImageNamed:@"loc.png" color:color];
                                 } else if(i.tag == 3){
                                     i.image = [self ipMaskedImageNamed:@"heart.png" color:color];
                                 }
                             }
                         }
                     }];
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
    Header *head = (Header *)self.tableView.tableHeaderView;
    
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
    if (yPos > 0) {
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
        
        imgRect = head.button_view_original_frame;
        imgRect.origin.y = head.scroll_view.frame.origin.y + head.scroll_view.frame.size.height - head.button_view.frame.size.height;
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
    if([sectionsList count] == 0){
        return 0;
    }
    return HEADER_DEFAULT_SIZE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return DEFAULT_SIZE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([sectionsList count] == 0){
        return 1;
    }
    return [sectionsList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if([sectionsList count] == 0){
        return 0;
    }
    
    return 1;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    current_page = [((DishViewCell *)([(UITableView *)self.tableView cellForRowAtIndexPath:indexPath])).dishScrollView currentPage];
    NSLog(@"ScrollViewOffset Current_Page: %d",current_page);
    [self performSegueWithIdentifier:@"menuSectionClick" sender:self];
}

- (void) buildCells {
    cellList = [[NSMutableArray alloc] init];
    for(Sections *section in sectionsList){
        DishViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DishViewCell" owner:self options:nil] objectAtIndex:0];
        [cell setRestorationIdentifier:@"DishViewCell"];
        cell.dishScrollView.section = section;
        [cell.dishScrollView setupViews];
        cell.backgroundColor = [UIColor bgColor];
        [cellList addObject:cell];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [cellList objectAtIndex:indexPath.section];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    
    if([sectionsList count] == 0){
        return nil;
    }
    
    if ([[sectionsList objectAtIndex:sectionIndex] isKindOfClass:[Sections class]]){
        return [self headerView:sectionIndex tableView:tableView];
    } else if ([[sectionsList objectAtIndex:sectionIndex] isKindOfClass:[Subsections class]]){
        return [self subheaderView:sectionIndex tableView:tableView];
    } else {
        return nil;
    }
}

- (UIView *) headerView:(NSInteger)sectionIndex tableView:(UITableView *)tableView
{
    Sections *section = [sectionsList objectAtIndex:sectionIndex];
    if([section.name length] == 0){
        return nil;
    }
    
    TableHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] objectAtIndex:0];
    view.headerTitle.text = section.name;
    view.headerTitle.font = [UIFont fontWithName:@"Freestyle Script Bold" size:30.0f];
    view.headerTitle.textColor = [UIColor textColor];
    view.backgroundColor = [UIColor bgColor];
    for (UIView * txt in view.subviews){
        if ([txt isKindOfClass:[UILabel class]] && [txt isFirstResponder]) {
            ((UILabel *)txt).textColor = [UIColor textColor];
        }
    }
    return view;
    
}

- (UIView *) subheaderView:(NSInteger)sectionIndex tableView:(UITableView *)tableView
{
    Subsections *section = [sectionsList objectAtIndex:sectionIndex];
    if([section.name length] == 0){
        return nil;
    }
    
    TableHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] objectAtIndex:0];
    view.headerTitle.text = section.name;
    view.headerTitle.textColor = [UIColor textColor];    
    view.backgroundColor = [UIColor bgColor];
    for (UIView * txt in view.subviews){
        if ([txt isKindOfClass:[UILabel class]] && [txt isFirstResponder]) {
            ((UILabel *)txt).textColor = [UIColor textColor];
        }
    }
    return view;
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
        SectionTableViewController *vc = (SectionTableViewController *)controller;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"Section ID: %@",[[sectionsList objectAtIndex:indexPath.row] objectID]);
        vc.section = [sectionsList objectAtIndex:indexPath.section];
        vc.current_page = current_page;
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

    [self buildCells];
    [self.tableView reloadData];
    
    
    ////////// QUERY NEW DATA AND UPDATE TABLE.
    
    RKManagedObjectStore *managedObjectStore = self.managedObjectStore;
    
    ///// MAPPINGS
    RKEntityMapping *dishesMapping = [RKEntityMapping mappingForEntityForName:@"Dishes" inManagedObjectStore:managedObjectStore];
    [dishesMapping addAttributeMappingsFromDictionary:@{
                                                        @"name": @"name",
                                                        @"_id": @"id",
                                                        @"price": @"price",
                                                        @"index":@"position",
                                                        @"description": @"description_text",
                                                        }];
    dishesMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *sectionsMapping = [RKEntityMapping mappingForEntityForName:@"Sections" inManagedObjectStore:managedObjectStore];
    [sectionsMapping addAttributeMappingsFromDictionary:@{
                                                          @"name": @"name",
                                                          @"_id": @"id",
                                                          @"index":@"position",
                                                          }];
    sectionsMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *subsectionsMapping = [RKEntityMapping mappingForEntityForName:@"Subsections" inManagedObjectStore:managedObjectStore];
    [subsectionsMapping addAttributeMappingsFromDictionary:@{
                                                             @"name": @"name",
                                                             @"_id": @"id",
                                                             @"index":@"position",
                                                             }];
    subsectionsMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *optionMapping = [RKEntityMapping mappingForEntityForName:@"Option" inManagedObjectStore:managedObjectStore];
    [optionMapping addAttributeMappingsFromDictionary:@{
                                                        @"name": @"name",
                                                        @"price": @"price",
                                                        @"_id": @"id",
                                                        }];
    optionMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *optionsMapping = [RKEntityMapping mappingForEntityForName:@"Options" inManagedObjectStore:managedObjectStore];
    [optionsMapping addAttributeMappingsFromDictionary:@{
                                                         @"name": @"name",
                                                         @"_id": @"id",
                                                         @"type": @"type",
                                                         }];
    optionsMapping.identificationAttributes = @[ @"id" ];

    
    
    [sectionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"subsection" toKeyPath:@"subsections" withMapping:subsectionsMapping]];
    [subsectionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dish" toKeyPath:@"dishes" withMapping:dishesMapping]];
    [dishesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"options" toKeyPath:@"options" withMapping:optionsMapping]];
    [optionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"individual_option" toKeyPath:@"list" withMapping:optionMapping]];
    
    NSString *query = [NSString stringWithFormat:@"/api/v1/restaurants/menu"]; //?id=%@",self.restaurant.id];
    NSString *url = [NSString stringWithFormat:@"http://dev.foodcloud.ca:3000/api/v1/restaurants/menu?id=%@",self.restaurant.id];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:sectionsMapping method:RKRequestMethodAny pathPattern:query keyPath:@"menu" statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    operation.managedObjectCache = managedObjectStore.managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        
        
        sectionsList = (NSMutableArray *)[result array];
        
        [sectionsList sortUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES], nil]];

        self.restaurant = (Restaurant *)[[[[result array] firstObject] managedObjectContext] objectWithID:[self.restaurant objectID]];
        self.restaurant.menu = [NSOrderedSet orderedSetWithArray:[result array]];

        NSError *error;
        NSLog(@"SAVING MENU OF SIZE %lu",(unsigned long)[[result array] count]);
        if (![[self.restaurant managedObjectContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        } else {
            [self buildCells];
            [self.tableView reloadData];
        }
        
        [self stopLoading];
        
    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
    
}


@end
