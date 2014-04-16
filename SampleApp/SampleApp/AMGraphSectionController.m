//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import "AMGraphSectionController.h"
#import "UIDevice+Utilities.h"

@implementation AMGraphSectionController

- (NSInteger)section
{
    return MainSectionGraph;
}

- (void)registerCustomElementsForCollectionView:(UICollectionView *)collectionView
{
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GraphSectionCell"];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GraphSectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    
    return cell;
}

#pragma mark - AMPerSectionCollectionViewLayoutDelegate

- (CGFloat)maxWidthForCollectionView:(UICollectionView *)collectionView
{
    return [[UIDevice currentDevice] isiPad] ? 1024.f - 768.f : CGRectGetWidth(collectionView.frame);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake([self maxWidthForCollectionView:collectionView], 200.f);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout widthForSectionAtIndex:(NSInteger)section
{
    return [self maxWidthForCollectionView:collectionView];
}

@end
