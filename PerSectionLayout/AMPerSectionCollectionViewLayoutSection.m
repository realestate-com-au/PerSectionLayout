//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutSection.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMPerSectionCollectionViewLayout.h"

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
                [row computeLayout:layoutInfo inSection:self];
                row.frame = CGRectMake(bodyOrigin.x, currentRowPoint, row.size.width, row.size.height);
                if (rowIndex > 0)
                {
                    bodySize.height += self.verticalInterstice;
                }
                bodySize.height += row.size.height;
                currentRowPoint += row.size.height + self.verticalInterstice;
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

- (UICollectionViewLayoutAttributes *)attributesForSupplementaryViewOfKind:(NSString *)kind withIndexPath:(NSIndexPath *)indexPath withOffset:(CGPoint)offset
{
    __unused CGRect sectionFrame = [self stretchedFrameForOffset:offset];

    if ([kind isEqualToString:AMPerSectionCollectionElementKindSectionHeader])
    {
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:self.index];
        if ([headerIndexPath isEqual:indexPath])
        {

        }
    }
    else if([kind isEqualToString:AMPerSectionCollectionElementKindSectionFooter])
    {
        NSIndexPath *footerIndexPath = [NSIndexPath indexPathForItem:0 inSection:self.index];
        if ([footerIndexPath isEqual:indexPath])
        {

        }
    }

    return nil;
}

- (NSArray *)layoutAttributesArrayForSectionInRect:(CGRect)rect withOffset:(CGPoint)offset
{
    NSMutableArray *layoutAttributesArray = [NSMutableArray array];

    CGRect sectionFrame = [self stretchedFrameForOffset:offset];
    if (/*CGRectEqualToRect(rect, CGRectZero) || */CGRectIntersectsRect(sectionFrame, rect))
    {
        /** Header Frame **/
        CGRect headerFrame = CGRectOffset(self.headerFrame, sectionFrame.origin.x, sectionFrame.origin.y);
        if (/*CGRectEqualToRect(rect, CGRectZero) || */(CGRectGetHeight(headerFrame) > 0) && CGRectIntersectsRect(headerFrame, rect))
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:self.index];
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionHeader withIndexPath:indexPath];
            attr.frame = headerFrame;
            [layoutAttributesArray addObject:attr];
        }

        /** Footer Frame **/
        CGRect footerFrame = CGRectOffset(self.footerFrame, sectionFrame.origin.x, sectionFrame.origin.y);
        if (/*CGRectEqualToRect(rect, CGRectZero) || */(CGRectGetHeight(footerFrame) > 0) && CGRectIntersectsRect(footerFrame, rect))
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:self.index];
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionFooter withIndexPath:indexPath];
            attr.frame = footerFrame;
            [layoutAttributesArray addObject:attr];
        }

        /** Body */
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
            
            if (/*CGRectEqualToRect(rect, CGRectZero) || */CGRectIntersectsRect(rowFrame, rect))
            {
                for (AMPerSectionCollectionViewLayoutItem *item in row.layoutSectionItems)
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item.index inSection:self.index];
                    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                    
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

    return layoutAttributesArray;
}

#pragma mark - NSObject

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p itemsCount:%ld frame:%@ bodyFrame:%@ headerFrame:%@ footerFrame:%@ rows:%@>", NSStringFromClass([self class]), self, (long)self.itemsCount, NSStringFromCGRect(self.frame), NSStringFromCGRect(self.bodyFrame), NSStringFromCGRect(self.headerFrame), NSStringFromCGRect(self.footerFrame), self.rows];
}

@end
