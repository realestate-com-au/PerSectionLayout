//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import Foundation;
#import "AMPerSectionCollectionViewLayoutItem.h"
#import "AMPerSectionCollectionViewLayoutRow.h"
@class AMPerSectionCollectionViewLayoutInfo;

@interface AMPerSectionCollectionViewLayoutSection : NSObject

- (NSArray *)layoutSectionItems;
- (NSArray *)layoutSectionRows;
- (NSInteger)itemsCount;
- (AMPerSectionCollectionViewLayoutItem *)addItem;
- (AMPerSectionCollectionViewLayoutRow *)addRow;
- (void)invalidate;
- (void)computeLayout:(AMPerSectionCollectionViewLayoutInfo *)layoutInfo;
- (CGRect)stickyFrameForYOffset:(CGFloat)yOffset;

@property (nonatomic, assign) CGFloat verticalInterstice;
@property (nonatomic, assign) CGFloat horizontalInterstice;
@property (nonatomic, assign) UIEdgeInsets sectionMargins;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect headerFrame;
@property (nonatomic, assign) CGRect bodyFrame;
@property (nonatomic, assign) CGRect footerFrame;
@property (nonatomic, assign, getter = isSticky) BOOL sticky;
@property (nonatomic, assign, getter = hasDecorationBackground) BOOL decorationBackground;

@end
