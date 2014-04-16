//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPerSectionCollectionViewLayoutSection.h"

@interface AMPerSectionCollectionViewLayoutInfo : NSObject

- (NSArray *)layoutInfoSections;
- (NSInteger)lastSectionIndex;
- (AMPerSectionCollectionViewLayoutSection *)addSection;
- (void)invalidate;
- (AMPerSectionCollectionViewLayoutSection *)sectionAtIndex:(NSInteger)section;
- (AMPerSectionCollectionViewLayoutItem *)itemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)firstSectionIndexBelowHeaderForYOffset:(CGFloat)yOffset;
- (AMPerSectionCollectionViewLayoutSection *)firstSectionAtPoint:(CGPoint)point;
- (CGRect)stickyHeaderFrameForYOffset:(CGFloat)yOffset;

- (UICollectionViewLayoutAttributes *)layoutAttributesForGlobalHeaderWithOffset:(CGPoint)offset;
- (UICollectionViewLayoutAttributes *)layoutAttributesForGlobalFooterWithOffset:(CGPoint)offset;

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath withOffset:(CGPoint)offset;
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind withIndexPath:(NSIndexPath *)indexPath withOffset:(CGPoint)offset;

- (void)updateItemsLayout;

@property (nonatomic, assign, getter = isValid) BOOL valid;

@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGSize collectionViewSize;
@property (nonatomic, assign) CGRect headerFrame;
@property (nonatomic, assign) CGRect footerFrame;
@property (nonatomic, assign, getter = hasStickyHeader) BOOL stickyHeader;
@property (nonatomic, assign) NSInteger lastSectionWithStickyHeader;

@end
