//
//  ReviewTableCell.m
//  Restaurants
//
//  Created by Philip Tolton on 1/8/2014.
//  Copyright (c) 2014 Philip Tolton. All rights reserved.
//

#import "ReviewTableCell.h"

@implementation ReviewTableCell

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

-(void)layoutSubviews {
    NSLog(@"FRAME %@",CGRectCreateDictionaryRepresentation(self.bounds));
    [super layoutSubviews];
}

@end
