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

@implementation DishTableViewCell {
    float totalPrice;
}

-(void) setupShoppingCart {
    
    CartRowCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CartRowCell" owner:self options:nil] objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.dishTitle.text = self.dish.name;
    cell.priceLabel.text = [self getPrice];
    cell.backgroundColor = [UIColor clearColor];
    self.shoppingCartCell = cell;
}

-(void) setupLowerHalf {
    
    DishCellViewLowerHalf *cell = [[[NSBundle mainBundle] loadNibNamed:@"DishCellViewLowerHalf" owner:self options:nil] objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Dishes *dish = self.dish;
    
    cell.dishDescription.text = dish.description_text;
    
    if([dish.description_text length] == 0){
        
        int old_origin = cell.descriptionLabel.frame.origin.y;
        int height_change = cell.descriptionLabel.frame.size.height + cell.dishDescription.frame.size.height;
        
        [cell.descriptionLabel removeFromSuperview];
        [cell.dishDescription removeFromSuperview];
        
        CGRect f = cell.optionLabel.frame;
        f.origin.y = old_origin;
        cell.optionLabel.frame = f;
        
        f = cell.contentView.frame;
        f.size.height = f.size.height - height_change;
        cell.contentView.frame = f;
    }
    
    for(Options *options in dish.options){
        
        OptionsView *option_view = [[OptionsView alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
        option_view.optionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        option_view.optionTitle.backgroundColor = [UIColor clearColor];
        option_view.optionTitle.textAlignment = NSTextAlignmentCenter;
        option_view.optionTitle.textColor=[UIColor blackColor];
        [option_view addSubview:option_view.optionTitle];

        option_view.parent = self;
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
    
    cell.dish = dish;
    cell.full_height = cell.contentView.frame.size.height;
    self.lower_half = cell;
    [self setPrice];
    
    // Add Dish Button
    DishFooterView *foot = [[[NSBundle mainBundle] loadNibNamed:@"DishFooterView" owner:self options:nil] objectAtIndex:0];
    struct CGColor *mainColor = [UIColor colorWithRed:(62/255) green:(62/255) blue:(62/255) alpha:0.9].CGColor;
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *button = foot.add;
    [button addTarget:self action:@selector(addDish:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Add" forState:UIControlStateNormal];
//    int buttonSize = 40;
//    button.frame = CGRectMake(((cell.contentView.frame.size.width - 120)/2), cell.contentView.frame.size.height + 5, 120, buttonSize);
//    button.layer.borderColor = mainColor;
//    button.layer.backgroundColor = mainColor;
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor: [UIColor colorWithRed:(62/255) green:(62/255) blue:(62/255) alpha:1.0] forState:UIControlStateHighlighted];
//    button.layer.borderWidth=1.0f;
    [button.layer setCornerRadius:5.0f];
    [foot.quantity.layer setCornerRadius:5.0f];
    self.dishFooterView = foot;
//    [cell.contentView addSubview:button];
    UIStepper *stepper = self.dishFooterView.stepper;
    stepper.minimumValue = 1;
    stepper.maximumValue = 12;
    
}

-(void)addDish:(id)sender
{
    [self setupShoppingCart];
    [self.parent addDish:self];
    [self.parent.navigationController popViewControllerAnimated:YES];
}

-(NSString *) getPrice {
    
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
    
    return [NSString stringWithFormat:@"%.02f", totalPrice];
}

-(NSString *) getPriceFast {
    
    if(self.dish.price == nil){
        totalPrice = 0.0f;
    } else {
        totalPrice = [self.dish.price floatValue];
    }
    
    return [NSString stringWithFormat:@"%.02f", totalPrice];
}


-(void) setPrice {
    NSLog(@"Updating price %@",[self getPrice]);
    self.priceLabel.text = [self getPrice];
}

@end
