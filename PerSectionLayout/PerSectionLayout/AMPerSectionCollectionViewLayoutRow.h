//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import Foundation;
@class AMPerSectionCollectionViewLayoutItem;
@class AMPerSectionCollectionViewLayoutSection;

@interface AMPerSectionCollectionViewLayoutRow : NSObject

- (NSArray *)layoutSectionItems;
- (void)addItem:(AMPerSectionCollectionViewLayoutItem *)item;
- (NSInteger)itemsCount;
- (void)computeLayoutInSection:(AMPerSectionCollectionViewLayoutSection *)section;
- (void)invalidate __unused;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) NSInteger index;

@end
