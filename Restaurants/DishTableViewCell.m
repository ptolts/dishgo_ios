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
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DishTableViewCell {
    float totalPrice;
    NSString *old_text;
    CGRect original_fucking_frame;
}

@synthesize option_views;

- (void)setFrame:(CGRect)frame;
{
    [super setFrame:frame];
}

- (ReviewTableCell *) reviewCartCell {
    
    
    NSString *opt_text = @"";
    for(OptionsView *o in option_views){
        for(Option_Order *oo in o.option_order_json){
            if(oo.selected){
                if([opt_text length] == 0){
                    opt_text = [NSString stringWithFormat:@"%@",oo.name];
                } else {
                    opt_text = [NSString stringWithFormat:@"%@, %@",opt_text,oo.name];
                }
            }
        }
    }
    
    _reviewCartCell.dish_options.text = opt_text;

    return _reviewCartCell;
}

-(void) setupShoppingCart {
    
    CartRowCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CartRowCell" owner:self options:nil] objectAtIndex:0];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.dishTitle.text = self.dish.name;
    cell.priceLabel.text = [self getPriceString];
    
//    cell.priceLabel.font = [UIFont fontWithName:@"6809 Chargen" size:13.0f];
//    cell.dishTitle.font = [UIFont fontWithName:@"6809 Chargen" size:14.0f];
    cell.priceLabel.font = [UIFont fontWithName:@"Copperplate-Bold" size:13.0f];
    cell.dishTitle.font = [UIFont fontWithName:@"Copperplate" size:14.0f];
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.seperator.backgroundColor = [UIColor seperatorColor];
    [cell.quantity.layer setCornerRadius:5.0f];
    cell.quantity.text = [NSString stringWithFormat:@"%dx", (int) self.dishFooterView.stepper.value];

//    cell.quantity.font = [UIFont fontWithName:@"6809 Chargen" size:13.0f];
    cell.quantity.font = [UIFont fontWithName:@"Copperplate-Bold" size:13.0f];
    cell.fullHeight = [NSNumber numberWithInt:cell.frame.size.height];
    cell.parent = self;
    cell.edit.parent = self;
    cell.remove.parent = self;
    
    [cell.edit_label.layer setBorderColor:[UIColor textColor].CGColor];
    [cell.edit_label.layer setBorderWidth:1.0f];
    [cell.edit_label.layer setCornerRadius:5.0f];
    cell.edit_label.backgroundColor = [UIColor textColor];
    cell.edit_label.textColor = [UIColor bgColor];
    
    [cell.remove_label.layer setBorderColor:[UIColor textColor].CGColor];
    [cell.remove_label.layer setBorderWidth:1.0f];
    [cell.remove_label.layer setCornerRadius:5.0f];
    cell.remove_label.backgroundColor = [UIColor textColor];
    cell.remove_label.textColor = [UIColor bgColor];
    
    self.shoppingCartCell = cell;
}

-(void) setupReviewCell {
    
    ReviewTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReviewCell" owner:self options:nil] objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.dishTitle.text = self.dish.name;
    cell.priceLabel.text = [self getPriceString];

    
    cell.backgroundColor = [UIColor clearColor];
    [cell.quantity.layer setCornerRadius:5.0f];
    cell.quantity.text = [NSString stringWithFormat:@"%dx", (int) self.dishFooterView.stepper.value];


    cell.fullHeight = [NSNumber numberWithInt:cell.frame.size.height];
    cell.parent = self;
    cell.edit.parent = self;
    cell.remove.parent = self;
    
    cell.separator1.backgroundColor = [UIColor seperatorColor];
    cell.separator2.backgroundColor = [UIColor seperatorColor];
    
    cell.priceLabel.textColor = [UIColor scarletColor];

    
    [cell.edit_label.layer setBorderColor:[UIColor textColor].CGColor];
    [cell.edit_label.layer setBorderWidth:1.0f];
    [cell.edit_label.layer setCornerRadius:5.0f];
    cell.edit_label.backgroundColor = [UIColor textColor];
    cell.edit_label.textColor = [UIColor bgColor];
    
    [cell.remove_label.layer setBorderColor:[UIColor textColor].CGColor];
    [cell.remove_label.layer setBorderWidth:1.0f];
    [cell.remove_label.layer setCornerRadius:5.0f];
    cell.remove_label.backgroundColor = [UIColor textColor];
    cell.remove_label.textColor = [UIColor bgColor];
    
    original_fucking_frame = cell.frame;
    
    self.reviewCartCell = cell;
}

