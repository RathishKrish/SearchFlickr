//
//  FlickrCell.m
//  SearchFlickr
//
//  Created by Rathish Krish T on 15/07/16.
//  Copyright © 2016 Rathish Marthandan T. All rights reserved.
//

#import "FlickrCell.h"

@implementation FlickrCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds)-60)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIView *)bannerView{
    if (!_bannerView){
        _bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.bounds)-60, CGRectGetWidth(self.contentView.bounds), 60)];
        _bannerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _bannerView.contentMode = UIViewContentModeScaleAspectFit;
        [_bannerView setBackgroundColor:[UIColor whiteColor]];
    }
    return _bannerView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, CGRectGetWidth(self.contentView.bounds)-16, 38)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:12]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setNumberOfLines:2];
    }
    return _titleLabel;
}

- (UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetHeight(_titleLabel.frame), CGRectGetWidth(self.contentView.bounds)-16, 22)];
        [_tagLabel setBackgroundColor:[UIColor clearColor]];
        [_tagLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:11]];
        [_tagLabel setTextColor:[UIColor colorWithRed:35.f/255.f green:186.f/255.f blue:167.f/255.f alpha:1.0]];
        [_tagLabel setNumberOfLines:1];
    }
    return _tagLabel;
}

- (UIButton *)favoriteBtn{
    if (!_favoriteBtn) {
        _favoriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds) - 25, 10, 16, 16)];
        [_favoriteBtn addTarget:self.delegate action:@selector(favoriteFlick:) forControlEvents:UIControlEventTouchUpInside];
        [_favoriteBtn setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        [_favoriteBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateSelected];
        [_favoriteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_favoriteBtn setBackgroundColor:[UIColor clearColor]];
        
    }
    return _favoriteBtn;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.imageView];
        [self addSubview:self.favoriteBtn];
        [self addSubview:self.bannerView];
        [self.bannerView addSubview:self.titleLabel];
        [self.bannerView addSubview:self.tagLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.favoriteBtn setFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds) - 25, 10, 16, 16)];
    [self.bannerView setFrame:CGRectMake(0, CGRectGetHeight(self.contentView.bounds)-60, CGRectGetWidth(self.contentView.bounds), 60)];
    
    self.layer.masksToBounds = NO;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 7.0f;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.shadowOpacity = 0.75f;
    self.layer.shadowRadius = 5.0f;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shouldRasterize = YES;
    
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect){.size = size});
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
