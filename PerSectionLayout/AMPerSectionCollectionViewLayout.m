//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayout.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "math.h"

NSString * const AMPerSectionCollectionElementKindHeader = @"AMPerSectionCollectionElementKindHeader";
NSString * const AMPerSectionCollectionElementKindFooter = @"AMPerSectionCollectionElementKindFooter";
NSString * const AMPerSectionCollectionElementKindSectionHeader = @"AMPerSectionCollectionElementKindSectionHeader";
NSString * const AMPerSectionCollectionElementKindSectionFooter = @"AMPerSectionCollectionElementKindSectionFooter";

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

- (AMPerSectionCollectionViewLayoutSection *)sectionAtIndex:(NSInteger)section
{
    if (section >= (NSInteger)self.layoutInfo.layoutInfoSections.count)
    {
		return nil;
	}
    
    return self.layoutInfo.layoutInfoSections[(NSUInteger)section];
}

- (AMPerSectionCollectionViewLayoutItem *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    AMPerSectionCollectionViewLayoutSection *section = [self sectionAtIndex:indexPath.section];
    if (indexPath.item >= (NSInteger)section.layoutSectionItems.count)
    {
		return nil;
	}
    
    return section.layoutSectionItems[(NSUInteger)indexPath.item];
}

- (BOOL)layoutInfoFrame:(CGRect)layoutInfoFrame requiresLayoutAttritbutesForRect:(CGRect)rect
{
    return ((CGRectGetHeight(layoutInfoFrame) > 0) && CGRectIntersectsRect(layoutInfoFrame, rect));
}

#pragma mark - Layout attributes

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributesArray = [NSMutableArray array];
    
	// header
	CGRect normalizedHeaderFrame = self.layoutInfo.headerFrame;
	if ([self layoutInfoFrame:normalizedHeaderFrame requiresLayoutAttritbutesForRect:rect])
    {
		UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
		layoutAttributes.frame = normalizedHeaderFrame;
		[layoutAttributesArray addObject:layoutAttributes];
	}
	
	for (AMPerSectionCollectionViewLayoutSection *section in self.layoutInfo.layoutInfoSections)
    {
		if (CGRectIntersectsRect(section.frame, rect))
        {
			NSInteger sectionIndex = (NSInteger)[self.layoutInfo.layoutInfoSections indexOfObject:section];
			
			// section header
			CGRect normalizedSectionHeaderFrame = section.headerFrame;
            normalizedSectionHeaderFrame.origin.x += CGRectGetMinX(section.frame);
            normalizedSectionHeaderFrame.origin.y += CGRectGetMinY(section.frame);
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
				normalizedRowFrame.origin.x += section.frame.origin.x;
				normalizedRowFrame.origin.y += section.frame.origin.y;
				
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
            normalizedSectionFooterFrame.origin.x += CGRectGetMinX(section.frame);
            normalizedSectionFooterFrame.origin.y += CGRectGetMinY(section.frame);
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
    AMPerSectionCollectionViewLayoutItem *item = [self itemAtIndexPath:indexPath];
    CGRect itemFrame = item.frame;
    
    AMPerSectionCollectionViewLayoutSection *section = [self sectionAtIndex:indexPath.section];
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
	}
    else if ([kind isEqualToString:AMPerSectionCollectionElementKindFooter])
    {
		layoutAttributes.frame = self.layoutInfo.footerFrame;
        
	}
    else
    {
		AMPerSectionCollectionViewLayoutSection *section = [self sectionAtIndex:indexPath.section];
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

#pragma mark - Layout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

- (void)invalidateLayout
{
	[super invalidateLayout];
    
    [self.layoutInfo invalidate];
}

- (void)prepareLayout
{
	self.layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
    self.layoutInfo.collectionViewSize = self.collectionView.bounds.size;
    [self fetchItemsInfo];
}

- (void)fetchItemsInfo
{
	[self getSizingInfos];
	[self updateItemsLayout];
}

- (void)getSizingInfos
{
    self.layoutInfo.headerFrame = (CGRect){.size = [self sizeForHeader]};
	self.layoutInfo.footerFrame = (CGRect){.size = [self sizeForFooter]};
    
    NSInteger numberOfSections =(NSInteger) [self.collectionView numberOfSections];
	for (NSInteger section = 0; section < numberOfSections; section++)
    {
		AMPerSectionCollectionViewLayoutSection *layoutSection = [self.layoutInfo addSection];
		
		layoutSection.headerFrame = (CGRect){.size = [self sizeForHeaderInSection:section]};
        layoutSection.footerFrame = (CGRect){.size = [self sizeForFooterInSection:section]};
        layoutSection.sectionMargins = [self insetForSectionAtIndex:section];
        layoutSection.verticalInterstice = [self minimumLineSpacingForSectionAtIndex:section];
        layoutSection.horizontalInterstice = [self minimumInteritemSpacingForSectionAtIndex:section];
        layoutSection.width = [self miniumWidthForSectionAtIndex:section];
        
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

- (void)updateItemsLayout
{
    CGSize contentSize = CGSizeZero;
    
    //	global header
    CGRect globalHeaderFrame =  self.layoutInfo.headerFrame;
    if (CGRectGetWidth(globalHeaderFrame) > 0)
    {
        globalHeaderFrame.size.width = CGRectGetWidth(self.collectionView.bounds);
        self.layoutInfo.headerFrame = globalHeaderFrame;
    }
    
    contentSize.width = MAX(contentSize.width, CGRectGetWidth(self.layoutInfo.headerFrame));
    contentSize.height += CGRectGetHeight(self.layoutInfo.headerFrame);
    
    //	sections
	for (AMPerSectionCollectionViewLayoutSection *section in self.layoutInfo.layoutInfoSections)
    {
        CGFloat sectionWidth = section.width;
        section.width = (isnan(sectionWidth)) ? CGRectGetWidth(self.collectionView.bounds) : sectionWidth; // FIXME adjust me here
		[section computeLayout:self.layoutInfo];
		
		// update section offset to make frame absolute (section only calculates relative)
		CGRect sectionFrame = section.frame;
        sectionFrame.origin.y += contentSize.height;
        section.frame = sectionFrame;
        
        CGRect headerFrame = section.headerFrame;
        if (CGRectGetHeight(headerFrame) > 0)
        {
            headerFrame.size.width = CGRectGetWidth(sectionFrame);
            section.headerFrame = headerFrame;
        }
        
        CGRect footerFrame = section.footerFrame;
        if (CGRectGetHeight(footerFrame) > 0)
        {
            footerFrame.size.width = CGRectGetWidth(sectionFrame);
            section.footerFrame = footerFrame;
        }
        
        contentSize.height += CGRectGetHeight(sectionFrame);
        contentSize.width = MAX(contentSize.width, CGRectGetMaxX(section.frame));
	}
    
    //	global footer
    CGRect globalFooterFrame =  self.layoutInfo.footerFrame;
    if (CGRectGetWidth(globalFooterFrame) > 0)
    {
        globalFooterFrame.origin.x = 0;
        globalFooterFrame.origin.y = contentSize.height;
        globalFooterFrame.size.width = CGRectGetWidth(self.collectionView.bounds);
        self.layoutInfo.footerFrame = globalFooterFrame;
    }
    
	contentSize.height += CGRectGetHeight(self.layoutInfo.footerFrame);
    self.layoutInfo.contentSize = contentSize;
}

#pragma mark - Content Size

- (CGSize)collectionViewContentSize
{
	return self.layoutInfo.contentSize;
}

@end
