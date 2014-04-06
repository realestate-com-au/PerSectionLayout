//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import Foundation;
#import "AMPerSectionCollectionViewLayoutItem.h"

@interface AMPerSectionCollectionViewLayoutSection : NSObject

- (NSArray *)layoutSectionItems;
- (NSInteger)itemsCount;
- (AMPerSectionCollectionViewLayoutItem *)addItem;
- (void)invalidate;
- (void)computeLayout;

@property (nonatomic, assign, getter = isHorizontal) BOOL horizontal; // default: No
@property (nonatomic, assign) CGFloat verticalInterstice;
@property (nonatomic, assign) CGFloat horizontalInterstice;
@property (nonatomic, assign) UIEdgeInsets sectionMargins;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect headerFrame;
@property (nonatomic, assign) CGRect bodyFrame;
@property (nonatomic, assign) CGRect footerFrame;


@end
