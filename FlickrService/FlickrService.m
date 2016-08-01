//
//  FlickrService.m
//  SearchFlickr
//
//  Created by Rathish Krish T on 15/07/16.
//  Copyright © 2016 Rathish Marthandan T. All rights reserved.
//

#import "FlickrService.h"
#import "FlickrImage.h"

#define FlikrAPIkey         @"f32eae56a930aa65fa52cd33e4a6392a"

@interface FlickrService ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation FlickrService

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
        [conf setHTTPMaximumConnectionsPerHost:4];
        self.session = [NSURLSession sessionWithConfiguration:conf delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

- (void) searchFlickrForKeyWord:(NSString *)keyWord blockComplition:(flickrSearchBlockCompletion)blockCompletion{
    
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(q, ^{
        
        NSURL * url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/"];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString * params =[NSString stringWithFormat:@"method=flickr.photos.search&api_key=%@&text=%@&format=json&nojsoncallback=1",FlikrAPIkey,[keyWord stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask * dataTask =[self.session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error == nil)
            {
                NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                if (error == nil) {
                    NSString * checkStatus = searchResultsDict[@"stat"];
                    if ([checkStatus isEqualToString:@"fail"]) {
                        NSError * error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: searchResultsDict[@"message"]}];
                        blockCompletion(keyWord, nil, error);
                    }
                    else{
                        
                        NSArray *objPhotos = searchResultsDict[@"photos"][@"photo"];
                        NSMutableArray *flickrPhotos = [NSMutableArray array];
                        
                        for(NSMutableDictionary *objPhoto in objPhotos)
                        {
                            FlickrImage *photo = [[FlickrImage alloc] init];
                            photo.farm = [objPhoto[@"farm"] intValue];
                            photo.server = [objPhoto[@"server"] intValue];
                            photo.secret = objPhoto[@"secret"];
                            photo.photoID = objPhoto[@"id"];
                            photo.title = objPhoto[@"title"];
                            photo.tag = keyWord;
                            
                            photo.imageURL = [NSString stringWithFormat:@"https://farm%ld.staticflickr.com/%ld/%@_%@_%@.jpg",(long)photo.farm,(long)photo.server,photo.photoID,photo.secret,@"m"];
                            
                            [flickrPhotos addObject:photo];
                            
                        }
                        blockCompletion(keyWord,flickrPhotos,nil);
                    }
                }
                else{
                    blockCompletion(keyWord,nil,error);
                }
            }
            else{
                blockCompletion(keyWord,nil,error);
            }
        }];
        [dataTask resume];
    });
}

- (void) searchFlickrImage:(FlickrImage *)imageContents blockComplition:(flickrImageDetailsBlockCompletion)blockCompletion{
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(q, ^{
        NSURL * url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/"];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString * params =[NSString stringWithFormat:@"method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1",FlikrAPIkey,imageContents.photoID];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask * dataTask =[self.session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error == nil)
            {
                NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"searchResultsDict = %@",searchResultsDict);
                if (error == nil) {
                    NSString * checkStatus = searchResultsDict[@"stat"];
                    if ([checkStatus isEqualToString:@"fail"]) {
                        NSError * error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: searchResultsDict[@"message"]}];
                        blockCompletion(nil, error);
                    }
                    else{
                        
                        NSDictionary *objPhotos = searchResultsDict[@"photo"];
                        blockCompletion(objPhotos, error);
                    }
                }
            }
        }];
        [dataTask resume];
        
    });
}

- (void)cancelTasks {
    
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        for (NSURLSessionTask *task in dataTasks) {
            [task cancel];
        }
    }];
}


@end
