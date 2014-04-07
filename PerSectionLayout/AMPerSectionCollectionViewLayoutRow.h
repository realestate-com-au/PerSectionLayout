//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import Foundation;
#import "AMPerSectionCollectionViewLayoutItem.h"
@class AMPerSectionCollectionViewLayoutSection;
@class AMPerSectionCollectionViewLayoutInfo;

@interface AMPerSectionCollectionViewLayoutRow : NSObject

- (NSArray *)layoutSectionItems;
- (NSInteger)itemsCount;
- (void)addItem:(AMPerSectionCollectionViewLayoutItem *)item;
- (void)invalidate;
- (void)computeLayout:(AMPerSectionCollectionViewLayoutInfo *)layoutInfo inSection:(AMPerSectionCollectionViewLayoutSection *)section;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) NSInteger index;

@end
