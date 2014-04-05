//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import UIKit;
#import "MainSections.h"

@protocol AMSectionController <NSObject, UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)section;
- (void)registerCustomElementsForCollectionView:(UICollectionView *)collectionView;

@end
