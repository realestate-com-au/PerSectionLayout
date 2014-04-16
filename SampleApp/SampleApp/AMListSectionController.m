//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import "AMListSectionController.h"
#import "MainSections.h"
#import "UIDevice+Utilities.h"

@interface AMBackgroundSectionView : UICollectionReusableView
@end

@implementation AMBackgroundSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

@end

@implementation AMListSectionController

- (NSInteger)section
{
    return MainSectionList;
}

- (void)registerCustomElementsForCollectionView:(UICollectionView *)collectionView
{
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ListSectionCell"];
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionHeader withReuseIdentifier:@"ListSectionHeader"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionFooter withReuseIdentifier:@"ListSectionFooter"];
    
}

#pragma mark - Utilities

- (CGFloat)maxWidthForCollectionView:(UICollectionView *)collectionView
{
    return [[UIDevice currentDevice] isiPad] ? 768.f : CGRectGetWidth(collectionView.frame);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListSectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:AMPerSectionCollectionElementKindSectionHeader])
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionHeader withReuseIdentifier:@"ListSectionHeader"  forIndexPath:indexPath];
        view.backgroundColor = [UIColor brownColor];
        
        return view;
    }
    else if ([kind isEqualToString:AMPerSectionCollectionElementKindSectionFooter])
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionFooter withReuseIdentifier:@"ListSectionFooter"  forIndexPath:indexPath];
        view.backgroundColor = [UIColor magentaColor];
        
        return view;
    }
    
    return nil;
}

#pragma mark - AMPerSectionCollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake([self maxWidthForCollectionView:collectionView], 50.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout widthForSectionAtIndex:(NSInteger)section
{
    return [self maxWidthForCollectionView:collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([self maxWidthForCollectionView:collectionView], 70.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake([self maxWidthForCollectionView:collectionView], 20.f);
}

@end
