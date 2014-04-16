//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import "AMMapExpandedCollectionViewController.h"
#import <PerSectionLayout/AMPerSectionCollectionViewLayout.h>
#import "AMMapSectionController.h"
#import "AMListSectionController.h"
#import "AMOFISectionController.h"
#import "AMGraphSectionController.h"
#import "AMADSectionController.h"
#import "AMOtherSectionController.h"
#import "UIDevice+Utilities.h"
#import "UICollectionView+Utilities.h"

@implementation AMMapExpandedCollectionViewController

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat progress = [self.collectionView verticalBouncedOffProgressForMaxOffset:30.f];
    if (progress >= 1.f)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
