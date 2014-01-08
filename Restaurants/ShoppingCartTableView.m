//
//  ShoppingCartTableView.m
//  Restaurants
//
//  Created by Philip Tolton on 11/13/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "ShoppingCartTableView.h"
#import "DishTableViewCell.h"
#import "DishViewCell.h"
#import "Dishes.h"

#define DEFAULT_SIZE 43
#define LARGE_SIZE 86

@implementation ShoppingCartTableView {
    NSMutableDictionary *heights;
}

@synthesize junk;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setupHeight {
    heights = [[NSMutableDictionary alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (heights == nil){
        NSLog(@"Setting up height dict");
        [self setupHeight];
    }

    [self.tableViewController beginUpdates];
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    if([[heights valueForKey:key] integerValue] == DEFAULT_SIZE){
        int size = LARGE_SIZE;
        for(id kkey in [heights allKeys]) {
            [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:kkey];
        }
        [heights setObject:[NSNumber numberWithInteger:size] forKey:key];
    } else {
        [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:key];
    }
    [self.tableViewController endUpdates];
    

    if(((int)indexPath.row + 1) == [self.shopping_cart count]){
        [self.tableViewController scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated: YES];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (heights == nil){
        [self setupHeight];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    if([heights valueForKey:key]){
        return [[heights valueForKey:key] doubleValue];
    } else {
        [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:key];
        return DEFAULT_SIZE;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shopping_cart count];// + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.shopping_cart count] == 0){
        int height = self.tableViewController.frame.size.height - junk - self.tableViewController.tableHeaderView.frame.size.height - self.tableViewController.tableFooterView.frame.size.height;
        int width = self.tableViewController.frame.size.width;
        UITableViewCell *c = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        c.backgroundColor = [UIColor clearColor];
        c.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *empty = [[UILabel alloc] init];
        empty.text = @"Your cart is empty!";
        empty.textColor = [UIColor nextColor];
        [empty sizeToFit];
        CGRect f = empty.frame;
        f.origin.y = height/2.0;
        f.origin.x = (width / 2.0) - (f.size.width / 2.0);
        empty.frame = f;
        [c addSubview:empty];
        return c;
    }
    
    DishTableViewCell *dish_view = [self.shopping_cart objectAtIndex:indexPath.row];
    return dish_view.shoppingCartCell;
}


@end
