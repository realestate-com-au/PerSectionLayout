//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutRow.h"
#import "AMPerSectionCollectionViewLayoutSection.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"

@interface AMPerSectionCollectionViewLayoutRow ()
@property (nonatomic, assign) BOOL isInvalid;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation AMPerSectionCollectionViewLayoutRow

- (id)init
{
    self = [super init];
    if (self)
    {
        _items = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Items

- (NSArray *)layoutSectionItems
{
    return [self.items copy];
}

- (void)addItem:(AMPerSectionCollectionViewLayoutItem *)item
{
    [self.items addObject:item];
    [self invalidate];
}

#pragma mark - Layout

- (void)invalidate
{
    self.isInvalid = YES;
	self.size = CGSizeZero;
	self.frame = CGRectZero;
}

- (void)computeLayout:(AMPerSectionCollectionViewLayoutInfo *)layoutInfo inSection:(AMPerSectionCollectionViewLayoutSection *)section
{
    // calculate space that's left over if we would align it from left to right.
    CGFloat leftOverSpace = layoutInfo.collectionViewSize.width;
    leftOverSpace -= section.sectionMargins.left + section.sectionMargins.right;
    
    // calculate the space that we have left after counting all items.
    // UICollectionView is smart and lays out items like they would have been placed on a full row
    // So we need to calculate the "usedItemCount" with using the last item as a reference size.
    // This allows us to correctly justify-place the items in the grid.
    NSInteger usedItemCount = 0;
    NSInteger itemIndex = 0;
    BOOL canFitMoreItems = itemIndex < self.itemsCount;
    while (itemIndex < self.itemsCount || canFitMoreItems)
    {
        AMPerSectionCollectionViewLayoutItem *item = self.items[(NSUInteger)MIN(itemIndex, self.itemsCount - 1)];
        leftOverSpace -= CGRectGetWidth(item.frame);
        canFitMoreItems = (leftOverSpace > CGRectGetWidth(item.frame));
        // separator starts after first item
        if (itemIndex > 0)
        {
            leftOverSpace -= section.horizontalInterstice;
        }
        itemIndex++;
        usedItemCount = itemIndex;
    }
    
    CGPoint itemOffset = CGPointZero;
    
    // calculate row frame as union of all items
    CGRect frame = CGRectZero;
    CGRect itemFrame = CGRectZero;
    for (AMPerSectionCollectionViewLayoutItem *item in self.items)
    {
        itemFrame = [item frame];
        itemFrame.origin.x = itemOffset.x;
        itemOffset.x += itemFrame.size.width + section.horizontalInterstice;
        //itemOffset.x += leftOverSpace/(CGFloat)(usedItemCount - 1); // FIXME: do we need this
        item.frame = CGRectIntegral(itemFrame);
        frame = CGRectUnion(frame, itemFrame);
    }
    
    self.size = frame.size;
}

#pragma mark - NSObject

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p frame:%@ index:%d items:%@>", NSStringFromClass([self class]), self, NSStringFromCGRect(self.frame), self.index, self.items];
}

@end
