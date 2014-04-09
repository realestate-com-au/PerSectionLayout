//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import Foundation;
#import "AMPerSectionCollectionViewLayoutItem.h"
@class AMPerSectionCollectionViewLayoutSection;
@class AMPerSectionCollectionViewLayoutInfo;

@interface AMPerSectionCollectionViewLayoutRow : NSObject

- (NSArray *)layoutSectionItems;
- (void)addItem:(AMPerSectionCollectionViewLayoutItem *)item;
- (void)computeLayout:(AMPerSectionCollectionViewLayoutInfo *)layoutInfo inSection:(AMPerSectionCollectionViewLayoutSection *)section;
- (void)invalidate;

@property (nonatomic, readonly) NSInteger itemsCount;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) NSInteger index;

@end
