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

@interface SectionTableViewController ()

@end

@implementation SectionTableViewController

    NSMutableArray *subsectionList;
    NSMutableDictionary *heights;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DishTableViewCell";
    
    DishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DishTableViewCell" owner:self options:nil] objectAtIndex:0];
    } else {
        UIView *removeView;
        while((removeView = [cell viewWithTag:12345]) != nil) {
            [removeView removeFromSuperview];
        }
    }
    NSLog(@"class: %@ index: %ld",[[subsectionList objectAtIndex:indexPath.section] class],(long)indexPath.section);
    Dishes *dish = [((Subsections *)[subsectionList objectAtIndex:indexPath.section]).dishes.allObjects objectAtIndex:indexPath.row];
    cell.dishTitle.text = dish.name;
    cell.dishDescription.text = dish.description_text;
    for(Options *options in dish.options){
        NSMutableArray *itemArray = [[NSMutableArray alloc] init];
        for(Option *option in options.list){
            [itemArray addObject:[NSString stringWithFormat:@"%@: %@$",option.name,option.price]];
        }
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segmentedControl.frame = CGRectMake(5, cell.frame.size.height + 5, cell.frame.size.width - 10, 50);
        
        CGRect frame = cell.frame;
        frame.size.height = cell.frame.size.height + 55;
        cell.frame = frame;
        
        segmentedControl.selectedSegmentIndex = 1;
        segmentedControl.tag = 12345;
        [cell.contentView addSubview:segmentedControl];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = 12345;
//    [button addTarget:self
//               action:@selector(aMethod:)
//     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Add" forState:UIControlStateNormal];
    
    button.frame = CGRectMake(cell.frame.size.width - 65, cell.frame.size.height + 5, 60, 40);
    
    CGRect frame = cell.frame;
    frame.size.height = cell.frame.size.height + 45;
    cell.frame = frame;
    
    button.layer.borderColor = [[UIColor blackColor] CGColor];
    button.layer.borderWidth=1.0f;
    [cell.contentView addSubview:button];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    NSString *key = [NSString stringWithFormat:@"%d-%d",indexPath.section,indexPath.row];
    if([[heights valueForKey:key] doubleValue] == 110){
        Dishes *dish = [((Subsections *)[subsectionList objectAtIndex:indexPath.section]).dishes.allObjects objectAtIndex:indexPath.row];
        int size = 0;
        for(Options *options in dish.options){
            size += 50;
        }
        size = size + 110 + 60;
        [heights setObject:[NSNumber numberWithInteger:size] forKey:key];
    } else {
        [heights setObject:[NSNumber numberWithInteger:110] forKey:key];
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
        [heights setObject:[NSNumber numberWithInteger:110] forKey:key];
        return 110;
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
