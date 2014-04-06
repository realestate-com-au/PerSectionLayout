//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutSection.h"

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
    
    context(@"description", ^{
        it(@"should have a meaningful desciption", ^{
            NSString *description = [section description];
            [[description should] beNonNil];
        });
    });
    
    context(@"itemsCount", ^{
        beforeEach(^{
             [[[section addItem] should] beNonNil];
             [[[section addItem] should] beNonNil];
        });
        
        it(@"should be in sync with the number of items", ^{
            [[theValue(section.itemsCount) should] equal:theValue(section.layoutSectionItems.count)];
        });
    });
    
    context(@"isHorizontal", ^{
        it(@"should be no by default", ^{
            [[theValue(section.isHorizontal) should] beNo];
        });
        
        it(@"shoulb remember if is set to horizontal", ^{
            section.horizontal = YES;
            [[theValue(section.isHorizontal) should] beYes];
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
    
    context(@"frame", ^{
        context(@"once computed", ^{
            it(@"should have a valid frame", ^{
                [[theValue(section.frame) should] equal:theValue(CGRectZero)];
            });
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
    
    context(@"bodyFrame", ^{
        context(@"once computed", ^{
            it(@"should have a valid body frame", ^{
                [[theValue(section.frame) should] equal:theValue(CGRectZero)];
            });
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
    
    context(@"invalidate", ^{
        it(@"should be valid by default", ^{
            [[theValue(section.isInvalid) should] beFalse];
        });
        
        it(@"should flag the layout info has invalid", ^{
            [section invalidate];
            [[theValue(section.isInvalid) should] beTrue];
        });
    });
    
    context(@"computeLayout", ^{
        // FIXME: nothing for now
    });
});

SPEC_END
