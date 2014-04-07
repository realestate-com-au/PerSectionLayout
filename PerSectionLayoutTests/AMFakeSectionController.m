//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMFakeSectionController.h"

@implementation AMFakeSectionController

- (id)init
{
    self = [super init];
    if (self)
    {
        _numberOfSections = 1;
        _numberOfItemsInSection = 10;
    }
    
    return self;
}

+ (NSInteger)fakeSection
{
    return 0;
}

- (NSInteger)section
{
    return [self.class fakeSection];
}

- (void)registerCustomElementsForCollectionView:(UICollectionView *)collectionView
{
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfItemsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

@end
