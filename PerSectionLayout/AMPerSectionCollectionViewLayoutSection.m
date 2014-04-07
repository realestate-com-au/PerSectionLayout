//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutSection.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"

@interface AMPerSectionCollectionViewLayoutSection ()
@property (nonatomic, assign) BOOL isInvalid;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation AMPerSectionCollectionViewLayoutSection

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
- (NSInteger)itemsCount
{
    return (NSInteger)self.items.count;
}

- (AMPerSectionCollectionViewLayoutItem *)addItem
{
    AMPerSectionCollectionViewLayoutItem *layoutItem = [[AMPerSectionCollectionViewLayoutItem alloc] init];
    [self.items addObject:layoutItem];
    [self invalidate];
    
    return layoutItem;
}

#pragma mark - Layout

- (void)invalidate
{
    self.isInvalid = YES;
}

- (void)computeLayout:(AMPerSectionCollectionViewLayoutInfo *)layoutInfo;
{
    // FIXME: empty for now
}

#pragma mark - NSObject

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p itemsCount:%ld frame:%@ bodyFrame:%@ headerFrame:%@ footerFrame:%@>", NSStringFromClass([self class]), self, (long)self.itemsCount, NSStringFromCGRect(self.frame), NSStringFromCGRect(self.bodyFrame), NSStringFromCGRect(self.headerFrame), NSStringFromCGRect(self.footerFrame)];
}

@end
