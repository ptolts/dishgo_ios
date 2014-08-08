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
                    NSManagedObjectContext *context = self.dish.managedObjectContext;
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Images" inManagedObjectContext:context];
                    Images *img = [[Images alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                    img.url = [jsons objectForKey:@"url"];
                    UserSession *session = [UserSession sharedManager];
                    [session completeLogin];
                    NSMutableArray *copy_array = [[NSMutableArray alloc] initWithArray:[self.dish.images array]];
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
             }];
            
            [operation start];
        }
    }
@end
