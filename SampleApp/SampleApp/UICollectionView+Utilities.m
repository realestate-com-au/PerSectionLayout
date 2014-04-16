//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import "UICollectionView+Utilities.h"

@implementation UICollectionView (Utilities)

- (CGFloat)verticalBouncedOffProgressForMaxOffset:(CGFloat)maxOffset
{
    CGFloat progress = MAX(MIN(((self.contentOffset.y + self.contentInset.top) / maxOffset), 1.f), 0.f);
    return progress;
}

@end
