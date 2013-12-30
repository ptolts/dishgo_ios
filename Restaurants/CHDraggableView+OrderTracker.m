//
//  CHDraggableView+OrderTracker.m
//  Restaurants
//
//  Created by Philip Tolton on 12/30/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "CHDraggableView+OrderTracker.h"
#import <JSONModel/JSONHTTPClient.h>
#import "Order_Order.h"
#import "CHAvatarView.h"
#import "UserSession.h"

@implementation CHDraggableView (OrderTracker)

    @dynamic order_id;

    NSTimer *timer;

    -(void)timer:(NSNumber *)number{
        timer = [NSTimer scheduledTimerWithTimeInterval:10.0f
                                         target:self
                                       selector:@selector(checkForUpdates)
                                       userInfo:nil
                                        repeats:YES];
    }

    -(void) checkForUpdates {
        Order_Order *json_order = [[Order_Order alloc] init];
        json_order.order_id = self.order_id;
        json_order.foodcloud_token = [[UserSession sharedManager] foodcloud_token];
        NSString *json = [json_order toJSONString];
        
        //make post, get requests
        [JSONHTTPClient postJSONFromURLWithString:@"http://dev.foodcloud.ca:3000/api/v1/order/submit_order"
                                           params:@{@"order":json,@"foodcloud_token":json_order.foodcloud_token}
                                       completion:^(id json, JSONModelError *err) {
                                           NSLog(@"RESPONSE: %@",json);
                                           Order_Order *response = [[Order_Order alloc] initWithString:json error:nil];
                                           if(response.confirmed){
                                               for(CHAvatarView *v in [self subviews]){
                                                   if([v isKindOfClass:[CHAvatarView class]]){
                                                       [v setImage:];
                                                   }
                                               }
                                           }
                                       }];
    }
@end
