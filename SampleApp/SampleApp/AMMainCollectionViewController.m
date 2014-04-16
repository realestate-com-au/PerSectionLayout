//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import "AMMainCollectionViewController.h"
#import "AMSectionsProvider.h"
#import <PerSectionLayout/AMPerSectionCollectionViewLayout.h>
#import "AMMapSectionController.h"
#import "AMListSectionController.h"
#import "AMOFISectionController.h"
#import "AMGraphSectionController.h"
#import "AMADSectionController.h"
#import "AMOtherSectionController.h"
#import "UIDevice+Utilities.h"
#import "AMMapExpandedCollectionViewController.h"
#import "UICollectionView+Utilities.h"

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
        [self.sectionsProvider addSectionControllerForClass:[AMMapSectionController class]];
        [self.sectionsProvider addSectionControllerForClass:[AMListSectionController class]];
        [self.sectionsProvider addSectionControllerForClass:[AMOFISectionController class]];
        [self.sectionsProvider addSectionControllerForClass:[AMGraphSectionController class]];
        [self.sectionsProvider addSectionControllerForClass:[AMADSectionController class]];
        [self.sectionsProvider addSectionControllerForClass:[AMOtherSectionController class]];
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AMPerSectionCollectionViewLayout *layout = (AMPerSectionCollectionViewLayout *)self.collectionViewLayout;
    layout.stickyHeader = [[UIDevice currentDevice] isiPad];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:AMPerSectionCollectionElementKindHeader withReuseIdentifier:@"header"];
    [self.sectionsProvider registerCustomElementsForCollectionView:self.collectionView];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push Layout" style:UIBarButtonItemStylePlain target:self action:@selector(pushViewControllerWithNewLayout)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)pushViewControllerWithNewLayout
{
    AMPerSectionCollectionViewLayout *expandedLayout = [[AMPerSectionCollectionViewLayout alloc] init];
    expandedLayout.expanded = YES;
    
    AMMapExpandedCollectionViewController *viewController = [[AMMapExpandedCollectionViewController alloc] initWithCollectionViewLayout:expandedLayout];
    viewController.sectionsProvider = self.sectionsProvider;
    viewController.useLayoutToLayoutNavigationTransitions = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Utilities

- (BOOL)canHandleSupplementaryElementOfKind:(NSString *)kind
{
    return ([kind isEqualToString:AMPerSectionCollectionElementKindHeader] ||
            [kind isEqualToString:AMPerSectionCollectionElementKindFooter]);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat progress = [self.collectionView verticalBouncedOffProgressForMaxOffset:-60.f];
    if (progress >= 1.f)
    {
        [self pushViewControllerWithNewLayout];
    }
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
    if ([self canHandleSupplementaryElementOfKind:kind])
    {
        if ([kind isEqualToString:AMPerSectionCollectionElementKindHeader])
        {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:AMPerSectionCollectionElementKindHeader withReuseIdentifier:@"header"  forIndexPath:indexPath];
            view.backgroundColor = [UIColor redColor];
            
            return view;
        }
    }
    else
    {
        id<AMSectionController> sectionController = [self.sectionsProvider controllerForSection:indexPath.section];
        if ([sectionController respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)])
        {
            return [sectionController collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        }
    }
    
    return nil;
}

@end
