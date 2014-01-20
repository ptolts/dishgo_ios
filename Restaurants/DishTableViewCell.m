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
    NSLog(@"%@", NSStringFromCGRect(frame));
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
//    
//    if([old_text isEqualToString:opt_text]){
//        NSLog(@"Not Modifying");
//        return _reviewCartCell;
//    }
//    
//    NSLog(@"Modifying[%@] [%@] = [%@]",self,old_text,opt_text);
//    if([opt_text length] == 0){
//        CGRect frame = _reviewCartCell.move_me_up_and_down.frame;
//        frame.origin.y -= _reviewCartCell.dish_options.frame.size.height;
//        _reviewCartCell.move_me_up_and_down.frame = frame;
////        frame = _reviewCartCell.contentView.frame;
////        frame.size.height -= _reviewCartCell.dish_options.frame.size.height;
////        _reviewCartCell.contentView.frame = frame;
//    } else {
//        CGRect frame = _reviewCartCell.move_me_up_and_down.frame;
//        frame.origin.y += _reviewCartCell.dish_options.frame.size.height;
//        _reviewCartCell.move_me_up_and_down.frame = frame;
////        frame = _reviewCartCell.contentView.frame;
////        frame.size.height += _reviewCartCell.dish_options.frame.size.height;
////        _reviewCartCell.contentView.frame = frame;
//    }
//    
//    old_text = [opt_text copy];
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
    NSLog(@"INITIAL CARTROWCELL HEIGHT: %f",cell.frame.size.height);
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
    
//    cell.priceLabel.font = [UIFont fontWithName:@"6809 Chargen" size:13.0f];
//    cell.dishTitle.font = [UIFont fontWithName:@"6809 Chargen" size:14.0f];
    
    cell.backgroundColor = [UIColor clearColor];
    [cell.quantity.layer setCornerRadius:5.0f];
    cell.quantity.text = [NSString stringWithFormat:@"%dx", (int) self.dishFooterView.stepper.value];
    NSLog(@"INITIAL CARTROWCELL HEIGHT: %f",cell.frame.size.height);
//    cell.quantity.font = [UIFont fontWithName:@"6809 Chargen" size:13.0f];
    cell.fullHeight = [NSNumber numberWithInt:cell.frame.size.height];
    cell.parent = self;
    cell.edit.parent = self;
    cell.remove.parent = self;
    
    cell.separator1.backgroundColor = [UIColor seperatorColor];
    cell.separator2.backgroundColor = [UIColor seperatorColor];
    
    cell.priceLabel.textColor = [UIColor scarletColor];
    
//    [cell.edit.layer setBorderColor:[UIColor seperatorColor].CGColor];
//    [cell.edit.layer setBorderWidth:1.0f];
//    [cell.edit.layer setCornerRadius:5.0f];
//    
//    [cell.remove.layer setBorderColor:[UIColor seperatorColor].CGColor];
//    [cell.remove.layer setBorderWidth:1.0f];
//    [cell.remove.layer setCornerRadius:5.0f];
    
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
    self.autoresizingMask = UIViewAutoresizingNone;
    DishCellViewLowerHalf *cell = [[DishCellViewLowerHalf alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
//    [cell setNeedsLayout];
//    cell.frame = CGRectMake(10, 0, 300, 0);
//    cell.contentView.frame = CGRectMake(10, 0, 300, 0);
    NSLog(@"DESCRIPTION PAGE FRAME%@\nCONTENTVIEWFRAME: %@\n%u",CGRectCreateDictionaryRepresentation(cell.frame),CGRectCreateDictionaryRepresentation(cell.contentView.frame),cell.autoresizingMask);
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor bgColor];
    cell.contentView.backgroundColor = [UIColor bgColor];
    Dishes *dish = self.dish;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 200)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingNone;
    imageView.clipsToBounds = YES;
    
    cell.dishImage = imageView;
    [cell.contentView addSubview:imageView];
    cell.dishImage.image = [UIImage imageNamed:@"camera_mark.png"];
    
    CGRect f = cell.contentView.frame;
    f.size.height = imageView.frame.size.height;
    cell.contentView.frame = f;
    
    if([dish.images count] > 0){
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
        
    }
    
    if([dish.description_text length] != 0){
        
        cell.descriptionLabel = [[UILabel alloc] init];
        cell.descriptionLabel.autoresizingMask = UIViewAutoresizingNone;
        cell.descriptionLabel.backgroundColor = [UIColor clearColor];
        cell.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        cell.descriptionLabel.textColor = [UIColor textColor];
        cell.descriptionLabel.text = @"Description";
        cell.descriptionLabel.font = [UIFont fontWithName:@"Copperplate-Bold" size:18.0f];
        [cell.descriptionLabel sizeToFit];
        cell.descriptionLabel.frame = CGRectMake(10, cell.contentView.frame.size.height, 300, cell.descriptionLabel.frame.size.height);
        
        CGRect f = cell.contentView.frame;
        f.size.height = cell.contentView.frame.size.height + cell.descriptionLabel.frame.size.height + 10;
        cell.contentView.frame = f;
        
        [cell.contentView addSubview:cell.descriptionLabel];
        
        cell.dishDescription = [[UILabel alloc] initWithFrame:CGRectMake(0,0,500,500)];
        cell.dishDescription.autoresizingMask = UIViewAutoresizingNone;
        cell.dishDescription.backgroundColor = [UIColor clearColor];
        cell.dishDescription.textAlignment = NSTextAlignmentLeft;
        cell.dishDescription.textColor = [UIColor textColor];
        cell.dishDescription.text = dish.description_text;
        cell.dishDescription.font = [UIFont fontWithName:@"Copperplate" size:16.0f];
        cell.dishDescription.numberOfLines = 0;
        [cell.dishDescription sizeToFit];
        cell.dishDescription.frame = CGRectMake(10, cell.contentView.frame.size.height, 300, cell.dishDescription.frame.size.height + 20);
        
        f = cell.contentView.frame;
        f.size.height = cell.contentView.frame.size.height + cell.dishDescription.frame.size.height + 10;
        cell.contentView.frame = f;
        
        [cell.contentView addSubview:cell.dishDescription];
        
        NSLog(@"%@",CGRectCreateDictionaryRepresentation(cell.frame));
    }
    
    self.option_views = [[NSMutableArray alloc] init];
    _optionViews = [[NSMutableDictionary alloc] init];
    
    for(Options *options in dish.options){
        
        OptionsView *option_view = [[OptionsView alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
        option_view.optionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        option_view.optionTitle.backgroundColor = [UIColor clearColor];
        option_view.optionTitle.textAlignment = NSTextAlignmentCenter;
        option_view.optionTitle.textColor=[UIColor blackColor];
        option_view.optionTitle.font = [UIFont fontWithName:@"Copperplate-Bold" size:18.0f];
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

-(float) getPrice {
    
    if(self.dish.price == nil){
        totalPrice = 0.0f;
    } else {
        totalPrice = [self.dish.price floatValue];
    }
    
    if(self.lower_half){
        for (OptionsView *priceView in [self.lower_half.contentView subviews]){
//            NSLog(@"Querying price on view with tag %d and class of %@",priceView.tag,priceView.class);
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
        [self setupReviewCell];
    }
}

@end
