//
//  DishTableViewCell.m
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "DishTableViewCell.h"
#import "OptionsView.h"
#import "DishCellViewLowerHalf.h"
#import "DishFooterView.h"
#import "REFrostedViewController.h"
#import "MenuTableViewController.h"
#import "UIColor+Custom.h"

@implementation DishTableViewCell {
    float totalPrice;
}

@synthesize option_views;

- (void)setFrame:(CGRect)frame;
{
    NSLog(@"%@", NSStringFromCGRect(frame));
    [super setFrame:frame];
}

-(void) setupShoppingCart {
    
    CartRowCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CartRowCell" owner:self options:nil] objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.dishTitle.text = self.dish.name;
    cell.priceLabel.text = [self getPriceString];
    
    cell.priceLabel.font = [UIFont fontWithName:@"6809 Chargen" size:13.0f];
    cell.dishTitle.font = [UIFont fontWithName:@"6809 Chargen" size:14.0f];
    
    cell.backgroundColor = [UIColor clearColor];
    [cell.quantity.layer setCornerRadius:5.0f];
    cell.quantity.text = [NSString stringWithFormat:@"%dx", (int) self.dishFooterView.stepper.value];
    NSLog(@"INITIAL CARTROWCELL HEIGHT: %f",cell.frame.size.height);
    cell.quantity.font = [UIFont fontWithName:@"6809 Chargen" size:13.0f];
    cell.fullHeight = [NSNumber numberWithInt:cell.frame.size.height];
    cell.parent = self;
    cell.edit.parent = self;
    cell.remove.parent = self;
    
    [cell.edit.layer setBorderColor:[UIColor seperatorColor].CGColor];
    [cell.edit.layer setBorderWidth:1.0f];
    [cell.edit.layer setCornerRadius:5.0f];
    
    [cell.remove.layer setBorderColor:[UIColor seperatorColor].CGColor];
    [cell.remove.layer setBorderWidth:1.0f];
    [cell.remove.layer setCornerRadius:5.0f];
    
    self.shoppingCartCell = cell;
}

