//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutSection.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"

@interface AMPerSectionCollectionViewLayoutSection ()
@property (nonatomic, assign) BOOL isInvalid;
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

#pragma mark - Layout

- (void)invalidate
{
    self.isInvalid = YES;
    self.rows = [NSMutableArray array];
}

- (void)computeLayout:(AMPerSectionCollectionViewLayoutInfo *)layoutInfo
{
    // iterate over all items, turning them into rows.
    CGPoint bodyOrigin = CGPointZero;
    CGSize bodySize = CGSizeZero;
    NSInteger rowIndex = 0;
    NSInteger itemIndex = 0;
    NSInteger itemsByRowCount = 0;
    CGFloat dimensionLeft = 0;
    AMPerSectionCollectionViewLayoutRow *row = nil;
    
    //	header origin is 0, 0. nothing to do
    
    // get available space for section body, compensate for section margins
    CGFloat dimension = self.width;
    
    dimension -= self.sectionMargins.left + self.sectionMargins.right;
    bodySize.width = dimension;
    
    if (CGRectIsEmpty(self.headerFrame))
        bodyOrigin = CGPointMake(self.sectionMargins.left, self.sectionMargins.top);
    else {
        bodyOrigin.x = 0;
        bodyOrigin.x += self.sectionMargins.left;
        bodyOrigin.y = self.headerFrame.size.height;
        bodyOrigin.y += self.sectionMargins.top;
    }
    
    CGFloat currentRowPoint = bodyOrigin.y;
    
    do {
        BOOL finishCycle = (itemIndex >= self.itemsCount);
        
        AMPerSectionCollectionViewLayoutItem *item = nil;
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
                // compensate last row
                row.itemsCount = itemsByRowCount;
                [row computeLayout:layoutInfo inSection:self];
                row.frame = CGRectMake(bodyOrigin.x, currentRowPoint, row.size.width, row.size.height);
                if (rowIndex > 0) bodySize.height += self.verticalInterstice;
                bodySize.height += row.size.height;
                currentRowPoint += row.size.height + self.verticalInterstice;
            }
            if (!finishCycle)
            {
                // create new row
                row = [self addRow];
                row.index = rowIndex;
                rowIndex++;
                itemsByRowCount = 0;
                dimensionLeft = dimension;
            }
        }
        dimensionLeft -= itemDimension;
        
        if (item)
        {
            [row addItem:item];
        }
        itemIndex++;
        itemsByRowCount++;
    } while (itemIndex <= self.itemsCount); // cycle once more to finish last row
    
    self.bodyFrame = (CGRect){.origin = bodyOrigin, .size = bodySize};
    
    CGRect ff = self.footerFrame;
    CGFloat footerOrigin = bodyOrigin.y + bodySize.height + self.sectionMargins.bottom;;
    
    if (CGRectGetHeight(ff) > 0)
    {
        ff.origin.x = 0;
        ff.origin.y = footerOrigin;
        self.footerFrame = ff;
    }
    
    CGPoint sectionOrigin = CGPointZero;
    CGSize sectionSize = CGSizeZero;
    sectionSize.width = MAX(self.headerFrame.size.width, bodySize.width + self.sectionMargins.left + self.sectionMargins.right);
    sectionSize.height = footerOrigin + ff.size.height;
    self.frame = (CGRect){.origin = sectionOrigin, .size = sectionSize};
}

#pragma mark - NSObject

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p itemsCount:%ld frame:%@ bodyFrame:%@ headerFrame:%@ footerFrame:%@ rows:%@>", NSStringFromClass([self class]), self, (long)self.itemsCount, NSStringFromCGRect(self.frame), NSStringFromCGRect(self.bodyFrame), NSStringFromCGRect(self.headerFrame), NSStringFromCGRect(self.footerFrame), self.rows];
}

@end
