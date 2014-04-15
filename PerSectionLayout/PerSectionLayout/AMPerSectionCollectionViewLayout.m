//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import <PerSectionLayout/AMPerSectionCollectionViewLayout.h>
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "math.h"
#import "AMPerSectionCollectionViewLayoutInvalidationContext.h"
#import "AMPerSectionCollectionViewLayoutAttributes.h"

NSString * const AMPerSectionCollectionElementKindHeader = @"AMPerSectionCollectionElementKindHeader";
NSString * const AMPerSectionCollectionElementKindFooter = @"AMPerSectionCollectionElementKindFooter";
NSString * const AMPerSectionCollectionElementKindSectionHeader = @"AMPerSectionCollectionElementKindSectionHeader";
NSString * const AMPerSectionCollectionElementKindSectionFooter = @"AMPerSectionCollectionElementKindSectionFooter";
NSString * const AMPerSectionCollectionElementKindSectionBackground = @"AMPerSectionCollectionElementKindSectionBackground";

const NSInteger AMPerSectionCollectionElementAlwaysShowOnTopZIndex = 2048;

@interface AMPerSectionCollectionViewLayout ()
@property (nonatomic, strong) AMPerSectionCollectionViewLayoutInfo *layoutInfo;
@property (nonatomic, assign, getter = isTransitioning) BOOL transitioning;
@property (nonatomic, assign) CGPoint transitionTargetContentOffset;
@end

@implementation AMPerSectionCollectionViewLayout

- (id)init
{
    self = [super init];
    if (self)
    {
        [self commonInitAMPerSectionCollectionViewLayout];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInitAMPerSectionCollectionViewLayout];
    }
    
    return self;
}

- (void)commonInitAMPerSectionCollectionViewLayout
{
    self.itemSize = CGSizeMake(50.f, 50.f);
    self.minimumLineSpacing = 5.f;
    self.minimumInteritemSpacing = 5.f;
    self.sectionMinimumWidth = NAN;
}

#pragma mark - Utilities

- (CGPoint)adjustedCollectionViewContentOffset
{
    CGFloat contentOffsetY = self.collectionView.contentOffset.y;
    if ([self isTransitioning])
    {
        contentOffsetY = self.transitionTargetContentOffset.y;
        
        if ([self isExpanded])
        {
            contentOffsetY += 0.1; // make sure sticky / stretchy items stay at the top
        }
    }
    
    CGFloat adjustedYValue = contentOffsetY + self.collectionView.contentInset.top;
    return CGPointMake(0, adjustedYValue);
}

#pragma mark - Layout attributes

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGPoint offset = [self adjustedCollectionViewContentOffset];
    NSMutableArray *layoutAttributesArray = [NSMutableArray array];

    UICollectionViewLayoutAttributes *globalHeaderLayoutAttributes = [self.layoutInfo layoutAttributesForGlobalHeaderWithOffset:offset];
    if (globalHeaderLayoutAttributes != nil && CGRectIntersectsRect(globalHeaderLayoutAttributes.frame, rect))
    {
        [layoutAttributesArray addObject:globalHeaderLayoutAttributes];
    }

    UICollectionViewLayoutAttributes *globalFooterLayoutAttributes = [self.layoutInfo layoutAttributesForGlobalFooterWithOffset:offset];
    if (globalFooterLayoutAttributes != nil && CGRectIntersectsRect(globalFooterLayoutAttributes.frame, rect))
    {
        [layoutAttributesArray addObject:globalFooterLayoutAttributes];
    }

    for (AMPerSectionCollectionViewLayoutSection *section in self.layoutInfo.layoutInfoSections)
    {
        NSArray *sectionLayoutAttributes = [section layoutAttributesArrayForSectionInRect:rect withOffset:offset];
        [layoutAttributesArray addObjectsFromArray:sectionLayoutAttributes];
	}

	return layoutAttributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGPoint offset = [self adjustedCollectionViewContentOffset];
    return [self.layoutInfo layoutAttributesForItemAtIndexPath:indexPath withOffset:offset];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CGPoint offset = [self adjustedCollectionViewContentOffset];

	if ([kind isEqualToString:AMPerSectionCollectionElementKindHeader])
    {
        // Check the index path, supplementary views will be queried for each indexPath
        if (indexPath.row == 0 && indexPath.section == 0)
        {
            return [self.layoutInfo layoutAttributesForGlobalHeaderWithOffset:offset];
        }
	}
    else if ([kind isEqualToString:AMPerSectionCollectionElementKindFooter])
    {
        if (indexPath.row == 0 && indexPath.section == 0)
        {
            return [self.layoutInfo layoutAttributesForGlobalFooterWithOffset:offset];
        }
    }
    else
    {
		return [self.layoutInfo layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath withOffset:offset];
	}

    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

