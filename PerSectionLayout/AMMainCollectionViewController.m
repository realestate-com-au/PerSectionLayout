//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMMainCollectionViewController.h"
#import "AMSectionsProvider.h"

@interface AMMainCollectionViewController ()
@property (nonatomic, strong) AMSectionsProvider *sectionsProvider;
@end

@implementation AMMainCollectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.sectionsProvider = [[AMSectionsProvider alloc] init];
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.sectionsProvider registerCustomElementsForCollectionView:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (NSInteger)self.sectionsProvider.sectionControllersCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:section];
    return [sectionController collectionView:collectionView numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:indexPath.section];
    return [sectionController collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

@end
