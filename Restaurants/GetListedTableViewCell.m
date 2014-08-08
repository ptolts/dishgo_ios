//
//  GetListedTableViewCell.m
//  DishGo
//
//  Created by Philip Tolton on 2014-08-06.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "GetListedTableViewCell.h"

@implementation GetListedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
