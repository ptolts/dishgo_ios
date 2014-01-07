//
//  SectionTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "SectionTableViewController.h"
#import "Sections.h"
#import "Subsections.h"
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
#import "Images.h"
#import "UIColor+Custom.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define DEFAULT_SIZE 193
#define SECOND_SIZE 133
#define HEADER_DEFAULT_SIZE 35

@interface SectionTableViewController ()

@end

@implementation SectionTableViewController

    NSMutableArray *subsectionList;
    NSMutableDictionary *heights;
    Dishes *selected_dish;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
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
    
    heights = [[NSMutableDictionary alloc] init];
    subsectionList = [[NSMutableArray alloc] init];
    [subsectionList addObject:self.section];
    int current_page_section = 0;
    int current_page_dish_count = 0;
    int counter = 1;
    int row = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // THIS COULD CAUSE BUGS IF DISHES ARE DISPLAYED DIFFERENTLY.
    
    for(Subsections *sub in self.section.subsections){
        if(current_page_dish_count <= self.current_page && self.current_page < current_page_dish_count + [sub.dishes count] + 1){
            current_page_section = counter;
            row = self.current_page - current_page_dish_count;
        }
        counter++;
        current_page_dish_count += [sub.dishes count];
        [subsectionList addObject:sub];
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:current_page_section] atScrollPosition:UITableViewScrollPositionTop animated:YES];

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
//    [((MenuTableViewController *)(self.frostedViewController.menuViewController)) setupMenu];
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
        vc.dish = selected_dish;
    } else {
        NSLog(@"Class: %@",segue.destinationViewController);
        NSAssert(NO, @"Unknown segue. All segues must be handled.");
    }
    
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Dishes *dish = [((Subsections *)[subsectionList objectAtIndex:indexPath.section]).dishes.array objectAtIndex:indexPath.row];
    SectionDishViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SectionDishViewCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.dish = dish;

    cell.dishTitle.text = dish.name;
    cell.dishDescription.text = dish.description_text;
    
    cell.dishTitle.textColor = [UIColor textColor];
    cell.seperator.backgroundColor = [UIColor seperatorColor];
    cell.seperator2.backgroundColor = [UIColor seperatorColor];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.priceLabel.text = cell.getPriceFast;
    cell.dish = dish;
    cell.dishImage.clipsToBounds = YES;
    cell.full_height = cell.contentView.frame.size.height;
    cell.backgroundColor = [UIColor bgColor];
    if([dish.images count] > 0){
        [cell.dishDescription removeFromSuperview];
        [cell.seperator removeFromSuperview];
        Images *img = [dish.images firstObject];
        __weak typeof(cell.dishImage) weakImage = cell.dishImage;
        [cell.dishImage          setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://dev.foodcloud.ca:3000/assets/sources/%@",img.url]]
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
        [cell.dishImage removeFromSuperview];
    }
    
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
    } else if ([[subsectionList objectAtIndex:sectionIndex] isKindOfClass:[Subsections class]]){
        return [self subheaderView:sectionIndex tableView:tableView];
    } else {
        return nil;
    }
}

- (UIView *) headerView:(NSInteger)sectionIndex tableView:(UITableView *)tableView
{
    Sections *section = [subsectionList objectAtIndex:sectionIndex];
    if([section.name length] == 0){
        return nil;
    }
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    //    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    //
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    //    label.text = section.name;
    //    label.font = [UIFont systemFontOfSize:15];
    //    label.textColor = [UIColor whiteColor];
    //    label.backgroundColor = [UIColor clearColor];
    //    [label sizeToFit];
    //    [view addSubview:label];
    
    TableHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] objectAtIndex:0];
    view.headerTitle.text = section.name;
    //    view.headerTitle.font = [UIFont fontWithName:@"Freestyle Script Bold" size:30.0f];
    view.headerTitle.font = [UIFont fontWithName:@"East Market NF" size:22.0f];
    view.headerTitle.textColor = [UIColor textColor];
    view.headerTitle.backgroundColor = [UIColor bgColor];
    [view.headerTitle sizeToFit];
    CGRect frame = view.headerTitle.frame;
    frame.size.width += 20;
    view.headerTitle.frame = frame;
    view.headerTitle.center = view.center;
    view.backgroundColor = [UIColor bgColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"header_line.png"]];
    
    [view addSubview:imageView ];
    [view sendSubviewToBack:imageView ];
    return view;
    
}

- (UIView *) subheaderView:(NSInteger)sectionIndex tableView:(UITableView *)tableView
{
    Subsections *section = [subsectionList objectAtIndex:sectionIndex];
    if([section.name length] == 0){
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    }
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    //    view.backgroundColor = [UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0];
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    //    label.text = section.name;
    //    label.font = [UIFont systemFontOfSize:15];
    //    label.textColor = [UIColor whiteColor];
    //    label.backgroundColor = [UIColor clearColor];
    //    [label sizeToFit];
    //    [view addSubview:label];
    
    TableHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] objectAtIndex:0];
    view.headerTitle.text = section.name;
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Dishes *dish = [((Subsections *)[subsectionList objectAtIndex:indexPath.section]).dishes.array objectAtIndex:indexPath.row];
    if([dish.images count] > 0){
        return DEFAULT_SIZE;
    } else {
        return SECOND_SIZE;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    Subsections *section = [subsectionList objectAtIndex:sectionIndex];
    if([section.name length] == 0){
        return 0;
    }
    
    return HEADER_DEFAULT_SIZE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [subsectionList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if([[subsectionList objectAtIndex:section] isKindOfClass:[Subsections class]]){
        return [((Subsections *)[subsectionList objectAtIndex:section]).dishes count];
    }

    return 0;

    
}

@end
