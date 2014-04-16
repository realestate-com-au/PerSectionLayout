//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import "AMMapSectionController.h"
#import "UIDevice+Utilities.h"

@implementation AMMapSectionController

- (NSInteger)section
{
    return MainSectionMap;
}

- (void)registerCustomElementsForCollectionView:(UICollectionView *)collectionView
{
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MapSectionCell"];
}

#pragma mark - Utilities

- (CGFloat)maxCellHeight:(BOOL)expanded
{
    if ([[UIDevice currentDevice] isiPad])
    {
        return  (expanded) ? 400.f : 200.f;
    }
    
    return (expanded) ? 300.f : 200.f;
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MapSectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    
    return cell;
}

#pragma mark - AMPerSectionCollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), [self maxCellHeight:[collectionViewLayout isExpanded]]);
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout hasStickyHeaderOverSection:(NSInteger)section
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout canStretchSectionAtIndex:(NSInteger)section
{
    return YES;
}

@end
