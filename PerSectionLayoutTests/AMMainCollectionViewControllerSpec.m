//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMMainCollectionViewController.h"
#import "AMSectionsProvider.h"
#import "AMListSectionController.h"

@interface AMMainCollectionViewController (AMMainCollectionViewControllerSpec)
@property (nonatomic, strong) AMSectionsProvider *sectionsProvider;
@end


SPEC_BEGIN(AMMainCollectionViewControllerSpec)

describe(@"AMMainCollectionViewController", ^{
    
    __block AMMainCollectionViewController *controller = nil;
    __block AMListSectionController *sectionController = nil;
    
    beforeEach(^{
        UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        controller = (AMMainCollectionViewController *)[navigationController topViewController];
        
        sectionController = (AMListSectionController *)[controller.sectionsProvider controllerForSection:0];
    });
    
    context(@"initialization", ^{
        it(@"should have a section providerd", ^{
            [[controller.sectionsProvider should] beNonNil];
        });
    });
    
    context(@"view load", ^{
        it(@"should ask the section provider to regiser the custom collection view elements", ^{
            [[controller.sectionsProvider should] receive:@selector(registerCustomElementsForCollectionView:)];
            [controller view];
        });
    });
    
    context(@"collection view data source", ^{
        beforeEach(^{
            [controller view];
        });
        
        it(@"should proxy the number of sections to the sections provider", ^{
            NSInteger sections = [controller numberOfSectionsInCollectionView:controller.collectionView];
            [[theValue(sections) should] equal:theValue([controller.sectionsProvider sectionControllersCount])];
        });
        
        it(@"should ask the section controller for the number of items in section", ^{
            NSInteger items = [controller collectionView:controller.collectionView numberOfItemsInSection:0];
            [[theValue(items) should] equal:theValue(10)];
        });
        
        it(@"should ask the section controller for a cell", ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            UICollectionViewCell *cell = [controller collectionView:controller.collectionView cellForItemAtIndexPath:indexPath];
            [[cell should] beNonNil];
        });
    });
});

SPEC_END
