//
//  Order_Order.m
//  Restaurants
//
//  Created by Philip Tolton on 12/20/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "Order_Order.h"
#import "DishTableViewCell.h"
#import "OptionsView.h"
#import "Restaurant.h"



@implementation Order_Order

@synthesize billing_address;
@synthesize delivery_address;
@synthesize restaurant_id;
@synthesize order;
@synthesize total_cost;
@synthesize foodcloud_token;

    -(void)setupJsonWithUser:(User *)user {
        billing_address = [[Address_Order alloc] initBillingWithUser:user];
        delivery_address = [[Address_Order alloc] initDeliveryWithUser:user];
        foodcloud_token = user.foodcloud_token;
        restaurant_id = user.restaurant.id;
        
        NSMutableArray *order_mutable = [[NSMutableArray alloc] init];
        total_cost = 0.0f;
        
        for(DishTableViewCell *dish_cell in user.shopping_cart){
            Dish_Order *dish = [[Dish_Order alloc] initWithDishCell:dish_cell];
            total_cost += dish_cell.getPrice;
            [order_mutable addObject:dish];
        }
        
        self.order = [order_mutable copy];
    }

    -(NSMutableArray *) reverseJsonWithRestaurant:(Restaurant *)resto {

        NSMutableArray *cart_mutable = [[NSMutableArray alloc] init];
        NSDictionary *dishes = resto.dishDictionary;
        
        for(Dish_Order *dish in order){
//            NSLog(@"%@",[dish toJSONString]);
            Dishes *dish_object = [dishes objectForKey:dish.ident];
            DishTableViewCell *dish_logic = [[[NSBundle mainBundle] loadNibNamed:@"DishTableViewCell" owner:self options:nil] objectAtIndex:0];
            dish_logic.dish = dish_object;
            dish_logic.dishTitle.text = dish_object.name;
            dish_logic.priceLabel.backgroundColor = [UIColor bgColor];
            [dish_logic setupLowerHalf];
            [dish_logic setupShoppingCart];
            [dish_logic.dishFooterView.stepper setValue:dish.quantity];
            [dish_logic.dishFooterView stepperValueChanged:dish_logic.dishFooterView.stepper];
//            NSLog(@"Quantity: %d",dish.quantity);
            [dish_logic setupReviewCell];
            for(Options_Order *o_item in dish.options){
                OptionsView *o_view = [dish_logic.optionViews objectForKey:o_item.ident];
                [o_view setupFromJson:[o_item.options copy]];
            }
            [dish_logic setPrice];
            [cart_mutable addObject:dish_logic];
        }
        
        return cart_mutable;
    }

    +(BOOL)propertyIsOptional:(NSString*)propertyName
    {
        NSLog(@"%@",propertyName);
        return YES;
    }

@end
