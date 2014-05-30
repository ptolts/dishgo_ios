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
- (void)setupSeg
{
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    self.optionTitle.text = self.op.name;
    
    for(NSMutableArray *option in option_values){
        [itemArray addObject:[NSString stringWithFormat:@"%@: %@$",option[0],option[1]]];
    }
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(5, self.frame.size.height + 5, self.frame.size.width - 10, 50);
    
    useButton = YES;
    
    if(useButton){
        [self setupBut];
    } else {
        //    segmentedControl.selectedSegmentIndex = 1;
        CGRect frame = self.frame;
        frame.size.height = self.frame.size.height + 75;
        self.frame = frame;
        [segmentedControl addTarget:self action:@selector(updatePrice:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:segmentedControl];
        [self.layer setCornerRadius:5.0f];
//        self.layer.backgroundColor = [UIColor colorWithRed:(250.0/255.0) green:(250.0/255.0) blue:(250.0/255.0) alpha:1.0].CGColor;
    }
}

- (void)setupBut
{
    buttonList = [[NSMutableArray alloc] init];
    buttonList_dict = [[NSMutableDictionary alloc] init];
    
    self.optionTitle.text = self.op.name;
    mainColor = [UIColor colorWithRed:(62/255) green:(62/255) blue:(62/255) alpha:0.9];
    mainCGColor = mainColor.CGColor;
    
    int index = 0;
    BOOL odd = ([option_values count] % 2 == 1);
    int last = [option_values count] - 1;
    for(NSMutableArray *option in option_values){
        Option *option_for_button = option[3];
        OptionButton *button = [OptionButton buttonWithType:UIButtonTypeRoundedRect];
        [self.KVOController observe:button keyPath:@"selected" options:NSKeyValueObservingOptionNew action:@selector(getCurrentPrice)];
        [self.KVOController observe:button keyPath:@"price" options:NSKeyValueObservingOptionNew action:@selector(getCurrentPrice)];
        [buttonList_dict setObject:button forKey:option_for_button.id];
        [button addTarget:self action:@selector(addOpt:) forControlEvents:UIControlEventTouchUpInside];
        
        int buttonSize = 40;
        
        if (index % 2 == 0){
            button.frame = CGRectMake(5, self.frame.size.height + 5, (self.frame.size.width/2) - 10, buttonSize);
        } else {
            button.frame = CGRectMake((self.frame.size.width/2) + 5, self.frame.size.height + 5, (self.frame.size.width/2) - 10, buttonSize);
        }
        
        // make last button full size if the count is odd.
        if(odd && index == last){
            button.frame = CGRectMake(5, self.frame.size.height + 5, self.frame.size.width - 10, buttonSize);
        }
        
        button.layer.borderColor = mainCGColor;
        button.layer.backgroundColor = [UIColor bgColor].CGColor;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:[NSString stringWithFormat:@"%@\n$%@",option_for_button.name,option_for_button.price] forState:UIControlStateNormal];
        [button setTitleColor:mainColor forState:UIControlStateNormal];
        button.layer.borderWidth=1.0f;
        [button.layer setCornerRadius:3.0f];
        
        button.adjustsImageWhenHighlighted = NO;
        button.clipsToBounds = YES;
        
        if (index % 2 == 1 || (index + 1) == [option_values count]){
            CGRect frame = self.frame;
            frame.size.height = self.frame.size.height + (buttonSize + 10);
            self.frame = frame;
        }
        
        button.option = option_for_button;
        
        button.tag = index;
        [buttonList addObject:button];
        button.adjustsImageWhenHighlighted = NO;
        [self addSubview:button];
        index++;
    }
    [self.layer setCornerRadius:5.0f];
//    self.layer.backgroundColor = [UIColor colorWithRed:(250.0/255.0) green:(250.0/255.0) blue:(250.0/255.0) alpha:1.0].CGColor;
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
    option_order_json = [[NSMutableArray alloc] init];
    option_values = [[NSMutableArray alloc] init];

    option_order_json_dict = [[NSMutableDictionary alloc] init];
//    option_values_dict = [[NSMutableDictionary alloc] init];
    
    for(Option *option in self.op.list){
        Option_Order *opt = [[Option_Order alloc] init];
        opt.name = option.name;
        opt.selected = NO;
        if(option.price_according_to_sizeValue){
            [self.KVOController observe:self.size_prices keyPath:@"selectedSize" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(OptionsView *observe, OptionsView *object, NSDictionary *change) {
                for(OptionButton *but in buttonList){
                    if(but.option.price_according_to_sizeValue){
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
    
    if (([self.op.type isEqual: @"size"])){
        [self setupSeg];
    } else {
        [self setupBut];
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
    
    if(useButton){
        for(OptionButton *but in buttonList){
            if(but.selected){
                NSMutableArray *p = (NSMutableArray *)[option_values objectAtIndex:but.tag];
                if(but != sender){
                    totalPrice -= [but.option.price floatValue];
                    [but setSelected:![but isSelected]];
                    Option_Order *o = [option_order_json objectAtIndex:but.tag];
                    o.selected = !o.selected;
                    but.layer.backgroundColor = [UIColor whiteColor].CGColor;
                    [but setTitleColor:mainColor forState:UIControlStateNormal];
                }
            }
        }
    }
    
    OptionButton *but = (OptionButton *)sender;
    NSMutableArray *p = (NSMutableArray *)[option_values objectAtIndex:but.tag];
    [but setSelected:![but isSelected]];
    
    Option_Order *o = [option_order_json objectAtIndex:but.tag];
    o.selected = !o.selected;
    
    if([self.op.type isEqualToString:@"size"]){
        self.selectedSize = but.option.id;
    }
    
    if(but.selected){
        totalPrice += [but.option.price floatValue];
        but.layer.backgroundColor = mainCGColor;
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.parent setPrice];
    } else {
        totalPrice -= [but.option.price floatValue];
        but.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [but setTitleColor:mainColor forState:UIControlStateNormal];
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
    NSLog(@"TOTAL PRICE: %f",self.total_price);
}

@end
