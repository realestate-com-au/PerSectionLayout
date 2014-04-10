//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutSection.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"

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

- (CGRect)stickyFrameForYOffset:(CGFloat)yOffset
{
    CGRect normalizedSectionFrame = self.frame;
    
    if (self.sticky)
    {
        normalizedSectionFrame.origin.y = yOffset + CGRectGetMinY(normalizedSectionFrame);
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
    AMPerSectionCollectionViewLayoutRow *row = nil;
    
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

#pragma mark - NSObject

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p itemsCount:%ld frame:%@ bodyFrame:%@ headerFrame:%@ footerFrame:%@ rows:%@>", NSStringFromClass([self class]), self, (long)self.itemsCount, NSStringFromCGRect(self.frame), NSStringFromCGRect(self.bodyFrame), NSStringFromCGRect(self.headerFrame), NSStringFromCGRect(self.footerFrame), self.rows];
}

@end
