//
//  FlickrImage.h
//  SearchFlickr
//
//  Created by Rathish Krish T on 15/07/16.
//  Copyright © 2016 Rathish Marthandan T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FlickrImage : NSObject

// Lookup info
@property(nonatomic) NSString *photoID;
@property(nonatomic) NSInteger farm;
@property(nonatomic) NSInteger server;
@property(nonatomic,strong) NSString *secret;
@property(nonatomic,strong) NSString *imageURL;
@property(nonatomic,strong) UIImage *flickImage;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *tag;

@end
