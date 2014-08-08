//
//  DishCoinButton.m
//  DishGo
//
//  Created by Philip Tolton on 2014-07-28.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "DishCoinButton.h"
#import <FAKFontAwesome.h>

@implementation DishCoinButton
- (DishCoinButton *) init: (id) target {
//    NSMutableAttributedString *attributionMas = [[NSMutableAttributedString alloc] init];
//    FAKFontAwesome *check = [FAKFontAwesome btcIconWithSize:18.0f];
//    [check addAttribute:NSForegroundColorAttributeName value:[UIColor scarletColor]];
//    [attributionMas appendAttributedString:[check attributedString]];
//    UIImage *b = [check imageWithSize:CGSizeMake(30.0,30.0)];
//    UIImage *b = [[UIImage alloc] initWithContentsOfFile:@"dishcoin@2x.png"];
    UIImage *b = [UIImage imageNamed:@"dishcoin@2x.png"];
    UIImageView *a = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    a.image = b;
    a.contentMode = UIViewContentModeScaleAspectFit;
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [c addSubview:a];
    [c addTarget:target action:@selector(cartClick:) forControlEvents:UIControlEventTouchUpInside];
    self = [[DishCoinButton alloc] initWithCustomView:c];
    return self;
}
@end
