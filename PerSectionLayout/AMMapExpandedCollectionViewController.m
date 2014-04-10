//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMMapExpandedCollectionViewController.h"
#import "AMPerSectionCollectionViewLayout.h"
#import "AMMapSectionController.h"
#import "AMListSectionController.h"
#import "AMOFISectionController.h"
#import "AMGraphSectionController.h"
#import "AMADSectionController.h"
#import "AMOtherSectionController.h"
#import "UIDevice+Utilities.h"

@implementation AMMapExpandedCollectionViewController

#pragma mark -  AMPerSectionCollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForHeaderInLayout:(AMPerSectionCollectionViewLayout *)collectionViewLayout
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 50);
}

@end
