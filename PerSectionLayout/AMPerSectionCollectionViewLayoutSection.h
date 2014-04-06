//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import Foundation;

@interface AMPerSectionCollectionViewLayoutSection : NSObject

- (NSArray *)layoutSectionItems;
- (NSInteger)itemsCount;
- (NSObject *)addItem;
- (void)invalidate;
- (void)computeLayout;

@property (nonatomic, assign) CGFloat verticalInterstice;
@property (nonatomic, assign) UIEdgeInsets sectionMargins;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect headerFrame;
@property (nonatomic, assign) CGRect bodyFrame;
@property (nonatomic, assign) CGRect footerFrame;


@end
