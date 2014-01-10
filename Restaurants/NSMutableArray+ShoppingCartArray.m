//
//  NSMutableArray+ShoppingCartArray.m
//  Restaurants
//
//  Created by Philip Tolton on 1/10/2014.
//  Copyright (c) 2014 Philip Tolton. All rights reserved.
//

#import "NSMutableArray+ShoppingCartArray.h"
#import "User.h"
#import "Order_Order.h"
#import "RAppDelegate.h"
#import <objc/runtime.h>


static char const * const identKey = "ObjectTag";

@implementation NSMutableArray (ShoppingCartArray)

    @dynamic ident;

    - (id)ident {
        return objc_getAssociatedObject(self, identKey);
    }

    - (void)setIdent:(id)newObjectTag {
        objc_setAssociatedObject(self, identKey, newObjectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    - (void) saveShoppingCart {
        NSLog(@"KEY FOR NSDEFAULT: %@",[self ident]);
        RAppDelegate *del = (RAppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary *cart_save = del.cart_save;
        User *user_for_order = [[User alloc] init];
        user_for_order.shopping_cart = self;
        Order_Order *json_order = [[Order_Order alloc] init];
        [json_order setupJsonWithUser:user_for_order];
        NSString *json = [json_order toJSONString];
        NSLog(@"Saving JSON: %@",json);
        [cart_save setObject:json forKey:[self ident]];
        [del saveCart];
    }

    -(void) addObjectThenSave:(id)anObject {
        [self addObject:anObject];
        [self saveShoppingCart];
    }
@end
