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

#define DEFAULT_SIZE 75

@interface SectionTableViewController ()

@end

@implementation SectionTableViewController

    NSMutableArray *subsectionList;
    NSMutableDictionary *heights;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    heights = [[NSMutableDictionary alloc] init];
    subsectionList = [[NSMutableArray alloc] init];
    [subsectionList addObject:self.section];
    int current_page_section = 0;
    int current_page_dish_count = 0;
    int counter = 1;
    int row = 0;
    
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
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:current_page_section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:current_page_section]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self.cart addTarget:self action:@selector(cartClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    self.tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        view;
    });
    
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
    [((MenuTableViewController *)(self.frostedViewController.menuViewController)) setupMenu];
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    [self.frostedViewController presentMenuViewController];
}

//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // unwrap the controller if it's embedded in the nav controller.
//    UIViewController *controller;
//    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
//        controller = [navController.viewControllers objectAtIndex:0];
//    } else {
//        controller = segue.destinationViewController;
//    }
//    
//    if ([controller isKindOfClass:[ShoppingCartTableViewViewController class]]) {
//        ShoppingCartTableViewViewController *vc = (ShoppingCartTableViewViewController *)controller;
//        vc.shopping_cart = self.shoppingCart;
//    } else {
//        NSLog(@"Class: %@",segue.destinationViewController);
//        NSAssert(NO, @"Unknown segue. All segues must be handled.");
//    }
//    
//}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"DishTableViewCell";
    
    DishTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DishTableViewCell" owner:self options:nil] objectAtIndex:0];
    
//    DishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    // Configure the cell...
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"DishTableViewCell" owner:self options:nil] objectAtIndex:0];
//    } else {
//        UIView *removeView;
//        while((removeView = [cell viewWithTag:12347]) != nil) {
//            [removeView removeFromSuperview];
//        }
//        while((removeView = [cell viewWithTag:12345]) != nil) {
//            [removeView removeFromSuperview];
//        }
//    }
    
    NSLog(@"class: %@ index: %ld",[[subsectionList objectAtIndex:indexPath.section] class],(long)indexPath.section);
    Dishes *dish = [((Subsections *)[subsectionList objectAtIndex:indexPath.section]).dishes.allObjects objectAtIndex:indexPath.row];
    cell.dish = dish;
    NSLog(@"%@",dish.name);
    cell.dishTitle.text = dish.name;
    cell.dishDescription.text = dish.description_text;
    
    if([dish.description_text length] == 0){
        CGRect f = cell.contentView.frame;
        f.size.height = f.size.height - 65;
        cell.contentView.frame = f;
    }
    
    for(Options *options in dish.options){
        
        OptionsView *option_view = [[OptionsView alloc] init];
        option_view.tag = 12347;
        option_view.op = options;
        
        CGRect frame = option_view.frame;
        frame.origin.y = cell.contentView.frame.size.height + 5;
        frame.origin.x = 10;
        frame.size.width = cell.contentView.frame.size.width - 20;
        option_view.frame = frame;
        [option_view setupOption];
        
        [cell.contentView addSubview:option_view];
        frame = cell.contentView.frame;
        frame.size.height = cell.contentView.frame.size.height + option_view.frame.size.height + 10;
        cell.contentView.frame = frame;
    }
    
    
    // Add Dish Button
    struct CGColor *mainColor = [UIColor colorWithRed:(62/255) green:(62/255) blue:(62/255) alpha:0.9].CGColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = 12345;
    [button addTarget:self action:@selector(addDish:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Add" forState:UIControlStateNormal];
    int buttonSize = 40;
    button.frame = CGRectMake(((cell.contentView.frame.size.width - 120)/2), cell.contentView.frame.size.height + 5, 120, buttonSize);
    button.layer.borderColor = mainColor;
    button.layer.backgroundColor = mainColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor: [UIColor colorWithRed:(62/255) green:(62/255) blue:(62/255) alpha:1.0] forState:UIControlStateHighlighted];
    button.layer.borderWidth=1.0f;
    [button.layer setCornerRadius:5.0f];
    [cell.contentView addSubview:button];
    
    //Move DishViewCell frame down button size.
    CGRect frame = cell.contentView.frame;
    frame.size.height = cell.contentView.frame.size.height + (buttonSize + 15);
    cell.contentView.frame = frame;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.priceLabel.text = cell.getPriceFast;
    cell.dish = dish;
    cell.full_height = cell.contentView.frame.size.height;
    return cell;
}

-(void)addDish:(id)sender
{
    NSLog(@"Adding dish. Total dishes: %d",[self.shoppingCart count]);
    UIButton *button = (UIButton *)sender;
//    UIView *content_view = (UIView *)[button superview];
    DishTableViewCell *cell = (DishTableViewCell*)[[[button superview] superview] superview];
    [self.shoppingCart addObject:cell.dish];
    [self.cart setTitle:[NSString stringWithFormat:@"%d", [self.shoppingCart count]] forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    if([[heights valueForKey:key] doubleValue] == DEFAULT_SIZE){
        DishTableViewCell *c = (DishTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        int size = c.full_height;
        for(id kkey in [heights allKeys]) {
            [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:kkey];
        }
        [heights setObject:[NSNumber numberWithInteger:size] forKey:key];
    } else {
        [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:key];
    }
    [tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    NSString *key = [NSString stringWithFormat:@"%d-%d",indexPath.section,indexPath.row];
    if([heights objectForKey:key]){
        return [[heights valueForKey:key] doubleValue];
    } else {
        [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:key];
        return DEFAULT_SIZE;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    Subsections *section = [subsectionList objectAtIndex:sectionIndex];
    if([section.name length] == 0){
        return 0;
    }
    
    return 33;
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
