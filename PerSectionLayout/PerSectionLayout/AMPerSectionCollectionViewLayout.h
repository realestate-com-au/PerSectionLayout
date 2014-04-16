//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMPerSectionCollectionViewLayout;

extern NSString * const AMPerSectionCollectionElementKindHeader;
extern NSString * const AMPerSectionCollectionElementKindFooter;
extern NSString * const AMPerSectionCollectionElementKindSectionHeader;
extern NSString * const AMPerSectionCollectionElementKindSectionFooter;
extern NSString * const AMPerSectionCollectionElementKindSectionBackground;

extern const NSInteger AMPerSectionCollectionElementAlwaysShowOnTopZIndex;

@protocol AMPerSectionCollectionViewLayoutDelegate <UICollectionViewDelegate>
@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForHeaderInLayout:(AMPerSectionCollectionViewLayout *)collectionViewLayout;
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForFooterInLayout:(AMPerSectionCollectionViewLayout *)collectionViewLayout;
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout hasStickyHeaderOverSection:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout minimumWidthForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout canStretchSectionAtIndex:(NSInteger)section;
@end

@interface AMPerSectionCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize itemSize; // default: (50, 50)
@property (nonatomic, assign) CGSize headerReferenceSize; // default: CGSizeZero
@property (nonatomic, assign) CGSize footerReferenceSize; // default: CGSizeZero
@property (nonatomic, assign, getter = hasStickyHeader) BOOL stickyHeader; // default: NO
@property (nonatomic, assign) CGSize sectionHeaderReferenceSize; // default: CGSizeZero
@property (nonatomic, assign) CGSize sectionFooterReferenceSize; // default: CGSizeZero
@property (nonatomic, assign) UIEdgeInsets sectionInset; // default: UIEdgeInsetsZero
@property (nonatomic, assign) CGFloat sectionMinimumWidth; // default: NAN (use the collection view width)
@property (nonatomic, assign) CGFloat minimumLineSpacing; // default: 5
@property (nonatomic, assign) CGFloat minimumInteritemSpacing; // default: 5

@property (nonatomic, assign, getter = isExpanded) BOOL expanded; // default: NO

@end
