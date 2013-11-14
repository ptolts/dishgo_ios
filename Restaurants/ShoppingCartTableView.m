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

@implementation ShoppingCartTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.shopping_cart count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DishTableViewCell";
    
    DishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DishTableViewCell" owner:self options:nil] objectAtIndex:0];
    } else {
        
    }
    
    Dishes *dish = (Dishes *)[self.shopping_cart objectAtIndex:indexPath.row];
    cell.dishTitle.text = dish.name;
    
    return cell;
}


@end
