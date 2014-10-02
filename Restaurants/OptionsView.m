//
//  OptionsView.m
//  Restaurants
//
//  Created by Philip Tolton on 11/14/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "OptionsView.h"
#import "Option.h"
#import "DishTableViewCell.h"
#import "Option_Order.h"
#import "OptionButton.h"

@implementation OptionsView {
    NSMutableArray *option_values;
    NSMutableArray *buttonList;
    NSMutableDictionary *buttonList_dict;
    NSMutableDictionary *option_order_json_dict;
    float totalPrice;
    UIColor *mainColor;
    struct CGColor *mainCGColor;
    BOOL useButton;
}

@synthesize option_order_json;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    _KVOController = KVOController;
    return self;
}


- (void)setupBut
{
    buttonList = [[NSMutableArray alloc] init];
    buttonList_dict = [[NSMutableDictionary alloc] init];
    
//    self.optionTitle.text = self.op.name;
    self.optionTitle.text = [self.op.name uppercaseString];
    mainColor = [UIColor textColor];
    mainCGColor = mainColor.CGColor;
    
    CGSize maxSize;
    CGSize requiredSize;
    CGRect descFrame;
    maxSize = CGSizeMake(300.0f, CGFLOAT_MAX);
    requiredSize = [self.optionTitle sizeThatFits:maxSize];
    descFrame = CGRectMake(0, 0, 320, requiredSize.height);
    self.frame = descFrame;
    descFrame = CGRectMake(10, 0, 300, requiredSize.height);
    self.optionTitle.frame = descFrame;
    
    int index = 0;
    BOOL odd = ([option_values count] % 2 == 1);
    int last = [option_values count] - 1;
    for(NSMutableArray *option in option_values){
        Option *option_for_button = option[3];
        CGRect button_frame;
        int buttonSize = 40;
//        if (index % 2 == 0){
//            button_frame = CGRectMake(10, self.frame.size.height + 5, (self.frame.size.width/2) - 20, buttonSize);
//        } else {
//            button_frame = CGRectMake((self.frame.size.width/2) + 10, self.frame.size.height + 5, (self.frame.size.width/2) - 20, buttonSize);
//        }
        // make last button full size if the count is odd.
//        if(odd && index == last){
            button_frame = CGRectMake(10, self.frame.size.height + 5, self.frame.size.width - 20, buttonSize);
//        }
        
        OptionButton *button = [[OptionButton alloc] initWithFrame:button_frame];
        button.option = option_for_button;
        [button setup];
        [self.KVOController observe:button keyPath:@"selected" options:NSKeyValueObservingOptionNew action:@selector(getCurrentPrice)];
        [self.KVOController observe:button keyPath:@"price" options:NSKeyValueObservingOptionNew action:@selector(getCurrentPrice)];
        [buttonList_dict setObject:button forKey:option_for_button.id];
        [button addTarget:self action:@selector(addOpt:) forControlEvents:UIControlEventTouchUpInside];

        
//        button.adjustsImageWhenHighlighted = NO;
//        button.clipsToBounds = YES;
        
//        if (index % 2 == 1 || (index + 1) == [option_values count]){
            CGRect frame = self.frame;
            frame.size.height = self.frame.size.height + (buttonSize + 10);
            self.frame = frame;
//        }
    
        button.tag = index;
        [buttonList addObject:button];
        button.adjustsImageWhenHighlighted = NO;
        [self addSubview:button];
        index++;
    }
    [self.layer setCornerRadius:5.0f];
}

- (void) setupFromJson:(NSMutableArray<Option_Order> *)json {
    for(Option_Order *o in json){
        Option_Order *new_opt_order = [option_order_json_dict objectForKey:o.ident];
        OptionButton *button = [buttonList_dict objectForKey:o.ident];
        if(o.selected){
            [self addOpt:(id)button];
            new_opt_order.selected = YES;
        }
    }
}

