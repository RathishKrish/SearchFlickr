//
//  FlickrFlowLayout.h
//  SearchFlickr
//
//  Created by Rathish Krish T on 16/07/16.
//  Copyright © 2016 Rathish Marthandan T. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol flickrLayoutDelegate <UICollectionViewDelegate>
@required
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForHeaderInSection:(NSInteger)section;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForFooterInSection:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section;

@end

@interface FlickrFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger columnCount;

@property (nonatomic, assign) CGFloat minimumColumnSpacing;

@property (nonatomic, assign) CGFloat _minimumInteritemSpacing;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, assign) UIEdgeInsets headerInset;

@property (nonatomic, assign) UIEdgeInsets footerInset;

@property (nonatomic, assign) UIEdgeInsets _sectionInset;

@property (nonatomic, assign) CGFloat minimumContentHeight;


- (CGFloat)itemWidthInSectionAtIndex:(NSInteger)section;


@end
