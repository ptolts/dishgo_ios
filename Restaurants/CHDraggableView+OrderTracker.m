//
//  CHDraggableView+OrderTracker.m
//  Restaurants
//
//  Created by Philip Tolton on 12/30/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "CHDraggableView+OrderTracker.h"
#import <JSONModel/JSONHTTPClient.h>
#import "Order_Status.h"
#import "CHAvatarView.h"
#import "UserSession.h"

@implementation CHDraggableView (OrderTracker)

    NSTimer *timer;

    -(void) set_order_id:(NSString *)order_id {
        self.order_id = order_id;
    }

    -(void)timer:(NSNumber *)number{
        NSLog(@"Timer Initiated");
        timer = [NSTimer scheduledTimerWithTimeInterval:[number floatValue]
                                         target:self
                                       selector:@selector(checkForUpdates)
                                       userInfo:nil
                                        repeats:YES];
    }

    -(void) checkForUpdates {
        NSLog(@"Checking Order Status");        
        Order_Status *json_order = [[Order_Status alloc] init];
        json_order.order_id = self.order_id;
        json_order.foodcloud_token = ((UserSession *)([UserSession sharedManager])).foodcloudToken;
        NSString *json = [json_order toJSONString];
        NSLog(@"CHECKFORUPDATES: %@",json);
        //make post, get requests
        [JSONHTTPClient postJSONFromURLWithString:@"http://dev.foodcloud.ca:3000/api/v1/order/status"
                                           params:@{@"order":json,@"foodcloud_token":json_order.foodcloud_token}
                                       completion:^(NSDictionary *json, JSONModelError *err) {
                                           NSLog(@"RESPONSE: %@",json);
                                           Order_Status *response = [[Order_Status alloc] initWithDictionary:json error:nil];
                                           NSLog(@"Confirmed: %hhd",response.confirmed);
                                           if(response.confirmed == 1){
                                               for(CHAvatarView *v in [self subviews]){
                                                   if([v isKindOfClass:[CHAvatarView class]]){
                                                       NSLog(@"Setting new image");
                                                       UIImage *img = [UIImage imageNamed:@"stop_watch_confirmed.png"];
                                                       v.image_view.image = img;
//                                                       UIImageView *img_view = [[UIImageView alloc] initWithImage:img];
//                                                       [v addSubview:img_view];
                                                   }
                                               }
                                               [timer invalidate];
                                               timer = nil;
                                           }
                                       }];
    }
@end
