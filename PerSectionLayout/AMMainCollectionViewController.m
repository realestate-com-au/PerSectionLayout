//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMMainCollectionViewController.h"
#import "AMSectionsProvider.h"
#import "AMPerSectionCollectionViewLayout.h"
#import "AMMapSectionController.h"
#import "AMListSectionController.h"
#import "AMOFISectionController.h"
#import "AMGraphSectionController.h"
#import "AMADSectionController.h"
#import "AMOtherSectionController.h"
#import "UIDevice+Utilities.h"

@interface AMMainCollectionViewController ()
@property (nonatomic, strong) AMSectionsProvider *sectionsProvider;
@end

@implementation AMMainCollectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.sectionsProvider = [[AMSectionsProvider alloc] init];
        [self.sectionsProvider addSectionControllerForClass:[AMMapSectionController class]];
        [self.sectionsProvider addSectionControllerForClass:[AMListSectionController class]];
        [self.sectionsProvider addSectionControllerForClass:[AMOFISectionController class]];
        [self.sectionsProvider addSectionControllerForClass:[AMGraphSectionController class]];
        [self.sectionsProvider addSectionControllerForClass:[AMADSectionController class]];
        [self.sectionsProvider addSectionControllerForClass:[AMOtherSectionController class]];
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AMPerSectionCollectionViewLayout *layout = (AMPerSectionCollectionViewLayout *)self.collectionViewLayout;
    layout.stickyHeader = [[UIDevice currentDevice] isiPad];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:AMPerSectionCollectionElementKindHeader withReuseIdentifier:@"header"];
    [self.sectionsProvider registerCustomElementsForCollectionView:self.collectionView];
}

#pragma mark - Utilities

- (BOOL)canHandleSupplementaryElementOfKind:(NSString *)kind
{
    return ([kind isEqualToString:AMPerSectionCollectionElementKindHeader] ||
            [kind isEqualToString:AMPerSectionCollectionElementKindFooter]);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (NSInteger)self.sectionsProvider.sectionControllersCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    return [sectionController collectionView:collectionView numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:indexPath.section];
    return [sectionController collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([self canHandleSupplementaryElementOfKind:kind])
    {
        if ([kind isEqualToString:AMPerSectionCollectionElementKindHeader])
        {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:AMPerSectionCollectionElementKindHeader withReuseIdentifier:@"header"  forIndexPath:indexPath];
            view.backgroundColor = [UIColor redColor];
            
            return view;
        }
    }
    else
    {
        id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:indexPath.section];
        if ([sectionController respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)])
        {
            return [sectionController collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        }
    }
    
    return nil;
}

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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForHeaderInSection:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:sizeForHeaderInSection:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout sizeForHeaderInSection:section];
    }
    
    return collectionViewLayout.sectionHeaderReferenceSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForFooterInSection:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:sizeForHeaderInSection:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout sizeForHeaderInSection:section];
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

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout hasSectionDecorationBackgroundAtIndex:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:hasSectionDecorationBackgroundAtIndex:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout hasSectionDecorationBackgroundAtIndex:section];
    }
    
    return collectionViewLayout.hasSectionDecorationBackground;
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout isSectionStickyAtIndex:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    if ([sectionController respondsToSelector:@selector(collectionView:layout:isSectionStickyAtIndex:)])
    {
        return [sectionController collectionView:collectionView layout:collectionViewLayout isSectionStickyAtIndex:section];
    }
    
    return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.collectionViewLayout invalidateLayout];
}

@end
