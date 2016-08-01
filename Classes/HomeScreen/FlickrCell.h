//
//  FlickrCell.h
//  SearchFlickr
//
//  Created by Rathish Krish T on 15/07/16.
//  Copyright © 2016 Rathish Marthandan T. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlickrImage.h"

@protocol favoriteDelegate <NSObject>

@optional
- (void) favoriteFlick:(UIButton *)sender;

@end

@interface FlickrCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *bannerView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) UIButton *favoriteBtn;

@property (nonatomic, strong) id <favoriteDelegate> delegate;

@end
