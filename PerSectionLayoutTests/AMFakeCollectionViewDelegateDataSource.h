//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import Foundation;
#import "AMPerSectionCollectionViewLayout.h"

@interface AMFakeCollectionViewDelegateDataSource : NSObject <UICollectionViewDataSource, AMPerSectionCollectionViewLayoutDelegate>

- (void)registerCustomElementsForCollectionView:(UICollectionView *)collectionView;

@property (nonatomic, assign) NSInteger numberOfSections;
@property (nonatomic, assign) NSInteger numberOfItemsInSection;

@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;
@property (nonatomic) CGSize sectionHeaderReferenceSize;
@property (nonatomic) CGSize sectionFooterReferenceSize;
@property (nonatomic) UIEdgeInsets sectionInset;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGFloat sectionMinimumWidth;
@property (nonatomic, assign, getter = hasStickyHeader) BOOL stickyHeader;
@property (nonatomic, assign) BOOL hasStickyHeaderOverSection;

//TODO: JC - consider making this an indexSet, or NSRange
@property (nonatomic, assign) NSInteger lastSectionWithStickyHeader;

@end
