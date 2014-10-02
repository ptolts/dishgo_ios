//
//  UploadImage.m
//  DishGo
//
//  Created by Philip Tolton on 2014-05-21.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "UploadImage.h"
#import <JSONHTTPClient.h>
#import <AFNetworking.h>
#import "UserSession.h"
#import "Constant.h"

@implementation UploadImage

    -(void) startUpload {
        [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@/app/api/v1/restaurant_admin/upload_image", dishGoUrl]
                                           params:[self toDictionary]
                                       completion:^(id json, JSONModelError *err) {
                                           
                                           
                                       }];
    }

    -(void) startUploadAfn {
        
        UserSession *session = [UserSession sharedManager];
        self.dishgo_token = [session fetchUser].dishgo_token;
        
        if (self.raw_image_data)
        {
            self.image_data = @"";
            NSDictionary *parameters = [self toDictionary];
            
            AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:dishGoUrl]];
            
            NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"/app/api/v1/restaurant_admin/upload_image_file" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                [formData appendPartWithFileData: self.raw_image_data name:@"image" fileName:@"temp.jpg" mimeType:@"image/jpeg"];
            }];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                float prog = ((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.progress_view){
                        [self.progress_view setProgress:prog];
                    } 
                });
            }];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
                 NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                 NSLog(@"response: %@",jsons);
                if(self.dish){
//                    NSManagedObjectContext *context = self.dish.managedObjectContext;
//                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Images" inManagedObjectContext:context];
                    Images *img = [[Images alloc] init];
                    img.url = [jsons objectForKey:@"url"];
                    [session completeLogin];
                    NSMutableArray *copy_array = [[NSMutableArray alloc] initWithArray:self.dish.images];
                    [copy_array insertObject:img atIndex:0];
                    self.dish.images = [[NSOrderedSet alloc] initWithArray:[copy_array copy]];
                    if(self.uitableview){
                        if([self.uitableview respondsToSelector:@selector(setupHeader)]){
                            [self.uitableview performSelector:@selector(setupHeader)];
                        }
                        [self.uitableview.tableView reloadData];
                    }
                    [self.progress_view setProgress:1.1f];
                }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if([operation.response statusCode] == 403)
                 {
                     NSLog(@"Upload Failed");
                 }
                 NSLog(@"error: %@", [operation error]);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.progress_view setProgress:1.1f];
                 });
                 [self launchDialog:NSLocalizedString(@"We are having difficulty connecting to the internet.",nil)];
             }];
            
            [operation start];
        }
    }

    - (void)launchDialog:(NSString *)msg
    {
        // Here we need to pass a full frame
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
        UIView *msg_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,260,100)];
        // Add some custom content to the alert view
        UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 240, 100)];
        message.text = msg;
        message.numberOfLines = 0;
        message.textAlignment = NSTextAlignmentCenter;
        message.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
        [msg_view addSubview:message];
        [alertView setContainerView:msg_view];
        
        // Modify the parameters
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Ok", nil]];
        
        // You may use a Block, rather than a delegate.
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            [alertView close];
        }];
        
        [alertView setUseMotionEffects:true];
        
        // And launch the dialog
        [alertView show];
    }
@end
