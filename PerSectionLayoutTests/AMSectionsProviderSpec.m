//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMSectionsProvider.h"
#import "AMFakeSectionController.h"

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
            [AMFakeSectionController stub:@selector(fakeSection) andReturn:theValue(0)];
            [provider addSectionControllerForClass:[AMFakeSectionController class]];
            
            [AMFakeSectionController stub:@selector(fakeSection) andReturn:theValue(1)];
            [provider addSectionControllerForClass:[AMFakeSectionController class]];
        });
        
        it(@"should have added one section controller", ^{
            [[theValue(provider.sectionControllersCount) should] equal:theValue(2)];
        });
    });
    
    context(@"controllerForSection", ^{
        beforeEach(^{
            [AMFakeSectionController stub:@selector(fakeSection) andReturn:theValue(0)];
            [provider addSectionControllerForClass:[AMFakeSectionController class]];
            
            [AMFakeSectionController stub:@selector(fakeSection) andReturn:theValue(1)];
            [provider addSectionControllerForClass:[AMFakeSectionController class]];
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
            [AMFakeSectionController stub:@selector(fakeSection) andReturn:theValue(0)];
            [provider addSectionControllerForClass:[AMFakeSectionController class]];
            
            [AMFakeSectionController stub:@selector(fakeSection) andReturn:theValue(1)];
            [provider addSectionControllerForClass:[AMFakeSectionController class]];
            
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