- (void)setupOption
{
    option_values = [[NSMutableArray alloc] init];
    option_order_json_dict = [[NSMutableDictionary alloc] init];
    option_order_json = (NSMutableArray<Option_Order> *)[[NSMutableArray alloc] init];
    
    for(Option *option in self.op.list){
        Option_Order *opt = [[Option_Order alloc] init];
        opt.name = option.name;
        opt.selected = NO;
        if(option.price_according_to_size){
            [self.KVOController observe:self.size_prices keyPath:@"selectedSize" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(OptionsView *observe, OptionsView *object, NSDictionary *change) {
                for(OptionButton *but in buttonList){
                    if(but.option.price_according_to_size){
                        [but updatePrice:change[@"new"]];
                    }
                }
            }];
        }
        opt.ident = option.id;
        [option_order_json addObject:opt];
        [option_order_json_dict setObject:opt forKey:opt.ident];
        NSMutableArray *currentItem = [[NSMutableArray alloc] init];
        [currentItem addObject:option.name];
        [currentItem addObject:option.price];
        [currentItem addObject:option.id];
        // I have no idea why I didnt use a custom object before. Must have been a newb. No time to rewrite.
        [currentItem addObject:option];
        [option_values addObject:currentItem];
    }
    
        [self setupBut];
    
    if (([self.op.type isEqual: @"size"])){
        // Bad name, but this makes sure only one item can be selected at once.
        useButton = YES;
        OptionButton *selected_button = (OptionButton *)[buttonList firstObject];
        [self addOpt:selected_button];
    }

    self.full_height = self.frame.size.height;
    
}

-(void)updatePrice:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSMutableArray *p = (NSMutableArray *)[option_values objectAtIndex:segmentedControl.selectedSegmentIndex];
    totalPrice = [p[1] floatValue];
    [self.parent setPrice];
}

-(void)addOpt:(id)sender {
    
    OptionButton *selected_button = (OptionButton *)sender;
    
    if (([self.op.type isEqual: @"size"]) && selected_button.selected){
        return;
    }
    
    if(useButton){
        for(OptionButton *but in buttonList){
            if(but.selected){
                if(but != sender){
                    totalPrice -= [but.option.price floatValue];
                    [but setSelected:![but isSelected]];
                    Option_Order *o = [option_order_json objectAtIndex:but.tag];
                    o.selected = !o.selected;
                }
            }
        }
    } else {
        int selected_count = 0;
        OptionButton *not_the_selected_button;
        for(OptionButton *but in buttonList){
            // grab this reference for later. we may need to deselect something.
            if(!not_the_selected_button && but != selected_button && but.selected){
                not_the_selected_button = but;
            }
            if(but.selected){
                selected_count++;
            }
        }
        // Advanced options selected, as in a min and max number of individual options set
        if(self.op.advanced){
            // Just in case we'll recalculate total selected.
            selected_count = 0;
            for(OptionButton *but in buttonList){
                if(but.selected){
                    selected_count++;
                }
            }
            if(!selected_button.selected && selected_count == [self.op.max_selections intValue]){
                //If the selected button wasn't selected and we're already at our max count, let deselect a selected button. But we'll make sure there is one.
                if(not_the_selected_button){
                    [self addOpt:not_the_selected_button];
                } else {
                return;
                }
            }
        }
    }
    
    [selected_button setSelected:![selected_button isSelected]];
    
    Option_Order *o = [option_order_json objectAtIndex:selected_button.tag];
    o.selected = !o.selected;
    
    if([self.op.type isEqualToString:@"size"]){
        self.selectedSize = selected_button.option.id;
    }
    
    if(selected_button.selected){
        totalPrice += [selected_button.option.price floatValue];
        [self.parent setPrice];
    } else {
        totalPrice -= [selected_button.option.price floatValue];
        [self.parent setPrice];
    }
}

-(float) getPrice {
    return totalPrice;
}

-(void) getCurrentPrice {
    float total_price = 0.0;
    for(OptionButton *but in buttonList){
        if(but.selected){
            total_price += [but.option.price floatValue];
        }
    }
    self.total_price = total_price;
}

@end
