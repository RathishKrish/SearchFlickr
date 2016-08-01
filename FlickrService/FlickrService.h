//
//  FlickrService.h
//  SearchFlickr
//
//  Created by Rathish Krish T on 15/07/16.
//  Copyright © 2016 Rathish Marthandan T. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlickrImage.h"

typedef void (^flickrSearchBlockCompletion) (NSString *searchKeyWord, NSArray *results, NSError *error);
typedef void (^flickrImageDetailsBlockCompletion) (NSDictionary *results, NSError *error);

@interface FlickrService : NSObject

- (void) searchFlickrForKeyWord:(NSString *)keyWord blockComplition:(flickrSearchBlockCompletion)blockCompletion;

- (void) searchFlickrImage:(FlickrImage *)imageContents blockComplition:(flickrImageDetailsBlockCompletion)blockCompletion;

- (void)cancelTasks;

@end