+ (Class)layoutAttributesClass
{
    return [AMPerSectionCollectionViewLayoutAttributes class];
}

#pragma mark - Transition

- (void)prepareForTransitionToLayout:(AMPerSectionCollectionViewLayout *)newLayout
{
    newLayout.transitioning = YES;
}

- (void)finalizeLayoutTransition
{
    self.transitioning = NO;
    self.transitionTargetContentOffset = CGPointZero;
}

#pragma mark - AMPerSectionCollectionViewLayoutDelegate

- (id<AMPerSectionCollectionViewLayoutDelegate>)collectionViewDelegate
{
    return (id<AMPerSectionCollectionViewLayoutDelegate>)self.collectionView.delegate;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = self.itemSize;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)])
    {
        itemSize = [self.collectionViewDelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    
    return itemSize;
}

- (CGSize)sizeForHeader
{
    CGSize headerReferenceSize = self.headerReferenceSize;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:sizeForHeaderInLayout:)])
    {
        headerReferenceSize = [self.collectionViewDelegate collectionView:self.collectionView sizeForHeaderInLayout:self];
    }
    
    return headerReferenceSize;
}

- (CGSize)sizeForFooter
{
    CGSize footerReferenceSize = self.footerReferenceSize;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:sizeForFooterInLayout:)])
    {
        footerReferenceSize = [self.collectionViewDelegate collectionView:self.collectionView sizeForFooterInLayout:self];
    }
    
    return footerReferenceSize;
}

- (BOOL)hasStickyHeaderOverSection:(NSInteger)section
{
    BOOL hasStickyHeaderOverSection = self.hasStickyHeader;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:hasStickyHeaderOverSection:)])
    {
        hasStickyHeaderOverSection = [self.collectionViewDelegate collectionView:self.collectionView layout:self hasStickyHeaderOverSection:section];
        
    }
    
    return hasStickyHeaderOverSection;
}

- (CGSize)sizeForHeaderInSection:(NSInteger)section
{
    CGSize sectionHeaderReferenceSize = self.sectionHeaderReferenceSize;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:sizeForHeaderInSection:)])
    {
        sectionHeaderReferenceSize = [self.collectionViewDelegate collectionView:self.collectionView layout:self sizeForHeaderInSection:section];
    }
    
    return  sectionHeaderReferenceSize;
}

- (CGSize)sizeForFooterInSection:(NSInteger)section
{
    CGSize sectionFooterReferenceSize = self.sectionFooterReferenceSize;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:sizeForFooterInSection:)])
    {
        sectionFooterReferenceSize = [self.collectionViewDelegate collectionView:self.collectionView layout:self sizeForFooterInSection:section];
    }
    
    return  sectionFooterReferenceSize;
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets sectionInset = self.sectionInset;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        sectionInset = [self.collectionViewDelegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    
    return sectionInset;
}

