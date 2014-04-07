//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutRow.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMPerSectionCollectionViewLayoutSection.h"

@interface AMPerSectionCollectionViewLayoutRow (AMPerSectionCollectionViewLayoutRowSpec)
@property (nonatomic, assign) BOOL isInvalid;
@end

SPEC_BEGIN(AMPerSectionCollectionViewLayoutRowSpec)

describe(@"AMPerSectionCollectionViewLayoutRow", ^{
    
    __block AMPerSectionCollectionViewLayoutRow *row = nil;
    
    beforeEach(^{
        row = [[AMPerSectionCollectionViewLayoutRow alloc] init];
    });
    
    context(@"items", ^{
        it(@"should have none by default", ^{
            [[row.layoutSectionItems should] beEmpty];
        });
        
        context(@"addItem", ^{
            
            __block AMPerSectionCollectionViewLayoutItem *item = nil;
            
            beforeEach(^{
                item = [[AMPerSectionCollectionViewLayoutItem alloc] init];
                [row addItem:item];
            });
            
            it(@"should add a new layout item the array of items", ^{
                [[row.layoutSectionItems should] contain:item];
            });
        });
    });
    
    context(@"description", ^{
        it(@"should have a meaningful desciption", ^{
            NSString *description = [row description];
            [[description should] beNonNil];
        });
    });
    
    context(@"itemsCount", ^{
        beforeEach(^{
             [row addItem:[[AMPerSectionCollectionViewLayoutItem alloc] init]];
             [row addItem:[[AMPerSectionCollectionViewLayoutItem alloc] init]];
        });
        
        it(@"should be in sync with the number of items", ^{
            [[theValue(row.itemsCount) should] equal:theValue(row.layoutSectionItems.count)];
        });
    });
    
    context(@"frame", ^{
        __block CGRect frame = CGRectZero;
        
        beforeEach(^{
            frame = CGRectMake(10.f, 20.f, 250.f, 150.f);
            row.frame = frame;
        });
        
        it(@"should remember the row frame", ^{
            [[theValue(row.frame) should] equal:theValue(frame)];
        });
    });
    
    context(@"index", ^{
        __block NSInteger index = 0;
        
        beforeEach(^{
            index = 100;
            row.index = index;
        });
        
        it(@"should remember the row index", ^{
            [[theValue(row.index) should] equal:theValue(index)];
        });
    });
    
    context(@"invalidate", ^{
        it(@"should be valid by default", ^{
            [[theValue(row.isInvalid) should] beFalse];
        });
        
        context(@"once invalidated", ^{
            beforeEach(^{
                [row invalidate];
            });
            
            it(@"should flag the layout info has invalid", ^{
                [[theValue(row.isInvalid) should] beTrue];
            });
            
            it(@"should reset the row size", ^{
                [[theValue(row.size) should] equal:theValue(CGSizeZero)];
            });
            
            it(@"shoud rest the frame", ^{
                [[theValue(row.frame) should] equal:theValue(CGRectZero)];
            });
        });
    });
    
    context(@"computeLayout", ^{
        // FIXME: nothing for now
        
        __block AMPerSectionCollectionViewLayoutInfo *layoutInfo = nil;
        __block AMPerSectionCollectionViewLayoutSection *section = nil;
        __block AMPerSectionCollectionViewLayoutItem *item1 = nil;
        __block AMPerSectionCollectionViewLayoutItem *item2 = nil;
        
        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
            layoutInfo.collectionViewSize = CGSizeMake(300.f, 500.f);
            
            section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
            section.sectionMargins = UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f);
            section.horizontalInterstice = 10.f;
            
            item1 = [[AMPerSectionCollectionViewLayoutItem alloc] init];
            item1.frame = CGRectMake(0.f, 0.f, 50.f, 50.f);
            [row addItem:item1];
            
            item2 = [[AMPerSectionCollectionViewLayoutItem alloc] init];
            item2.frame = CGRectMake(0.f, 0.f, 50.f, 50.f);
            [row addItem:item2];
            
            [row computeLayout:layoutInfo inSection:section];
        });
        
        it(@"should compute the row size", ^{
            [[theValue(row.size) should] equal:theValue(CGSizeMake(110.f, 50.f))];
        });
    });
});

SPEC_END
