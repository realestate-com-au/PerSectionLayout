//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPerSectionCollectionViewLayoutItem.h"
#import "AMPerSectionCollectionViewLayoutRow.h"
@class AMPerSectionCollectionViewLayoutInfo;

@interface AMPerSectionCollectionViewLayoutSection : NSObject

- (NSArray *)layoutSectionItems;
- (NSArray *)layoutSectionRows;
- (NSInteger)itemsCount;
- (NSInteger)lastItemIndex;
- (AMPerSectionCollectionViewLayoutItem *)addItem;
- (AMPerSectionCollectionViewLayoutRow *)addRow;
- (void)invalidate;
- (void)computeLayout:(AMPerSectionCollectionViewLayoutInfo *)layoutInfo;
- (CGRect)stretchedFrameForOffset:(CGPoint)offset;

- (NSArray *)layoutAttributesArrayForSectionInRect:(CGRect)rect withOffset:(CGPoint)offset;
- (UICollectionViewLayoutAttributes *)layoutAttributesForSectionHeaderWithOffset:(CGPoint)offset;
- (UICollectionViewLayoutAttributes *)layoutAttributesForSectionFooterWithOffset:(CGPoint)offset;

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath withOffset:(CGPoint)offset;
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind withIndexPath:(NSIndexPath *)indexPath withOffset:(CGPoint)offset;

@property (nonatomic, assign) CGFloat verticalInterstice;
@property (nonatomic, assign) CGFloat horizontalInterstice;
@property (nonatomic, assign) UIEdgeInsets sectionMargins;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect headerFrame;
@property (nonatomic, assign) CGRect bodyFrame;
@property (nonatomic, assign) CGRect footerFrame;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign, getter = canStretch) BOOL stretch;

@end
