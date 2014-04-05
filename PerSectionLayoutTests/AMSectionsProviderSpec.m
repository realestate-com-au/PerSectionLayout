//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMSectionsProvider.h"

@interface FakeSectionController : NSObject <AMSectionController>
@end

@implementation FakeSectionController

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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

@end

SPEC_BEGIN(AMSectionsProviderSpec)

describe(@"AMSectionsProvider", ^{
    
    __block AMSectionsProvider *provider = nil;
    
    beforeEach(^{
        provider = [[AMSectionsProvider alloc] init];
    });
    
    context(@"initialization", ^{
        it(@"should have no section controllers", ^{
            [[theValue(provider.sectionControllersCount) should] equal:theValue(0)];
        });
    });
    
    context(@"once 2 sections are added to the provider", ^{
        beforeEach(^{
            [FakeSectionController stub:@selector(fakeSection) andReturn:theValue(0)];
            [provider addSectionControllerForClass:[FakeSectionController class]];
            
            [FakeSectionController stub:@selector(fakeSection) andReturn:theValue(1)];
            [provider addSectionControllerForClass:[FakeSectionController class]];
        });
        
        it(@"should have added one section controller", ^{
            [[theValue(provider.sectionControllersCount) should] equal:theValue(2)];
        });
    });
    
    context(@"controllerForSection", ^{
        beforeEach(^{
            [FakeSectionController stub:@selector(fakeSection) andReturn:theValue(0)];
            [provider addSectionControllerForClass:[FakeSectionController class]];
            
            [FakeSectionController stub:@selector(fakeSection) andReturn:theValue(1)];
            [provider addSectionControllerForClass:[FakeSectionController class]];
        });
        
        it(@"should return a section controller if a valid section is given", ^{
            id<AMSectionController> sectionController = [provider controllerForSection:1];
            [[(NSObject *)sectionController should] beNonNil];
            [[theValue([sectionController section]) should] equal:theValue(1)];
        });
        
        it(@"should not return a section controller is the given section is invalid", ^{
            [[(NSObject *)[provider controllerForSection:250] should] beNil];
        });
    });
    
    context(@"registerCustomElementsForCollectionView", ^{
        
        __block UICollectionView *collectionView;
        
        beforeEach(^{
            [FakeSectionController stub:@selector(fakeSection) andReturn:theValue(0)];
            [provider addSectionControllerForClass:[FakeSectionController class]];
            
            [FakeSectionController stub:@selector(fakeSection) andReturn:theValue(1)];
            [provider addSectionControllerForClass:[FakeSectionController class]];
            
            collectionView = [UICollectionView nullMock];
        });
        
        it(@"should proxy message to all section controllers", ^{
            id<AMSectionController> sectionController = [provider controllerForSection:1];
            [[(NSObject *)sectionController should] receive:@selector(registerCustomElementsForCollectionView:) andReturn:nil withArguments:collectionView];
            
            id<AMSectionController> sectionController1 = [provider controllerForSection:1];
            [[(NSObject *)sectionController1 should] receive:@selector(registerCustomElementsForCollectionView:) andReturn:nil withArguments:collectionView];
            
            [provider registerCustomElementsForCollectionView:collectionView];
        });
    });
});

SPEC_END
