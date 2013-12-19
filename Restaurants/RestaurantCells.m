//
//  RestaurantCells.m
//  Restaurants
//
//  Created by Philip Tolton on 2013-10-08.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "RestaurantCells.h"

@implementation RestaurantCells

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    NSLog(@"touch cell!!");
    // If not dragging, send event to next responder
    [super touchesEnded: touches withEvent: event];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        NSLog(@"touch begin cell!! %@",super.class);
     [super touchesBegan:touches withEvent: event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
        NSLog(@"touch moved cell!!");
        [super touchesBegan:touches withEvent: event];
}

@end
