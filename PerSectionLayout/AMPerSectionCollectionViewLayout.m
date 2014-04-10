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

static const NSInteger AMPerSectionCollectionElementAlwaysShowOnTopIndex = 2048;

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
    self.sectionMinimumWidth = NAN;
}

#pragma mark - Utilities

- (BOOL)layoutInfoFrame:(CGRect)layoutInfoFrame requiresLayoutAttritbutesForRect:(CGRect)rect
{
    return ((CGRectGetHeight(layoutInfoFrame) > 0) && CGRectIntersectsRect(layoutInfoFrame, rect));
}

#pragma mark - Utilities

- (CGFloat)adjustedCollectionViewContentOffset
{
    return self.collectionView.contentOffset.y + self.collectionView.contentInset.top;
}

#pragma mark - Layout attributes

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributesArray = [NSMutableArray array];
    
	// header
	CGRect normalizedHeaderFrame = [self.layoutInfo stickyHeaderFrameForYOffset:[self adjustedCollectionViewContentOffset]];
	if ([self layoutInfoFrame:normalizedHeaderFrame requiresLayoutAttritbutesForRect:rect])
    {
		UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
		layoutAttributes.frame = normalizedHeaderFrame;
        layoutAttributes.zIndex = AMPerSectionCollectionElementAlwaysShowOnTopIndex;
		[layoutAttributesArray addObject:layoutAttributes];
	}
	
	for (AMPerSectionCollectionViewLayoutSection *section in self.layoutInfo.layoutInfoSections)
    {
        CGRect normalizedSectionFrame = [section stickyFrameForYOffset:[self adjustedCollectionViewContentOffset]];
		if (CGRectIntersectsRect(normalizedSectionFrame, rect))
        {
             NSInteger sectionIndex = (NSInteger)[self.layoutInfo.layoutInfoSections indexOfObject:section];
            
			// section header
			CGRect normalizedSectionHeaderFrame = section.headerFrame;
            normalizedSectionHeaderFrame.origin.x += CGRectGetMinX(normalizedSectionFrame);
            normalizedSectionHeaderFrame.origin.y += CGRectGetMinY(normalizedSectionFrame);
            if ([self layoutInfoFrame:normalizedSectionHeaderFrame requiresLayoutAttritbutesForRect:rect])
            {
                UICollectionViewLayoutAttributes *layoutAttributes;
                layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
                layoutAttributes.frame = normalizedSectionHeaderFrame;
                [layoutAttributesArray addObject:layoutAttributes];
            }
			
			// section body
			for (AMPerSectionCollectionViewLayoutRow *row in section.layoutSectionRows)
            {
				//	figure out row's frame in global layout measurements
				CGRect normalizedRowFrame = row.frame;
				normalizedRowFrame.origin.x += normalizedSectionFrame.origin.x;
				normalizedRowFrame.origin.y += normalizedSectionFrame.origin.y;
				
				if (CGRectIntersectsRect(normalizedRowFrame, rect))
                {
					for (NSInteger itemIndex = 0; itemIndex < row.itemsCount; itemIndex++)
                    {
						AMPerSectionCollectionViewLayoutItem *item = row.layoutSectionItems[(NSUInteger)itemIndex];
						NSInteger sectionItemIndex = (NSInteger)[section.layoutSectionItems indexOfObject:item];
						CGRect itemFrame = item.frame;
                        
						UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:sectionItemIndex inSection:sectionIndex]];
						layoutAttributes.frame = CGRectMake(CGRectGetMinX(normalizedRowFrame) + CGRectGetMinX(itemFrame),
															CGRectGetMinY(normalizedRowFrame) + CGRectGetMinY(itemFrame),
															CGRectGetWidth(itemFrame),
															CGRectGetHeight(itemFrame));
						[layoutAttributesArray addObject:layoutAttributes];
					}
				}
			}
            
            // section footer
			CGRect normalizedSectionFooterFrame = section.footerFrame;
            normalizedSectionFooterFrame.origin.x += CGRectGetMinX(normalizedSectionFrame);
            normalizedSectionFooterFrame.origin.y += CGRectGetMinY(normalizedSectionFrame);
            if ([self layoutInfoFrame:normalizedSectionFooterFrame requiresLayoutAttritbutesForRect:rect])
            {
                UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
                layoutAttributes.frame = normalizedSectionFooterFrame;
                [layoutAttributesArray addObject:layoutAttributes];
            }
		}
	}
	
	// footer
	CGRect normalizedFooterFrame = self.layoutInfo.footerFrame;
	if ([self layoutInfoFrame:normalizedFooterFrame requiresLayoutAttritbutesForRect:rect])
    {
		UICollectionViewLayoutAttributes *layoutAttributes;
		layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
		layoutAttributes.frame = normalizedFooterFrame;
		[layoutAttributesArray addObject:layoutAttributes];
	}
    
	return layoutAttributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMPerSectionCollectionViewLayoutItem *item = [self.layoutInfo itemAtIndexPath:indexPath];
    CGRect itemFrame = item.frame;
    
    AMPerSectionCollectionViewLayoutSection *section = [self.layoutInfo sectionAtIndex:indexPath.section];
	AMPerSectionCollectionViewLayoutRow *row = item.row;
	
	UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
	
	// calculate item rect
	CGRect normalizedRowFrame = row.frame;
	normalizedRowFrame.origin.x += CGRectGetMinX(section.frame);
	normalizedRowFrame.origin.y += CGRectGetMinY(section.frame);
	layoutAttributes.frame = CGRectMake(CGRectGetMinX(normalizedRowFrame) + CGRectGetMinX(itemFrame), CGRectGetMinY(normalizedRowFrame) + CGRectGetMinY(itemFrame), CGRectGetWidth(itemFrame), CGRectGetHeight(itemFrame));
	
	return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
	
	if ([kind isEqualToString:AMPerSectionCollectionElementKindHeader])
    {
		layoutAttributes.frame = self.layoutInfo.headerFrame;
        layoutAttributes.zIndex = AMPerSectionCollectionElementAlwaysShowOnTopIndex;
	}
    else if ([kind isEqualToString:AMPerSectionCollectionElementKindFooter])
    {
		layoutAttributes.frame = self.layoutInfo.footerFrame;
        
	}
    else
    {
		AMPerSectionCollectionViewLayoutSection *section = [self.layoutInfo sectionAtIndex:indexPath.section];
		if ([kind isEqualToString:AMPerSectionCollectionElementKindSectionHeader])
        {
			layoutAttributes.frame = section.headerFrame;
            
		}
        else if ([kind isEqualToString:AMPerSectionCollectionElementKindSectionFooter])
        {
			layoutAttributes.frame = section.footerFrame;
		}
	}
    
	return layoutAttributes;
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
        [self fetchItemsInfo:self.layoutInfo];
    }
}

- (void)fetchItemsInfo:(AMPerSectionCollectionViewLayoutInfo *)layoutInfo
{
	[self getSizingInfos:layoutInfo];
	[self updateItemsLayout:layoutInfo];
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

- (void)updateItemsLayout:(AMPerSectionCollectionViewLayoutInfo *)layoutInfo
{
    [layoutInfo updateItemsLayout];
}

#pragma mark - Content Size

- (CGSize)collectionViewContentSize
{
	return self.layoutInfo.contentSize;
}

@end
