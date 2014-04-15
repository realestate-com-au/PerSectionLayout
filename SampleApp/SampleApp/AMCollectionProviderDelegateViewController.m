//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMCollectionProviderDelegateViewController.h"
#import <PerSectionLayout/AMPerSectionCollectionViewLayout.h>

@implementation AMCollectionProviderDelegateViewController

#pragma mark -  AMPerSectionCollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForHeaderInLayout:(AMPerSectionCollectionViewLayout *)collectionViewLayout
{    
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:indexPath.section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    
    return collectionViewLayout.itemSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    
    return collectionViewLayout.sectionHeaderReferenceSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    
    return collectionViewLayout.sectionFooterReferenceSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    
    return collectionViewLayout.sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }
    
    return collectionViewLayout.minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    return collectionViewLayout.minimumInteritemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout minimumWidthForSectionAtIndex:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:minimumWidthForSectionAtIndex:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout minimumWidthForSectionAtIndex:section];
    }
    
    return collectionViewLayout.sectionMinimumWidth;
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout hasStickyHeaderOverSection:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:hasStickyHeaderOverSection:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout hasStickyHeaderOverSection:section];
    }
    
    return collectionViewLayout.hasStickyHeader;
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout canStretchSectionAtIndex:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:canStretchSectionAtIndex:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout canStretchSectionAtIndex:section];
    }
    
    return NO;
}

#pragma mark - Rotation Support

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.collectionViewLayout invalidateLayout];
}

@end
