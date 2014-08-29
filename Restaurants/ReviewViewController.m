//
//  ReviewTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 12/18/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "ReviewViewController.h"
#import "ShoppingCartTableView.h"
#import "ALAlertBanner.h"
#import "DishTableViewCell.h"
#import "ReviewTotal.h"
#import "ReviewTableCell.h"
#import <REFrostedViewController/REFrostedViewController.h>

#define DEFAULT_SIZE 100
#define LARGE_SIZE 151

@interface ReviewViewController ()

@end

@implementation ReviewViewController

    NSMutableDictionary *heights;
//    ShoppingCartTableView *shop;
    @synthesize main_user;
    @synthesize next_view;
    float tot;
    ReviewTableCell *r_cell;

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
    
    
    // FOOD CLOUD TITLE
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Copperplate-Bold" size:20.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"Review Order";
    self.navigationItem.titleView = label;
}

- (void) next {
    main_user.review_confirm = YES;
    [self.navigationController popViewControllerAnimated:YES];
//    [self launchAlert:@"Order Review Confirmed!"];
}

- (void)launchAlert:(NSString *)msg
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.navigationController.topViewController.view
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionTop
                                                        title:@"Success!"
                                                     subtitle:msg];
    
    
    banner.secondsToShow = 3.0f;
    
    [banner show];
}

-(void) updatePrice {
    float tot = 0.0;
    for(DishTableViewCell *dish_cell in self.shopping_cart){
        tot += dish_cell.getCurrentPrice;
    }
    self.total_view.price_label.text = [NSString stringWithFormat:@"%.02f",tot];
}

- (void) setupBackButton {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]; // <-- Use your own image
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
    [backBtn setImage:backBtnImage];
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
    //                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    //                                       target:nil action:nil];
    //    negativeSpacer.width = -16;// it was -6 in iOS 6
    //    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, backBtn, nil] animated:NO];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    // FOOD CLOUD TITLE
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Copperplate-Bold" size:20.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"Review Order";
    self.navigationItem.titleView = label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackButton];
    [self setupHeight];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor bgColor];
    self.view.backgroundColor = [UIColor bgColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;    

    self.tableView.tableFooterView = [self setupFooter];
    [self.tableView reloadData];
    
}

-(void) remove:(UIGestureRecognizer *) recognizer {
    ButtonCartRow *dish_button = (ButtonCartRow *) recognizer.view;
    DishTableViewCell *dish_cell = dish_button.parent;
    [self.shopping_cart removeObject:dish_cell];
    [self setupHeight];
    [UIView transitionWithView: self.tableView
                      duration: 0.5f
                       options: UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^(void)
     {
         [self.tableView reloadData];
     }
                    completion: ^(BOOL isFinished)
     {
         
     }];
    [self updatePrice];
}

-(void) edit:(UIGestureRecognizer *) recognizer {
    ButtonCartRow *dish_button = (ButtonCartRow *) recognizer.view;
    DishTableViewCell *dish_cell = dish_button.parent;
    [dish_cell.dishFooterView.add setTitle:@"Save" forState:UIControlStateNormal];
    dish_cell.final_editing = YES;
    DishTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"dishEditViewController"];
    vc.shoppingCart = self.shopping_cart;
    [vc preloadDishCell:dish_cell];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *) setupFooter {
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    return footer;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupNextButton];
}

- (void) setupNextButton {
    if([[next_view subviews] count] == 0){
        next_view.backgroundColor = [UIColor clearColor];
        NSLog(@"Adding Next");
        int total_height = self.view.frame.size.height;
        int view_height = 60;
        int button_height = 38;
        int view_position = total_height - view_height;
        
        ReviewTotal *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReviewTotal" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = [UIColor textColor];
        cell.price_label.backgroundColor = [UIColor whiteColor];
        cell.price_label.textColor = [UIColor scarletColor];
        [cell.price_label.layer setCornerRadius:5.0f];
        cell.total_label.textColor = [UIColor whiteColor];
        [self.total_view removeFromSuperview];
        [self.view addSubview:cell];
        self.total_view = cell;
        
        CGRect frame = next_view.frame;
        frame.origin.y = view_position;
        frame.size.height = view_height;
        next_view.frame = frame;
        
        frame = self.tableView.frame;
        frame.origin.y = self.total_view.frame.size.height;
        frame.size.height = self.view.frame.size.height - view_height - self.total_view.frame.size.height;
        self.tableView.frame = frame;
        
        UILabel *next_but = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, button_height)];
        next_but.text = @"Next";
        [next_but setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
        next_but.textColor = [UIColor bgColor];
        next_but.textAlignment = NSTextAlignmentCenter;
        [next_but setUserInteractionEnabled:NO];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20, ((view_height - button_height) / 2.0), self.view.frame.size.width - 40, button_height)];
        btn.backgroundColor = [UIColor nextColor];
        btn.layer.cornerRadius = 3.0f;
        [btn addSubview:next_but];
        [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [next_view addSubview:btn];
    }
}

