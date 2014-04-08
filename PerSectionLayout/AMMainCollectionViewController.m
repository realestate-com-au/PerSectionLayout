//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMMainCollectionViewController.h"
#import "AMSectionsProvider.h"
#import "AMListSectionController.h"
#import "AMPerSectionCollectionViewLayout.h"

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
       [self.sectionsProvider addSectionControllerForClass:[AMListSectionController class]];
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:AMPerSectionCollectionElementKindHeader withReuseIdentifier:@"header"];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:AMPerSectionCollectionElementKindHeader])
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:AMPerSectionCollectionElementKindHeader withReuseIdentifier:@"header"  forIndexPath:indexPath];
        view.backgroundColor = [UIColor redColor];
        
        return view;
    }
    
    return nil;
}

#pragma mark -  AMPerSectionCollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForHeaderInLayout:(AMPerSectionCollectionViewLayout *)collectionViewLayout
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 50);
}

@end
