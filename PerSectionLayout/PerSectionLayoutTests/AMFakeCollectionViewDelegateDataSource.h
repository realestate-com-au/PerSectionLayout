//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PerSectionLayout/AMPerSectionCollectionViewLayout.h>

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
@property (nonatomic) CGFloat sectionWidth;
@property (nonatomic, assign, getter = hasStickyHeader) BOOL stickyHeader;
@property (nonatomic, assign) NSInteger sectionIndexToStretch;

//TODO: JC - consider making this an indexSet, or NSRange
@property (nonatomic, assign) NSInteger lastSectionWithStickyHeader;

@end