- (CGFloat)miniumWidthForSectionAtIndex:(NSInteger)section
{
    CGFloat minimuWidth = self.sectionMinimumWidth;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:minimumWidthForSectionAtIndex:)])
    {
        minimuWidth = [self.collectionViewDelegate collectionView:self.collectionView layout:self minimumWidthForSectionAtIndex:section];
    }
    
    return minimuWidth;
}

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat minimumLineSpacing = self.minimumLineSpacing;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)])
    {
        minimumLineSpacing = [self.collectionViewDelegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    
    return minimumLineSpacing;
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
    {
        minimumInteritemSpacing = [self.collectionViewDelegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    return minimumInteritemSpacing;
}

- (BOOL)canStretchSectionAtIndex:(NSInteger)section
{
    BOOL canStretchSectionAtIndex = NO;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:canStretchSectionAtIndex:)])
    {
        canStretchSectionAtIndex = [self.collectionViewDelegate collectionView:self.collectionView layout:self canStretchSectionAtIndex:section];
    }
    
    return canStretchSectionAtIndex;
}

#pragma mark - Layout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    CGPoint targetOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
    
    if ([self isTransitioning])
    {
        targetOffset.y = -self.collectionView.contentInset.top;
        self.transitionTargetContentOffset = targetOffset;
    }
    
    return targetOffset;
}

+ (Class)invalidationContextClass
{
    return [AMPerSectionCollectionViewLayoutInvalidationContext class];
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds
{
    AMPerSectionCollectionViewLayoutInvalidationContext *invalidationContext = (AMPerSectionCollectionViewLayoutInvalidationContext *)[super invalidationContextForBoundsChange:newBounds];
    invalidationContext.invalidateHeader = YES;
    
    return invalidationContext;
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context
{
    AMPerSectionCollectionViewLayoutInvalidationContext *invalidationContext = (AMPerSectionCollectionViewLayoutInvalidationContext *)context;
    if (!invalidationContext.invalidateHeader)
    {
        self.layoutInfo = nil;
    }
    
    [super invalidateLayoutWithContext:context];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)prepareLayout
{
    if (!self.layoutInfo)
    {
        self.layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
        self.layoutInfo.collectionViewSize = self.collectionView.bounds.size;
        [self getSizingInfos:self.layoutInfo];
        [self.layoutInfo updateItemsLayout];
    }
}

- (void)getSizingInfos:(AMPerSectionCollectionViewLayoutInfo *)layoutInfo
{
    layoutInfo.headerFrame = (CGRect){.size = [self sizeForHeader]};
	layoutInfo.footerFrame = (CGRect){.size = [self sizeForFooter]};
    
    NSInteger numberOfSections =(NSInteger) [self.collectionView numberOfSections];
	for (NSInteger section = 0; section < numberOfSections; section++)
    {
		if ([self hasStickyHeaderOverSection:section])
        {
            layoutInfo.stickyHeader = YES;
            layoutInfo.lastSectionWithStickyHeader = section;
        }
        
        AMPerSectionCollectionViewLayoutSection *layoutSection = [layoutInfo addSection];
		
		layoutSection.headerFrame = (CGRect){.size = [self sizeForHeaderInSection:section]};
        layoutSection.footerFrame = (CGRect){.size = [self sizeForFooterInSection:section]};
        layoutSection.sectionMargins = [self insetForSectionAtIndex:section];
        layoutSection.verticalInterstice = [self minimumLineSpacingForSectionAtIndex:section];
        layoutSection.horizontalInterstice = [self minimumInteritemSpacingForSectionAtIndex:section];
        layoutSection.width = [self miniumWidthForSectionAtIndex:section];
        layoutSection.stretch = [self canStretchSectionAtIndex:section];
        
		NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        CGSize itemSize = [self itemSize];
        BOOL implementsSizeDelegate = [self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)];
		for (NSInteger item = 0; item < numberOfItems; item++)
        {
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
			AMPerSectionCollectionViewLayoutItem *layoutItem = [layoutSection addItem];
			layoutItem.frame = (CGRect){.size = (implementsSizeDelegate) ? [self sizeForItemAtIndexPath:indexPath] : itemSize};
		}
	}
}

#pragma mark - Content Size

- (CGSize)collectionViewContentSize
{
	return self.layoutInfo.contentSize;
}

@end
