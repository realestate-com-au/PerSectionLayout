//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import UIKit;
@class AMPerSectionCollectionViewLayout;

extern NSString * const AMPerSectionCollectionElementKindHeader;
extern NSString * const AMPerSectionCollectionElementKindFooter;
extern NSString * const AMPerSectionCollectionElementKindSectionHeader;
extern NSString * const AMPerSectionCollectionElementKindSectionFooter;

@protocol AMPerSectionCollectionViewLayoutDelegate <UICollectionViewDelegate>
@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForHeaderInLayout:(AMPerSectionCollectionViewLayout *)collectionViewLayout;
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForFooterInLayout:(AMPerSectionCollectionViewLayout *)collectionViewLayout;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForHeaderInSection:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
@end

@interface AMPerSectionCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) CGSize itemSize; // default: (50, 50)
@property (nonatomic) CGSize headerReferenceSize; // default: CGSizeZero
@property (nonatomic) CGSize footerReferenceSize; // default: CGSizeZero
@property (nonatomic) CGSize sectionHeaderReferenceSize; // default: CGSizeZero
@property (nonatomic) CGSize sectionFooterReferenceSize; // default: CGSizeZero
@property (nonatomic) UIEdgeInsets sectionInset; // default: UIEdgeInsetsZero
@property (nonatomic) CGFloat minimumLineSpacing; // default: 5

@end
