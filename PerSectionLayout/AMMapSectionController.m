//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMMapSectionController.h"

@implementation AMMapSectionController

- (NSInteger)section
{
    return MainSectionMap;
}

- (void)registerCustomElementsForCollectionView:(UICollectionView *)collectionView
{
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    
    return cell;
}

#pragma mark - AMPerSectionCollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 200.f);
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout hasStickyHeaderOverSection:(NSInteger)section
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout isSectionStickyAtIndex:(NSInteger)section
{
    return YES;
}

@end