-(void) setupHeight {
    heights = [[NSMutableDictionary alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (heights == nil){
//        NSLog(@"Setting up height dict");
//        [self setupHeight];
//    }
//    
//    [self.tableView beginUpdates];
//    NSString *key = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
//    for(DishTableViewCell *dish_cell in self.shopping_cart){
//        dish_cell.reviewCartCell.separator1.hidden = NO;
//    }
//    DishTableViewCell *dish_view = [self.shopping_cart objectAtIndex:indexPath.row];
//    ReviewTableCell *r = dish_view.reviewCartCell;
//    if([[heights valueForKey:key] integerValue] == DEFAULT_SIZE){
//        r.separator1.hidden = YES;
//        r.more_image.hidden = YES;
//        int size = LARGE_SIZE;
//        for(id kkey in [heights allKeys]) {
//            [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:kkey];
//        }
//        [heights setObject:[NSNumber numberWithInteger:size] forKey:key];
//    } else {
//        [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:key];
//
//        [UIView transitionWithView: r
//                          duration: 0.35f
//                           options: UIViewAnimationOptionTransitionCrossDissolve
//                        animations: ^(void)
//         {
//             r.separator1.hidden = NO;
//             r.more_image.hidden = NO;
//         }
//                        completion: ^(BOOL isFinished){}
//         ];
//
//    }
//    [self.tableView endUpdates];
    
    [self.tableView beginUpdates];

        for(DishTableViewCell *dish_cell in self.shopping_cart){
            dish_cell.reviewCartCell.separator1.hidden = NO;
            dish_cell.reviewCartCell.more_image.hidden = NO;
        }
    
        DishTableViewCell *dish_view = [self.shopping_cart objectAtIndex:indexPath.row];
    
        if([r_cell isEqual: dish_view.reviewCartCell]){
            [UIView transitionWithView: r_cell
                              duration: 0.35f
                               options: UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void)
             {
                 r_cell.separator1.hidden = NO;
                 r_cell.more_image.hidden = NO;
             }
                            completion: ^(BOOL isFinished){}
             ];
            r_cell = nil;
        } else {
            r_cell = dish_view.reviewCartCell;
            r_cell.separator1.hidden = YES;
            r_cell.more_image.hidden = YES;
        }
    
    [self.tableView endUpdates];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"r_cell: %@",r_cell);
    DishTableViewCell *dish_view = [self.shopping_cart objectAtIndex:indexPath.row];
    if([r_cell isEqual: dish_view.reviewCartCell]){
        [dish_view.reviewCartCell setNeedsLayout];
        NSLog(@"Full Height: %f",dish_view.reviewCartCell.frame.size.height);
        return LARGE_SIZE;
    } else {
        NSLog(@"Half Height: %f",dish_view.reviewCartCell.move_me_up_and_down.frame.origin.y);
        return dish_view.reviewCartCell.move_me_up_and_down.frame.origin.y + dish_view.reviewCartCell.separator1.frame.origin.y + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.shopping_cart count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DishTableViewCell *dish_view = [self.shopping_cart objectAtIndex:indexPath.row];
    return dish_view.reviewCartCell;
}

- (void) viewWillAppear:(BOOL)animated {
    [self setupHeight];
    [self.tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [self updatePrice];
    for(DishTableViewCell *dish_cell in self.shopping_cart){
        tot += dish_cell.getCurrentPrice;
//        [dish_cell.reviewCartCell.edit  removeTarget:nil
//                                        action:NULL
//                                        forControlEvents:UIControlEventAllEvents];
//        [dish_cell.reviewCartCell.remove  removeTarget:nil
//                                              action:NULL
//                                    forControlEvents:UIControlEventAllEvents];
//        [dish_cell.reviewCartCell.edit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
//        [dish_cell.reviewCartCell.remove addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        for (UIGestureRecognizer *recognizer in dish_cell.shoppingCartCell.edit.gestureRecognizers) {
            [dish_cell.reviewCartCell.edit removeGestureRecognizer:recognizer];
        }
        
        for (UIGestureRecognizer *recognizer in dish_cell.shoppingCartCell.remove.gestureRecognizers) {
            [dish_cell.reviewCartCell.remove removeGestureRecognizer:recognizer];
        }
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(edit:)];
        singleTap.numberOfTapsRequired = 1;
        dish_cell.reviewCartCell.edit.userInteractionEnabled = YES;
        [dish_cell.reviewCartCell.edit addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove:)];
        singleTap2.numberOfTapsRequired = 1;
        dish_cell.reviewCartCell.remove.userInteractionEnabled = YES;
        [dish_cell.reviewCartCell.remove addGestureRecognizer:singleTap2];
    }
}

@end
