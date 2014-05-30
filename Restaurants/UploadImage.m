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
@implementation UploadImage
    -(void) startUpload {
        [JSONHTTPClient postJSONFromURLWithString:@"http://192.168.1.132:3000/app/api/v1/restaurant_admin/upload_image"
                                           params:[self toDictionary]
                                       completion:^(id json, JSONModelError *err) {
                                           
                                           
                                       }];
    }

    -(void) startUploadAfn {
        if (self.raw_image_data)
        {
            self.image_data = @"";
            NSDictionary *parameters = [self toDictionary];
            
            AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://192.168.1.132:3000"]];
            
            NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"/app/api/v1/restaurant_admin/upload_image_file" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                [formData appendPartWithFileData: self.raw_image_data name:@"image" fileName:@"temp.png" mimeType:@"image/png"];
            }];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            __weak UploadImage *weakSelf = self;
            
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                weakSelf.progress = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
                NSLog(@"progress from within: %f",weakSelf.progress);
            }];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
                 NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                 NSLog(@"response: %@",jsons);
                 
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
