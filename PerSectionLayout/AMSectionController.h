//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import UIKit;
#import "MainSections.h"
#import "AMPerSectionCollectionViewLayout.h"

@protocol AMSectionController <NSObject, UICollectionViewDataSource, AMPerSectionCollectionViewLayoutDelegate>

- (NSInteger)section;
- (void)registerCustomElementsForCollectionView:(UICollectionView *)collectionView;

@end
