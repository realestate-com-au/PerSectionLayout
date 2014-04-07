//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutSection.h"
#import "AMFakeCollectionViewDelegateDataSource.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMPerSectionCollectionViewLayoutRow.h"

@interface AMPerSectionCollectionViewLayout (AMPerSectionCollectionViewLayoutSectionSpec)
@property (nonatomic, strong) AMPerSectionCollectionViewLayoutInfo *layoutInfo;
@end

@interface AMPerSectionCollectionViewLayoutSection (AMPerSectionCollectionViewLayoutSectionSpec)
@property (nonatomic, assign) BOOL isInvalid;
@end

SPEC_BEGIN(AMPerSectionCollectionViewLayoutSectionSpec)

describe(@"AMPerSectionCollectionViewLayoutSection", ^{
    
    __block AMPerSectionCollectionViewLayoutSection *section = nil;
    
    beforeEach(^{
        section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
    });
    
    context(@"items", ^{
        it(@"should have none by default", ^{
            [[section.layoutSectionItems should] beEmpty];
        });
        
        context(@"addItem", ^{
            it(@"should return an layout item object", ^{
                [[[section addItem] should] beNonNil];
            });
            
            it(@"should add a new layout item the array of items", ^{
                AMPerSectionCollectionViewLayoutItem *object = [section addItem];
                [[section.layoutSectionItems should] contain:object];
                [[object should] beKindOfClass:[AMPerSectionCollectionViewLayoutItem class]];
            });
        });
    });
    
    context(@"rows", ^{
        it(@"should have none by default", ^{
            [[section.layoutSectionRows should] beEmpty];
        });
        
        context(@"addItem", ^{
            it(@"should return an layout item object", ^{
                [[[section addRow] should] beNonNil];
            });
            
            it(@"should add a new layout item the array of items", ^{
                AMPerSectionCollectionViewLayoutRow *object = [section addRow];
                [[section.layoutSectionRows should] contain:object];
                [[object should] beKindOfClass:[AMPerSectionCollectionViewLayoutRow class]];
            });
        });
    });
    
    context(@"description", ^{
        it(@"should have a meaningful desciption", ^{
            NSString *description = [section description];
            [[description should] beNonNil];
        });
    });
    
    context(@"itemsCount", ^{
        beforeEach(^{
            [section addItem];
            [section addItem];
        });
        
        it(@"should be in sync with the number of items", ^{
            [[theValue(section.itemsCount) should] equal:theValue(section.layoutSectionItems.count)];
        });
    });
    
    context(@"verticalInterstice", ^{
        
        __block CGFloat verticalInterstice = 0;
        
        beforeEach(^{
            verticalInterstice = 20.f;
            section.verticalInterstice = verticalInterstice;
        });
        
        it(@"should remember the vertical interstice", ^{
            [[theValue(section.verticalInterstice) should] equal:theValue(verticalInterstice)];
        });
    });
    
    context(@"horizontalInterstice", ^{
        
        __block CGFloat horizontalInterstice = 0;
        
        beforeEach(^{
            horizontalInterstice = 20.f;
            section.horizontalInterstice = horizontalInterstice;
        });
        
        it(@"should remember the vertical interstice", ^{
            [[theValue(section.horizontalInterstice) should] equal:theValue(horizontalInterstice)];
        });
    });
    
    context(@"sectionMargins", ^{
        
        __block UIEdgeInsets sectionMargins = UIEdgeInsetsZero;
        
        beforeEach(^{
            sectionMargins = UIEdgeInsetsMake(10.f, 0.f, 40.f, 50.f);
            section.sectionMargins = sectionMargins;
        });
        
        it(@"should remember the section margins", ^{
            [[theValue(section.sectionMargins) should] equal:theValue(sectionMargins)];
        });
    });
    
    context(@"invalidate", ^{
        it(@"should be valid by default", ^{
            [[theValue(section.isInvalid) should] beFalse];
        });
        
        it(@"should flag the layout info has invalid", ^{
            [section invalidate];
            [[theValue(section.isInvalid) should] beTrue];
        });
    });
    
    context(@"headerFrame", ^{
        __block CGRect headerFrame = CGRectZero;
        
        beforeEach(^{
            headerFrame = CGRectMake(0.f, 10.f, 20.f, 40.f);
            section.headerFrame = headerFrame;
        });
        
        it(@"should remember the header frame", ^{
            [[theValue(section.headerFrame) should] equal:theValue(headerFrame)];
        });
    });
    context(@"footerFrame", ^{
        __block CGRect footerFrame = CGRectZero;
        
        beforeEach(^{
            footerFrame = CGRectMake(0.f, 10.f, 20.f, 40.f);
            section.footerFrame = footerFrame;
        });
        
        it(@"should remember the footer frame", ^{
            [[theValue(section.footerFrame) should] equal:theValue(footerFrame)];
        });
    });
    
    context(@"computeLayout", ^{
        
        __block UICollectionView *collectionView = nil;
        __block AMFakeCollectionViewDelegateDataSource *delegateDataSource = nil;
        __block AMPerSectionCollectionViewLayout *layout;
        __block AMPerSectionCollectionViewLayoutSection *firstSection;
        
        beforeEach(^{
            layout = [[AMPerSectionCollectionViewLayout alloc] init];
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, 250.f, 500.f) collectionViewLayout:layout];
            delegateDataSource = [[AMFakeCollectionViewDelegateDataSource alloc] init];
            
            delegateDataSource.numberOfSections = 1;
            delegateDataSource.numberOfItemsInSection = 10;
            delegateDataSource.itemSize = CGSizeMake(50.f, 50.f);
            delegateDataSource.sectionHeaderReferenceSize = CGSizeMake(27.f, 50.f);
            delegateDataSource.sectionFooterReferenceSize = CGSizeMake(17.f, 70.f);
            delegateDataSource.minimumLineSpacing = 10.f;
            delegateDataSource.minimumInteritemSpacing = 10.f;
            
            collectionView.delegate = delegateDataSource;
            collectionView.dataSource = delegateDataSource;
            [delegateDataSource registerCustomElementsForCollectionView:collectionView];
            
            [layout prepareLayout];
            
            firstSection = layout.layoutInfo.layoutInfoSections[0];
        });
        
        it(@"should have a frame", ^{
            [[theValue(firstSection.frame) should] equal:theValue(CGRectMake(0.f, 0.f, 250.f, 300.f))];
        });
        
        it(@"should have a body frame", ^{
            [[theValue(firstSection.bodyFrame) should] equal:theValue(CGRectMake(0.f, 50.f, 250.f, 180.f))];
        });
        
        it(@"should have a header frame", ^{
            [[theValue(firstSection.headerFrame) should] equal:theValue(CGRectMake(0.f, 0.f, 250.f, 50.f))];
        });
        
        it(@"should have a footer frame", ^{
            [[theValue(firstSection.footerFrame) should] equal:theValue(CGRectMake(0.f, 230.f, 250.f, 70.f))];
        });
    });
});

SPEC_END
