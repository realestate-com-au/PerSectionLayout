//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayout.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"

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
}

#pragma mark - Layout attributes

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
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
    
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), headerReferenceSize.height);
}

- (CGSize)sizeForFooter
{
    CGSize footerReferenceSize = self.footerReferenceSize;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:sizeForFooterInLayout:)])
    {
        footerReferenceSize = [self.collectionViewDelegate collectionView:self.collectionView sizeForFooterInLayout:self];
    }
    
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), footerReferenceSize.height);
}
- (CGSize)sizeForHeaderInSection:(NSInteger)section isHorizontal:(BOOL)isHorzontal
{
    CGSize sectionHeaderReferenceSize = self.sectionHeaderReferenceSize;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:sizeForHeaderInSection:)])
    {
        sectionHeaderReferenceSize = [self.collectionViewDelegate collectionView:self.collectionView layout:self sizeForHeaderInSection:section];
    }
    
    if (isHorzontal)
    {
        sectionHeaderReferenceSize = CGSizeMake(sectionHeaderReferenceSize.width, CGRectGetHeight(self.collectionView.bounds));
    }
    else
    {
        sectionHeaderReferenceSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), sectionHeaderReferenceSize.height);
    }
    
    return sectionHeaderReferenceSize;
}

- (CGSize)sizeForFooterInSection:(NSInteger)section isHorizontal:(BOOL)isHorzontal
{
    CGSize sectionFooterReferenceSize = self.sectionFooterReferenceSize;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:sizeForFooterInSection:)])
    {
        sectionFooterReferenceSize = [self.collectionViewDelegate collectionView:self.collectionView layout:self sizeForFooterInSection:section];
    }
    
    if (isHorzontal)
    {
        sectionFooterReferenceSize = CGSizeMake(sectionFooterReferenceSize.width, CGRectGetHeight(self.collectionView.bounds));
    }
    else
    {
        sectionFooterReferenceSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), sectionFooterReferenceSize.height);
    }
    
    return sectionFooterReferenceSize;
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

- (BOOL)isLayoutHorizontalForSectionAtIndex:(NSInteger)section
{
    BOOL isLayoutHorizontal = self.isSectionLayoutHorizontal;
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:layout:isLayoutHorizontalInSection:)])
    {
        isLayoutHorizontal = [self.collectionViewDelegate collectionView:self.collectionView layout:self isLayoutHorizontalInSection:section];
    }
    
    return isLayoutHorizontal;
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
        layoutSection.horizontal = [self isLayoutHorizontalForSectionAtIndex:section];
		
		layoutSection.headerFrame = (CGRect){.size = [self sizeForHeaderInSection:section isHorizontal:layoutSection.isHorizontal]};
        layoutSection.footerFrame = (CGRect){.size = [self sizeForFooterInSection:section isHorizontal:layoutSection.isHorizontal]};
        layoutSection.sectionMargins = [self insetForSectionAtIndex:section];
        layoutSection.verticalInterstice = layoutSection.isHorizontal ?  [self minimumInteritemSpacingForSectionAtIndex:section] : [self minimumLineSpacingForSectionAtIndex:section];
        layoutSection.horizontalInterstice = layoutSection.isHorizontal ? [self minimumLineSpacingForSectionAtIndex:section] : [self minimumInteritemSpacingForSectionAtIndex:section];
        
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
    contentSize.width = MAX(contentSize.width, CGRectGetWidth(self.layoutInfo.headerFrame));
    contentSize.height += CGRectGetHeight(self.layoutInfo.headerFrame);
    
    //	sections
	for (AMPerSectionCollectionViewLayoutSection *section in self.layoutInfo.layoutInfoSections)
    {
		[section computeLayout];
		
		// update section offset to make frame absolute (section only calculates relative)
		CGRect sectionFrame = section.frame;
        sectionFrame.origin.y += contentSize.height;
        section.frame = sectionFrame;
        
        contentSize.height += CGRectGetMaxY(sectionFrame);
        contentSize.width = MAX(contentSize.width, CGRectGetMaxX(section.frame));
	}
    
    //	global footer
	CGPoint footerOrigin = CGPointZero;
    footerOrigin.y = contentSize.height;
    contentSize.width = MAX(contentSize.width, CGRectGetWidth(self.layoutInfo.footerFrame));
    contentSize.height += CGRectGetHeight(self.layoutInfo.footerFrame);
    self.layoutInfo.footerFrame = (CGRect){.origin = footerOrigin, .size = self.layoutInfo.footerFrame.size};
    
    self.layoutInfo.contentSize = contentSize;
}

#pragma mark - Content Size

- (CGSize)collectionViewContentSize
{
	return self.layoutInfo.contentSize;
}

@end
