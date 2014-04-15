//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutSection.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMPerSectionCollectionViewLayout.h"
#import "AMPerSectionCollectionViewLayoutAttributes.h"

@interface AMPerSectionCollectionViewLayoutSection ()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *rows;
@end

@implementation AMPerSectionCollectionViewLayoutSection

- (id)init
{
    self = [super init];
    if (self)
    {
        _items = [NSMutableArray array];
        _rows = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Sticky

- (CGRect)stretchedFrameForOffset:(CGPoint)offset
{
    CGRect normalizedSectionFrame = self.frame;
    if (self.canStretch && offset.y < 0)
    {
        normalizedSectionFrame.origin.y += offset.y;
        normalizedSectionFrame.size.height = MAX(0, CGRectGetHeight(normalizedSectionFrame) - offset.y);
    }
    
    return normalizedSectionFrame;
}

#pragma mark - Items

- (NSArray *)layoutSectionItems
{
    return [self.items copy];
}

- (NSInteger)itemsCount
{
    return (NSInteger)self.items.count;
}

- (AMPerSectionCollectionViewLayoutItem *)addItem
{
    AMPerSectionCollectionViewLayoutItem *layoutItem = [[AMPerSectionCollectionViewLayoutItem alloc] init];
    [self.items addObject:layoutItem];
    layoutItem.index = (NSInteger)[self.items indexOfObject:layoutItem];
    
    return layoutItem;
}

#pragma mark - Rows

- (NSArray *)layoutSectionRows
{
    return [self.rows copy];
}

- (AMPerSectionCollectionViewLayoutRow *)addRow
{
    AMPerSectionCollectionViewLayoutRow *layoutItem = [[AMPerSectionCollectionViewLayoutRow alloc] init];
    [self.rows addObject:layoutItem];
    
    return layoutItem;
}

- (void)invalidate
{
    [self.rows removeAllObjects];
}

#pragma mark - Layout

- (void)computeLayout:(__unused AMPerSectionCollectionViewLayoutInfo *)layoutInfo
{
    // iterate over all items, turning them into rows.
    CGPoint bodyOrigin = CGPointZero;
    CGSize bodySize = CGSizeZero;
    NSInteger rowIndex = 0;
    NSInteger itemIndex = 0;
    CGFloat dimensionLeft = 0;
    AMPerSectionCollectionViewLayoutRow *row;
    
    //	header origin is 0, 0. nothing to do
    
    // get available space for section body, compensate for section margins
    CGFloat dimension = self.width;
    
    dimension -= (self.sectionMargins.left + self.sectionMargins.right);
    bodySize.width = dimension;
    
    if (CGRectIsEmpty(self.headerFrame)) //no header frame
    {
        bodyOrigin = CGPointMake(self.sectionMargins.left, self.sectionMargins.top);
    }
    else
    {
        //Restrict the header width to our section width
        CGRect normalisedHeaderFrame = (CGRect){.origin = CGPointZero, .size = CGSizeMake(self.width, self.headerFrame.size.height)};
        self.headerFrame = normalisedHeaderFrame;

        bodyOrigin.x = 0;
        bodyOrigin.x += self.sectionMargins.left;
        bodyOrigin.y = self.headerFrame.size.height;
        bodyOrigin.y += self.sectionMargins.top;
    }
    
    CGFloat currentRowPoint = bodyOrigin.y;
    
    do
    {
        BOOL finishCycle = (itemIndex >= self.itemsCount);
        
        AMPerSectionCollectionViewLayoutItem *item;
        if (!finishCycle)
        {
            item = self.items[(NSUInteger)itemIndex];
        }
        
        CGSize itemSize = item.frame.size;
        CGFloat itemDimension = itemSize.width;
        itemDimension += self.horizontalInterstice;
        
        if (dimensionLeft < itemDimension || finishCycle)
        {
            // finish current row
            if (row)
            {
                [row computeLayoutInSection:self];
                row.frame = CGRectMake(bodyOrigin.x, currentRowPoint, CGRectGetWidth(row.frame), CGRectGetHeight(row.frame));
                if (rowIndex > 0)
                {
                    bodySize.height += self.verticalInterstice;
                }
                bodySize.height += CGRectGetHeight(row.frame);
                currentRowPoint += CGRectGetHeight(row.frame) + self.verticalInterstice;
            }
            if (!finishCycle)
            {
                // create new row
                row = [self addRow];
                row.index = rowIndex;
                rowIndex++;
                dimensionLeft = dimension;
            }
        }

        dimensionLeft -= itemDimension;
        
        if (item)
        {
            [row addItem:item];
        }
        itemIndex++;

    } while (itemIndex <= self.itemsCount); // cycle once more to finish last row
    
    self.bodyFrame = (CGRect){.origin = bodyOrigin, .size = bodySize};
    
    CGFloat footerOrigin = bodyOrigin.y + bodySize.height + self.sectionMargins.bottom;

    CGRect footerframe = self.footerFrame;
    if (!CGRectIsEmpty(footerframe))
    {
        footerframe.origin.x = 0;
        footerframe.origin.y = footerOrigin;
        footerframe.size.width = self.width;
        self.footerFrame = footerframe;
    }

    CGPoint sectionOrigin = CGPointZero;
    CGSize sectionSize = CGSizeZero;
    sectionSize.width = self.width;
    sectionSize.height = footerOrigin + footerframe.size.height;
    self.frame = (CGRect){.origin = sectionOrigin, .size = sectionSize};
}

#pragma mark - UICollectionViewLayoutAttributes

- (UICollectionViewLayoutAttributes *)layoutAttributesForSectionHeaderWithOffset:(CGPoint)offset
{
    CGRect sectionFrame = [self stretchedFrameForOffset:offset];
    CGRect headerFrame = CGRectOffset(self.headerFrame, sectionFrame.origin.x, sectionFrame.origin.y);
    if (CGRectGetHeight(headerFrame) > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:self.index];
        AMPerSectionCollectionViewLayoutAttributes *attr = [AMPerSectionCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionHeader withIndexPath:indexPath];
        attr.frame = headerFrame;
        attr.adjustmentOffset = offset;
        return attr;
    }

    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSectionFooterWithOffset:(CGPoint)offset
{
    CGRect sectionFrame = [self stretchedFrameForOffset:offset];
    CGRect footerFrame = CGRectOffset(self.footerFrame, sectionFrame.origin.x, sectionFrame.origin.y);
    if (CGRectGetHeight(footerFrame) > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:self.index];
        AMPerSectionCollectionViewLayoutAttributes *attr = [AMPerSectionCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionFooter withIndexPath:indexPath];
        attr.frame = footerFrame;
        attr.adjustmentOffset = offset;
        return attr;
    }

    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind withIndexPath:(NSIndexPath *)indexPath withOffset:(CGPoint)offset
{
    if ([kind isEqualToString:AMPerSectionCollectionElementKindSectionHeader])
    {
        //FIXME: JC - this check (row/section) is doubling up on the indexPath given to the attributes above.
        if (indexPath.section == self.index && indexPath.row == 0)
        {
            return [self layoutAttributesForSectionHeaderWithOffset:offset];
        }
    }
    else if([kind isEqualToString:AMPerSectionCollectionElementKindSectionFooter])
    {
        if (indexPath.section == self.index && indexPath.row == 0)
        {
            return [self layoutAttributesForSectionFooterWithOffset:offset];
        }
    }

    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath withOffset:(CGPoint)offset
{
    CGRect sectionFrame = [self stretchedFrameForOffset:offset];

    AMPerSectionCollectionViewLayoutItem *item = self.layoutSectionItems[(NSUInteger)indexPath.row];

    AMPerSectionCollectionViewLayoutRow *row = item.row;
    CGRect rowFrame = CGRectOffset(row.frame, sectionFrame.origin.x, sectionFrame.origin.y);

    AMPerSectionCollectionViewLayoutAttributes *attr = [AMPerSectionCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectOffset(item.frame, rowFrame.origin.x, rowFrame.origin.y);
    attr.adjustmentOffset = offset;

    return attr;
}

- (NSArray *)layoutAttributesArrayForSectionInRect:(CGRect)rect withOffset:(CGPoint)offset
{
    NSMutableArray *layoutAttributesArray = [NSMutableArray array];

    CGRect sectionFrame = [self stretchedFrameForOffset:offset];
    if (CGRectIntersectsRect(sectionFrame, rect))
    {
        UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSectionHeaderWithOffset:offset];
        if (headerAttributes != nil && CGRectIntersectsRect(headerAttributes.frame, rect))
        {
            [layoutAttributesArray addObject:headerAttributes];
        }

        UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSectionFooterWithOffset:offset];
        if (footerAttributes != nil && CGRectIntersectsRect(footerAttributes.frame, rect))
        {
            [layoutAttributesArray addObject:footerAttributes];
        }

        //FIXME: JC - can this be written like the header/footer?
        CGFloat firstRowSizeAdjustment = 0;
        for (AMPerSectionCollectionViewLayoutRow *row in self.layoutSectionRows)
        {
            BOOL shouldStretchFirstRow = (self.canStretch && row.index == 0);
            
            CGRect rowFrame = CGRectOffset(row.frame, sectionFrame.origin.x, sectionFrame.origin.y);
            rowFrame.origin.y += firstRowSizeAdjustment;
            if (shouldStretchFirstRow)
            {
                firstRowSizeAdjustment = MAX(0, CGRectGetHeight(sectionFrame) - CGRectGetHeight(self.frame));
                rowFrame.size.height += firstRowSizeAdjustment;
            }
            
            if (CGRectIntersectsRect(rowFrame, rect))
            {
                for (AMPerSectionCollectionViewLayoutItem *item in row.layoutSectionItems)
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item.index inSection:self.index];
                    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath withOffset:offset];
                    if (attr != nil)
                    {
                        CGRect itemFrame = CGRectOffset(item.frame, rowFrame.origin.x, rowFrame.origin.y);
                        if (shouldStretchFirstRow)
                        {
                            itemFrame.size.height = CGRectGetHeight(rowFrame);
                        }
                        attr.frame = itemFrame;
                        [layoutAttributesArray addObject:attr];
                    }
                }
            }
        }
    }

    return layoutAttributesArray;
}

#pragma mark - NSObject

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p itemsCount:%ld frame:%@ bodyFrame:%@ headerFrame:%@ footerFrame:%@ rows:%@>", NSStringFromClass([self class]), self, (long)self.itemsCount, NSStringFromCGRect(self.frame), NSStringFromCGRect(self.bodyFrame), NSStringFromCGRect(self.headerFrame), NSStringFromCGRect(self.footerFrame), self.rows];
}

@end
