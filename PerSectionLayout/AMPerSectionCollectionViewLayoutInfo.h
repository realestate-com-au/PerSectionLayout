//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import Foundation;
#import "AMPerSectionCollectionViewLayoutSection.h"

@interface AMPerSectionCollectionViewLayoutInfo : NSObject

- (NSArray *)layoutInfoSections;
- (AMPerSectionCollectionViewLayoutSection *)addSection;
- (void)invalidate;
- (AMPerSectionCollectionViewLayoutSection *)sectionAtIndex:(NSInteger)section;
- (AMPerSectionCollectionViewLayoutItem *)itemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)firstSectionIndexBelowHeaderForYOffset:(CGFloat)yOffset;
- (AMPerSectionCollectionViewLayoutSection *)firstSectionAtPoint:(CGPoint)point;
- (CGRect)stickyHeaderFrameForYOffset:(CGFloat)yOffset;

- (UICollectionViewLayoutAttributes *)layoutAttributesForGlobalHeaderForRect:(CGRect)rect withOffset:(CGSize)offset;

- (void)updateItemsLayout;

@property (nonatomic, assign, getter = isValid) BOOL valid;

@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGSize collectionViewSize;
@property (nonatomic, assign) CGRect headerFrame;
@property (nonatomic, assign) CGRect footerFrame;
@property (nonatomic, assign, getter = hasStickyHeader) BOOL stickyHeader;
@property (nonatomic, assign) NSInteger lastSectionWithStickyHeader;

@end