-(void) setupLowerHalf {
    self.autoresizingMask = UIViewAutoresizingNone;
    DishCellViewLowerHalf *cell = [[DishCellViewLowerHalf alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
//    cell.autoresizingMask = UIViewAutoresizingNone;
//    cell.contentView.autoresizingMask = UIViewAutoresizingNone;
    cell.frame = CGRectMake(10, 0, 300, 0);
    cell.contentView.frame = CGRectMake(10, 0, 300, 0);
    NSLog(@"%@",CGRectCreateDictionaryRepresentation(cell.frame));
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor bgColor];
    cell.contentView.backgroundColor = [UIColor bgColor];
    Dishes *dish = self.dish;

    
    if([dish.description_text length] != 0){
        
        cell.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, cell.contentView.frame.size.height, 300, 50)];
        cell.descriptionLabel.autoresizingMask = UIViewAutoresizingNone;
        cell.descriptionLabel.backgroundColor = [UIColor clearColor];
        cell.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        cell.descriptionLabel.textColor = [UIColor textColor];
        cell.descriptionLabel.text = @"Description";
        cell.descriptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
        CGRect f = cell.contentView.frame;
        f.size.height = cell.contentView.frame.size.height + 50;
        cell.contentView.frame = f;
        [cell.contentView addSubview:cell.descriptionLabel];
        
        cell.dishDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, cell.contentView.frame.size.height, 300, 100)];
        cell.dishDescription.autoresizingMask = UIViewAutoresizingNone;
        cell.dishDescription.backgroundColor = [UIColor clearColor];
        cell.dishDescription.textAlignment = NSTextAlignmentLeft;
        cell.dishDescription.textColor = [UIColor textColor];
        cell.dishDescription.text = dish.description_text;
        cell.dishDescription.font = [UIFont fontWithName:@"Helvetica-Oblique" size:16.0f];
        [cell.dishDescription setNumberOfLines:6];
        f = cell.contentView.frame;
        f.size.height = cell.contentView.frame.size.height + 100;
        cell.contentView.frame = f;
        [cell.contentView addSubview:cell.dishDescription];
        
        NSLog(@"%@",CGRectCreateDictionaryRepresentation(cell.frame));
    }
    
    self.option_views = [[NSMutableArray alloc] init];
    
    for(Options *options in dish.options){
        
        OptionsView *option_view = [[OptionsView alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
        option_view.optionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        option_view.optionTitle.backgroundColor = [UIColor clearColor];
        option_view.optionTitle.textAlignment = NSTextAlignmentCenter;
        option_view.optionTitle.textColor=[UIColor blackColor];
        option_view.optionTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        [option_view addSubview:option_view.optionTitle];

        option_view.parent = self;
        option_view.tag = 12347;
        option_view.op = options;
        
        CGRect frame = option_view.frame;
        frame.origin.y = cell.contentView.frame.size.height + 5;
        option_view.frame = frame;
        [option_view setupOption];
        
        [cell.contentView addSubview:option_view];
        
        [option_views addObject:option_view];
        
        frame = cell.contentView.frame;
        frame.size.height = cell.contentView.frame.size.height + option_view.frame.size.height + 10;
        cell.contentView.frame = frame;
    }
    
    cell.dish = dish;
    CGRect f = cell.contentView.frame;
    f.size.height = cell.contentView.frame.size.height + 50;
    cell.contentView.frame = f;
    cell.full_height = cell.contentView.frame.size.height;
    self.lower_half = cell;
    [self setPrice];
    
    // Add Dish Button
    DishFooterView *foot = [[[NSBundle mainBundle] loadNibNamed:@"DishFooterView" owner:self options:nil] objectAtIndex:0];
    foot.autoresizingMask = UIViewAutoresizingNone;
    UIButton *button = foot.add;
    foot.parent = self;
    [button addTarget:self action:@selector(addDish:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Add" forState:UIControlStateNormal];
    [button.layer setCornerRadius:5.0f];
    button.backgroundColor = [UIColor bgColor];
    foot.quantity.backgroundColor = [UIColor bgColor];
    [foot.quantity.layer setCornerRadius:5.0f];
    self.dishFooterView = foot;
    UIStepper *stepper = self.dishFooterView.stepper;
    stepper.minimumValue = 1;
    stepper.maximumValue = 12;
    
}

-(void)addDish:(id)sender
{
    if(self.editing){
        [self.parent.navigationController popViewControllerAnimated:YES];
        REFrostedViewController *cu = (REFrostedViewController *)[self.parent.navigationController topViewController];
        ((MenuTableViewController *)(cu.frostedViewController.menuViewController)).shopping = YES;
        [((MenuTableViewController *)(cu.frostedViewController.menuViewController)).tableView reloadData];
        [cu.frostedViewController presentMenuViewController];
    } else {
        [self setupShoppingCart];
        [self.parent addDish:self];
        [self.parent.navigationController popViewControllerAnimated:YES];
    }
}

-(float) getPrice {
    
    if(self.dish.price == nil){
        totalPrice = 0.0f;
    } else {
        totalPrice = [self.dish.price floatValue];
    }
    
    if(self.lower_half){
        for (OptionsView *priceView in [self.lower_half.contentView subviews]){
            NSLog(@"Querying price on view with tag %d and class of %@",priceView.tag,priceView.class);
            if (priceView.tag == 12347){
                totalPrice += [priceView getPrice];
            }
        }
    }
    int q = (int) self.dishFooterView.stepper.value;
    if (q == 0){
        q = 1;
    }
    totalPrice = totalPrice * q;
    
    return totalPrice;
}

-(NSString *) getPriceFast {
    
    if(self.dish.price == nil){
        totalPrice = 0.0f;
    } else {
        totalPrice = [self.dish.price floatValue];
    }
    
    return [NSString stringWithFormat:@"%.02f", totalPrice];
}

-(NSString *) getPriceString {
    return [NSString stringWithFormat:@"%.02f", [self getPrice]];
}

-(void) setPrice {
//    NSLog(@"Updating price %@",[self getPrice]);
//    [UIView animateWithDuration:0.5
//                     animations:^{
////                         self.priceLabel.alpha = 0.0f;
//                         self.priceLabel.text = [self getPrice];
////                         self.priceLabel.alpha = 1.0f;
//                     }];
    self.priceLabel.text = [NSString stringWithFormat:@"%.02f", [self getPrice]];
    if(self.shoppingCartCell){
//        self.shoppingCartCell.priceLabel.text = [NSString stringWithFormat:@"%.02f", [self getPrice]];
        [self setupShoppingCart];
    }
}

@end
