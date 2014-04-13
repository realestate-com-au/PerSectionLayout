//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayout.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "math.h"
#import "AMPerSectionCollectionViewLayoutInvalidationContext.h"

NSString * const AMPerSectionCollectionElementKindHeader = @"AMPerSectionCollectionElementKindHeader";
NSString * const AMPerSectionCollectionElementKindFooter = @"AMPerSectionCollectionElementKindFooter";
NSString * const AMPerSectionCollectionElementKindSectionHeader = @"AMPerSectionCollectionElementKindSectionHeader";
NSString * const AMPerSectionCollectionElementKindSectionFooter = @"AMPerSectionCollectionElementKindSectionFooter";
NSString * const AMPerSectionCollectionElementKindSectionBackground = @"AMPerSectionCollectionElementKindSectionBackground";

const NSInteger AMPerSectionCollectionElementAlwaysShowOnTopZIndex = 2048;
const NSInteger AMPerSectionCollectionElementStickySectionZIndex = -2048;

@interface AMPerSectionCollectionViewLayout ()
@property (nonatomic, strong) AMPerSectionCollectionViewLayoutInfo *layoutInfo;
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
    self.sectionMinimumWidth = 0.f;
}

#pragma mark - Utilities

- (CGPoint)adjustedCollectionViewContentOffset
{
    CGFloat adjustedYValue = self.collectionView.contentOffset.y + self.collectionView.contentInset.top;
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

//Cells
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMPerSectionCollectionViewLayoutItem *item = [self.layoutInfo itemAtIndexPath:indexPath];
    CGRect itemFrame = item.frame;
    
    AMPerSectionCollectionViewLayoutSection *section = [self.layoutInfo sectionAtIndex:indexPath.section];
	AMPerSectionCollectionViewLayoutRow *row = item.row;
	
	UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
	
    CGRect sectionFrame = [section stickyFrameForYOffset:[self adjustedCollectionViewContentOffset].y];
    
	// calculate item rect
	CGRect normalizedRowFrame = row.frame;
	normalizedRowFrame.origin.x += CGRectGetMinX(sectionFrame);
	normalizedRowFrame.origin.y += CGRectGetMinY(sectionFrame);
	layoutAttributes.frame = CGRectMake(CGRectGetMinX(normalizedRowFrame) + CGRectGetMinX(itemFrame), CGRectGetMinY(normalizedRowFrame) + CGRectGetMinY(itemFrame), CGRectGetWidth(itemFrame), CGRectGetHeight(itemFrame));
    
    if (section.isSticky)
    {
        layoutAttributes.zIndex = AMPerSectionCollectionElementStickySectionZIndex;
    }
	
	return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CGPoint offset = [self adjustedCollectionViewContentOffset];

	if ([kind isEqualToString:AMPerSectionCollectionElementKindHeader])
    {
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
        UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
		AMPerSectionCollectionViewLayoutSection *section = [self.layoutInfo sectionAtIndex:indexPath.section];
        CGRect normalizedSectionFrame = [section stickyFrameForYOffset:offset.y];
        
		if ([kind isEqualToString:AMPerSectionCollectionElementKindSectionHeader])
        {
            CGRect normalizedSectionHeaderFrame = section.headerFrame;
            normalizedSectionHeaderFrame.origin.x += CGRectGetMinX(normalizedSectionFrame);
            normalizedSectionHeaderFrame.origin.y += CGRectGetMinY(normalizedSectionFrame);
			layoutAttributes.frame = normalizedSectionHeaderFrame;
            
		}
        else if ([kind isEqualToString:AMPerSectionCollectionElementKindSectionFooter])
        {
            CGRect normalizedSectionHeaderFrame = section.footerFrame;
            normalizedSectionHeaderFrame.origin.x += CGRectGetMinX(normalizedSectionFrame);
            normalizedSectionHeaderFrame.origin.y += CGRectGetMinY(normalizedSectionFrame);
			layoutAttributes.frame = normalizedSectionHeaderFrame;
		}

        return layoutAttributes;
	}

    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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

- (BOOL)isSectionStickyAtIndex:(NSInteger)section
{
    BOOL isSectionStickyAtIndex = NO;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:isSectionStickyAtIndex:)])
    {
        isSectionStickyAtIndex = [self.collectionViewDelegate collectionView:self.collectionView layout:self isSectionStickyAtIndex:section];
    }
    
    return isSectionStickyAtIndex;
}

#pragma mark - Layout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    return CGPointMake(0.f, -64.f);
    
    CGPoint targetOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
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
        layoutSection.sticky = [self isSectionStickyAtIndex:section];
        
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
