//
//  OptionsView.m
//  Restaurants
//
//  Created by Philip Tolton on 11/14/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "OptionsView.h"
#import "Option.h"

@implementation OptionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OptionsView" owner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(0,0,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds));
        self.bounds = CGRectMake(0,0,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds));
        self.layer.bounds = self.bounds;
        self.layer.frame = self.frame;
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame;
{
    NSLog(@"%@", NSStringFromCGRect(frame));
    [super setFrame:frame];
}

- (void)setupOption
{

    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    self.optionTitle.text = self.op.name;
    
    for(Option *option in self.op.list){
        [itemArray addObject:[NSString stringWithFormat:@"%@: %@$",option.name,option.price]];
    }
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(5, self.frame.size.height + 5, self.frame.size.width - 10, 50);
    
    CGRect frame = self.frame;
    frame.size.height = self.frame.size.height + 55;
    self.frame = frame;
    
    segmentedControl.selectedSegmentIndex = 1;
    [self addSubview:segmentedControl];
    
    
//    self.layer.borderColor = [UIColor redColor].CGColor;
//    self.layer.borderWidth = 1.0f;
    [self.layer setCornerRadius:5.0f];
    self.layer.backgroundColor = [UIColor colorWithRed:(227.0/255) green:(227.0/255) blue:(227.0/255) alpha:1.0].CGColor;
    
//    NSLog(@"OPTIONS ----------------- %f",self.frame.size.height);
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.tag = 12345;
//    [button addTarget:self
//               action:@selector(fuck:)
//     forControlEvents:UIControlEventTouchDown];
//    [button setTitle:@"FUCK" forState:UIControlStateNormal];
//    
//    button.frame = CGRectMake(((self.frame.size.width - 120)/2), self.frame.size.height + 5, 222, 40);
//    [self addSubview:button];
}

-(void)fuck:(id)sender{
    NSLog(@"%f height FUCK",self.frame.size.height);
}

@end
