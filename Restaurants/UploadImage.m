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
#import "Constant.h"

@implementation UploadImage

    -(void) startUpload {
        [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@/app/api/v1/restaurant_admin/upload_image", dishGoUrl]
                                           params:[self toDictionary]
                                       completion:^(id json, JSONModelError *err) {
                                           
                                           
                                       }];
    }

    -(void) startUploadAfn {
        
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
                if(self.section_dish_view.progress){
                    float prog = ((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
                    // Make sure the view still exists
                    if(self.section_dish_view){
                        [self.section_dish_view.progress setProgress:prog animated:YES];
                        if(prog == 1.0f && self.section_dish_view.spinner.hidden == YES){
                            self.section_dish_view.spinner.hidden = NO;
                            [self.section_dish_view.spinner startAnimating];
                            self.section_dish_view.progress.hidden = YES;
                        }
                    }
                }
            }];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
                 NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                 NSLog(@"response: %@",jsons);
                if(self.section_dish_view){
                    self.section_dish_view.dishImage.hidden = NO;
                    self.section_dish_view.progress.hidden = YES;
                    self.section_dish_view.spinner.hidden = YES;
                    [self.section_dish_view.spinner stopAnimating];
                }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if([operation.response statusCode] == 403)
                 {
                     NSLog(@"Upload Failed");
                     return;
                 }
                 NSLog(@"error: %@", [operation error]);
             }];
            
            [operation start];
        }
    }
@end
