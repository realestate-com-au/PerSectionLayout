//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutInfo.h"

@interface AMPerSectionCollectionViewLayoutInfo (AMPerSectionCollectionViewLayoutInfoSpec)
@property (nonatomic, assign) BOOL isInvalid;
@end


SPEC_BEGIN(AMPerSectionCollectionViewLayoutInfoSpec)

describe(@"AMPerSectionCollectionViewLayoutInfo", ^{
    
    __block AMPerSectionCollectionViewLayoutInfo *layoutInfo = nil;
    
    beforeEach(^{
        layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
    });
    
    context(@"sections", ^{
        it(@"should have no section by default", ^{
            [[layoutInfo.layoutInfoSections should] beEmpty];
        });
        
        context(@"add section", ^{
            it(@"should return a layout section object", ^{
                [[[layoutInfo addSection] should] beNonNil];
            });
            
            it(@"should add a new layout section the array of sections", ^{
                id object = [layoutInfo addSection];
                [[layoutInfo.layoutInfoSections should] contain:object];
            });
            
            it(@"should invalidate the layout info", ^{
                [[layoutInfo should] receive:@selector(invalidate)];
                [layoutInfo addSection];
            });
        });
    });
    
    context(@"description", ^{
        it(@"should have a meaningful desciption", ^{
            NSString *description = [layoutInfo description];
            [[description should] beNonNil];
        });
    });
    
    context(@"header frame", ^{
        __block CGRect headerFrame = CGRectZero;
        
        beforeEach(^{
            headerFrame = CGRectMake(0.f, 10.f, 20.f, 40.f);
            layoutInfo.headerFrame = headerFrame;
        });
        
        it(@"should remember the header frame", ^{
            [[theValue(layoutInfo.headerFrame) should] equal:theValue(headerFrame)];
        });
    });
    
    context(@"footer frame", ^{
        __block CGRect footerFrame = CGRectZero;
        
        beforeEach(^{
            footerFrame = CGRectMake(0.f, 10.f, 20.f, 40.f);
            layoutInfo.footerFrame = footerFrame;
        });
        
        it(@"should remember the footer frame", ^{
            [[theValue(layoutInfo.footerFrame) should] equal:theValue(footerFrame)];
        });
    });
    
    context(@"invalidate", ^{
        it(@"should be valid by default", ^{
            [[theValue(layoutInfo.isInvalid) should] beFalse];
        });
        
        it(@"should flag the layout info has invalid", ^{
            [layoutInfo invalidate];
            [[theValue(layoutInfo.isInvalid) should] beTrue];
        });
    });
    
    context(@"content size", ^{
        __block CGSize contentSize = CGSizeZero;
        
        beforeEach(^{
            contentSize = CGSizeMake(70.f, 80.f);
            layoutInfo.contentSize = contentSize;
        });
        
        it(@"should remember the layout content size", ^{
            [[theValue(layoutInfo.contentSize) should] equal:theValue(contentSize)];
        });
    });
    
    context(@"collection view size", ^{
        __block CGSize collectionViewSize = CGSizeZero;
        
        beforeEach(^{
            collectionViewSize = CGSizeMake(70.f, 80.f);
            layoutInfo.collectionViewSize = collectionViewSize;
        });
        
        it(@"should remember the layout collection view size", ^{
            [[theValue(layoutInfo.collectionViewSize) should] equal:theValue(collectionViewSize)];
        });
    });
});

SPEC_END
