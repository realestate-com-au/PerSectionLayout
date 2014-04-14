//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMSectionsProvider.h"

@interface AMSectionsProvider ()
@property (nonatomic, strong) NSMutableArray *sectionControllers;
@end

@implementation AMSectionsProvider

- (id)init
{
    self = [super init];
    if (self)
    {
        self.sectionControllers = [NSMutableArray array];
    }
    
    return self;
}

- (void)addSectionControllerForClass:(Class<AMSectionController>)sectionControllerClass
{
    id<AMSectionController> sectionController = [[(id)sectionControllerClass alloc] init];
    [self.sectionControllers addObject:sectionController];
}

- (void)registerCustomElementsForCollectionView:(UICollectionView *)collectionView
{
    for (id<AMSectionController> sectionController in self.sectionControllers)
    {
        [sectionController registerCustomElementsForCollectionView:collectionView];
    }
}

- (id<AMSectionController>)controllerForSection:(NSInteger)section
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"section == %d", section];
    return [[self.sectionControllers filteredArrayUsingPredicate:predicate] firstObject];
}

- (NSUInteger)sectionControllersCount
{
    return self.sectionControllers.count;
}

@end
