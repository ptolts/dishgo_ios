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
//        DishTableViewCell *c = (DishTableViewCell *)[self cellForRowAtIndexPath:indexPath];
        int size = LARGE_SIZE;
        for(id kkey in [heights allKeys]) {
            [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:kkey];
        }
        [heights setObject:[NSNumber numberWithInteger:size] forKey:key];
    } else {
        [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:key];
    }
    [self.tableViewController endUpdates];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (heights == nil){
        NSLog(@"Setting up height dict");
        [self setupHeight];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    if([heights valueForKey:key]){
        NSLog(@"%f",[[heights valueForKey:key] doubleValue]);
        return [[heights valueForKey:key] doubleValue];
    } else {
        [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:key];
        return DEFAULT_SIZE;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.shopping_cart count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DishTableViewCell *dish_view = [self.shopping_cart objectAtIndex:indexPath.row];
    return dish_view.shoppingCartCell;
}


@end