-(void) setupLowerHalf {
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    _KVOController = KVOController;
    self.autoresizingMask = UIViewAutoresizingNone;
    DishCellViewLowerHalf *cell = [[DishCellViewLowerHalf alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor bgColor];
    cell.contentView.backgroundColor = [UIColor bgColor];
    Dishes *dish = self.dish;
    
    CGRect f;
    CGSize maxSize;
    CGSize requiredSize;
    
    CGRect descFrame = CGRectMake(10, 5, 300, requiredSize.height);
    
    
    if([dish.description_text length] != 0){
        
        cell.descriptionLabel = [[UILabel alloc] init];
        cell.descriptionLabel.autoresizingMask = UIViewAutoresizingNone;
        cell.descriptionLabel.backgroundColor = [UIColor clearColor];
        cell.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        cell.descriptionLabel.textColor = [UIColor textColor];
        cell.descriptionLabel.text = @"Description";
        cell.descriptionLabel.font = [UIFont fontWithName:@"Copperplate-Bold" size:18.0f];
        [cell.descriptionLabel sizeToFit];
        
        maxSize = CGSizeMake(300.0f, CGFLOAT_MAX);
        requiredSize = [cell.descriptionLabel sizeThatFits:maxSize];
        
        descFrame = CGRectMake(10, 5, 300, requiredSize.height);
        cell.descriptionLabel.frame = descFrame;
        
        [cell.contentView addSubview:cell.descriptionLabel];
        
        CGRect f = cell.contentView.frame;
        f.size.height = cell.descriptionLabel.frame.size.height;
        cell.contentView.frame = f;
        
        cell.dishDescription = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        cell.dishDescription.autoresizingMask = UIViewAutoresizingNone;
        cell.dishDescription.backgroundColor = [UIColor clearColor];
        cell.dishDescription.textAlignment = NSTextAlignmentLeft;
        cell.dishDescription.textColor = [UIColor textColor];
        cell.dishDescription.text = dish.description_text;
        cell.dishDescription.font = [UIFont fontWithName:@"Newtext RG Bt" size:16.0f];
        cell.dishDescription.numberOfLines = 0;
        [cell.dishDescription sizeToFit];
        
        maxSize = CGSizeMake(300.0f, CGFLOAT_MAX);
        requiredSize = [cell.dishDescription sizeThatFits:maxSize];
        
        descFrame = CGRectMake(10, cell.contentView.frame.size.height + 5, 300, requiredSize.height);
        cell.dishDescription.frame = descFrame;
        
        [cell.contentView addSubview:cell.dishDescription];
        
        f = cell.contentView.frame;
        f.size.height = cell.contentView.frame.size.height + cell.dishDescription.frame.size.height + 10;
        cell.contentView.frame = f;
        
    }
    
    self.option_views = [[NSMutableArray alloc] init];
    _optionViews = [[NSMutableDictionary alloc] init];
    
    OptionsView *sizeObject;
    
    if([dish.sizes intValue] == 1){
        OptionsView *option_view = [[OptionsView alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
        option_view.optionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        option_view.optionTitle.backgroundColor = [UIColor clearColor];
        option_view.optionTitle.textAlignment = NSTextAlignmentLeft;
        option_view.optionTitle.textColor=[UIColor blackColor];
        option_view.optionTitle.font = [UIFont fontWithName:@"Copperplate-Bold" size:18.0f];
        [option_view addSubview:option_view.optionTitle];
        
        option_view.parent = self;
        option_view.tag = 12347;
        option_view.op = dish.sizes_object;
        
        [self.KVOController observe:option_view keyPath:@"total_price" options:NSKeyValueObservingOptionNew action:@selector(getCurrentPrice)];
        
        [option_view setupOption];
        
        CGRect frame = option_view.frame;
        frame.origin.y = cell.contentView.frame.size.height + 5;
        option_view.frame = frame;
        
        [cell.contentView addSubview:option_view];
        
        [option_views addObject:option_view];
        [_optionViews setObject:option_view forKey:dish.sizes_object.id];
        
        frame = cell.contentView.frame;
        frame.size.height = cell.contentView.frame.size.height + option_view.frame.size.height + 10;
        cell.contentView.frame = frame;
        sizeObject = option_view;
    }
    
    for(Options *options in dish.options){
        OptionsView *option_view = [[OptionsView alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
        option_view.optionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        option_view.optionTitle.backgroundColor = [UIColor clearColor];
        option_view.optionTitle.textAlignment = NSTextAlignmentLeft;
        option_view.optionTitle.textColor=[UIColor blackColor];
        option_view.optionTitle.font = [UIFont fontWithName:@"Copperplate-Bold" size:18.0f];
        [option_view addSubview:option_view.optionTitle];
        
        [self.KVOController observe:option_view keyPath:@"total_price" options:NSKeyValueObservingOptionNew action:@selector(setPrice)];
        
        if(dish.sizes){
            option_view.size_prices = sizeObject;
        }

        option_view.parent = self;
        option_view.tag = 12347;
        option_view.op = options;
        
        [option_view setupOption];
        
        CGRect frame = option_view.frame;
        frame.origin.y = cell.contentView.frame.size.height + 5;
        option_view.frame = frame;
        
        [cell.contentView addSubview:option_view];
        
        [option_views addObject:option_view];
        [_optionViews setObject:option_view forKey:options.id];
        
        frame = cell.contentView.frame;
        frame.size.height = cell.contentView.frame.size.height + option_view.frame.size.height + 10;
        cell.contentView.frame = frame;
    }
    
    cell.dish = dish;
    f = cell.contentView.frame;
    f.size.height = cell.contentView.frame.size.height + 50;
    cell.contentView.frame = f;
    cell.full_height = cell.contentView.frame.size.height;
    self.lower_half = cell;
    [self setPrice];
    
    // Add Dish Button
    DishFooterView *foot = [[[NSBundle mainBundle] loadNibNamed:@"DishFooterView" owner:self options:nil] objectAtIndex:0];
    foot.autoresizingMask = UIViewAutoresizingNone;
    UIButton *button = foot.add;
    foot.backgroundColor = [UIColor almostBlackColor];
    foot.parent = self;
    [button addTarget:self action:@selector(addDish:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Add" forState:UIControlStateNormal];
    [button.layer setCornerRadius:5.0f];
    button.backgroundColor = [UIColor bgColor];
    foot.quantity.backgroundColor = [UIColor bgColor];
    [foot.quantity.layer setCornerRadius:5.0f];
    self.dishFooterView = foot;
    UIStepper *stepper = self.dishFooterView.stepper;
    stepper.backgroundColor = [UIColor almostBlackColor];
    stepper.minimumValue = 1;
    stepper.maximumValue = 12;
    
}

-(void)addDish:(id)sender
{
    if(self.editing){
        self.editing = NO;
        [self.parent.navigationController popViewControllerAnimated:YES];
        REFrostedViewController *cu = (REFrostedViewController *)[self.parent.navigationController topViewController];
        ((MenuTableViewController *)(cu.frostedViewController.menuViewController)).shopping = YES;
        [((MenuTableViewController *)(cu.frostedViewController.menuViewController)).tableView reloadData];
        [cu.frostedViewController presentMenuViewController];
        return;
    } else if(self.final_editing){
        self.final_editing = NO;
        [self.parent.navigationController popViewControllerAnimated:YES];
        return;
    } else {
        [self setupShoppingCart];
        [self setupReviewCell];
        [self.parent addDish:self];
        [self.parent.navigationController popViewControllerAnimated:YES];
        return;
    }
}

-(float) getCurrentPrice {
    
    float total_price = 0.0f;
    
    if(self.dish.price == nil || [self.dish.sizes intValue] == 1){
        total_price = 0.0f;
    } else {
        total_price = [self.dish.price floatValue];
    }
    
    if(self.lower_half){
        for (OptionsView *priceView in [self.lower_half.contentView subviews]){
            if (priceView.tag == 12347){
                total_price += priceView.total_price;
            }
        }
    }
    int q = (int) self.dishFooterView.stepper.value;
    if (q == 0){
        q = 1;
    }
    total_price = total_price * q;
    totalPrice = total_price;
    return total_price;
}


-(NSString *) getPriceFast {
    return [NSString stringWithFormat:@"%.02f", [self getCurrentPrice]];
}

-(NSString *) getPriceString {
    return [NSString stringWithFormat:@"%.02f", [self getCurrentPrice]];
}

-(void) setPrice {
    self.priceLabel.text = [NSString stringWithFormat:@"%.02f", [self getCurrentPrice]];
    if(self.shoppingCartCell){
        [self setupShoppingCart];
        [self setupReviewCell];
    }
}

@end
