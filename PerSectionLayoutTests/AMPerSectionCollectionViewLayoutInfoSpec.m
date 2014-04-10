//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutInfo.h"

@interface AMPerSectionCollectionViewLayoutInfo (AMPerSectionCollectionViewLayoutInfoSpec)
@property (nonatomic, assign, getter = isInvalid) BOOL invalid;
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
                AMPerSectionCollectionViewLayoutSection *object = [layoutInfo addSection];
                [[layoutInfo.layoutInfoSections should] contain:object];
                [[object should] beKindOfClass:[AMPerSectionCollectionViewLayoutSection class]];
            });
            
            it(@"should invalidate the layout info", ^{
                [[layoutInfo should] receive:@selector(invalidate)];
                [layoutInfo addSection];
            });
        });
        
        context(@"sectionAtIndex", ^{
            __block AMPerSectionCollectionViewLayoutSection *section = nil;
            
            beforeEach(^{
                [layoutInfo addSection];
                section = [layoutInfo addSection];
            });
            
            it(@"should return a section for a valid index", ^{
                AMPerSectionCollectionViewLayoutSection *validSection = [layoutInfo sectionAtIndex:1];
                [[validSection should] beNonNil];
                [[validSection should] equal:section];
            });
            
            it(@"should not return a section for an invalid index", ^{
                AMPerSectionCollectionViewLayoutSection *invalidSection = [layoutInfo sectionAtIndex:3];
                [[invalidSection should] beNil];
            });
        });
    });
    
    context(@"firstSectionAtPoint", ^{
        
        __block AMPerSectionCollectionViewLayoutSection *sectionContainedInPoint = nil;
        
        beforeEach(^{
            CGFloat sectionsWidth = 200.f;
            
            AMPerSectionCollectionViewLayoutSection *firstSection = [layoutInfo addSection];
            firstSection.frame = CGRectMake(0.f, 0.f, sectionsWidth, 400.f);
            
            sectionContainedInPoint = [layoutInfo addSection];
            sectionContainedInPoint.frame = CGRectMake(0.f, 400.f, sectionsWidth, 300.f);
            
            AMPerSectionCollectionViewLayoutSection *thirdSection = [layoutInfo addSection];
            thirdSection.frame = CGRectMake(0.f, 700.f, sectionsWidth, 200.f);
        });
        
        it(@"should return a section if point is contained insection section frame", ^{
            AMPerSectionCollectionViewLayoutSection *section = [layoutInfo firstSectionAtPoint:CGPointMake(40.f, 450.f)];
            [[section should] beNonNil];
            [[section should] equal:sectionContainedInPoint];
        });
        
        it(@"should not return a section if point is contained insection section frame", ^{
            AMPerSectionCollectionViewLayoutSection *section = [layoutInfo firstSectionAtPoint:CGPointMake(1040.f, 450.f)];
            [[section should] beNil];
        });
    });
    
    context(@"firstSectionIndexBelowHeader", ^{
        
        __block AMPerSectionCollectionViewLayoutSection *firstSection = nil;
        __block CGFloat sectionsWidth = 0;
        
        beforeEach(^{
            sectionsWidth = 200.f;
            
            layoutInfo.headerFrame = CGRectMake(0.f, 0.f, sectionsWidth, 40.f);
            
            firstSection = [layoutInfo addSection];
            firstSection.frame = CGRectMake(0.f, 40.f, sectionsWidth, 360.f);
            
            AMPerSectionCollectionViewLayoutSection *secondSection = [layoutInfo addSection];
            secondSection.frame = CGRectMake(0.f, 400.f, sectionsWidth, 300.f);
            
            AMPerSectionCollectionViewLayoutSection *thirdSection = [layoutInfo addSection];
            thirdSection.frame = CGRectMake(0.f, 700.f, sectionsWidth, 200.f);
        });
        
        context(@"if there is a section located below header", ^{
            it(@"should return a valid index if a section is localed below global header", ^{
                [[theValue([layoutInfo firstSectionIndexBelowHeaderForYOffset:0]) should] equal:theValue(0)];
            });
        });
        
        context(@"when scrolled till second section is visible", ^{
            it(@"should return a valid index if a section is localed below global header", ^{
                CGFloat yOffset = CGRectGetHeight(layoutInfo.headerFrame) + 400;
                [[theValue([layoutInfo firstSectionIndexBelowHeaderForYOffset:yOffset]) should] equal:theValue(1)];
            });
        });
        
        context(@"if there isn't a section located below header", ^{
            firstSection.frame = CGRectMake(0.f, 100.f, sectionsWidth, 360.f);
            
            it(@"should return the first section index", ^{
                [[theValue([layoutInfo firstSectionIndexBelowHeaderForYOffset:0]) should] equal:theValue(0)];
            });
        });
    });
    
    context(@"stickyHeaderFrameForYOffset", ^{
        beforeEach(^{
            CGFloat sectionsWidth = 200;
            
            layoutInfo.headerFrame = CGRectMake(0.f, 0.f, sectionsWidth, 50.f);
            
            layoutInfo.headerFrame = CGRectMake(0.f, 0.f, sectionsWidth, 40.f);
            
            AMPerSectionCollectionViewLayoutSection *firstSection = [layoutInfo addSection];
            firstSection.frame = CGRectMake(0.f, 40.f, sectionsWidth, 360.f);
            
            AMPerSectionCollectionViewLayoutSection *secondSection = [layoutInfo addSection];
            secondSection.frame = CGRectMake(0.f, 400.f, sectionsWidth, 300.f);
            
            AMPerSectionCollectionViewLayoutSection *thirdSection = [layoutInfo addSection];
            thirdSection.frame = CGRectMake(0.f, 700.f, sectionsWidth, 200.f);
        });
        
        context(@"when has sticky header", ^{
            beforeEach(^{
                layoutInfo.stickyHeader = YES;
            });
            
            it(@"should have the same frame as the original header frame", ^{
                CGFloat yOffset = CGRectGetHeight(layoutInfo.headerFrame) + 400;
                [[theValue([layoutInfo stickyHeaderFrameForYOffset:yOffset]) should] equal:theValue(CGRectMake(0.f, 360.f, 200.f, 40.f))];
            });
        });
        
        context(@"when doesn't have sticky header", ^{
            beforeEach(^{
                layoutInfo.stickyHeader = NO;
            });
            
            it(@"should have the same frame as the original header frame", ^{
                [[theValue([layoutInfo stickyHeaderFrameForYOffset:0]) should] equal:theValue(layoutInfo.headerFrame)];
            });
        });
    });
    
    context(@"items", ^{
        
        __block AMPerSectionCollectionViewLayoutItem *item = nil;
        
        beforeEach(^{
            [layoutInfo addSection];
            [layoutInfo addSection];
            
            AMPerSectionCollectionViewLayoutSection *section = [layoutInfo addSection];
            [section addItem];
            [section addItem];
            [section addItem];
            [section addItem];
            item = [section addItem];
            [section addItem];
            
            [layoutInfo addSection];
            [layoutInfo addSection];
        });
        
        context(@"itemAtIndexPath", ^{
            it(@"should return an item for a valid index path", ^{
                AMPerSectionCollectionViewLayoutItem *validItem = [layoutInfo itemAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:2]];
                [[validItem should] beNonNil];
                [[validItem should] equal:item];
            });
            
            it(@"should not return an item for an invalid index path", ^{
                AMPerSectionCollectionViewLayoutItem *invalidItem = [layoutInfo itemAtIndexPath:[NSIndexPath indexPathForItem:10 inSection:2]];
                [[invalidItem should] beNil];
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
    
    context(@"sticky header", ^{
        context(@"default value", ^{
            it(@"should have not sticky header by default", ^{
                [[theValue(layoutInfo.hasStickyHeader) should] beNo];
            });
        });
        
        context(@"once set", ^{
            __block BOOL hasStickyHeader = NO;
            
            beforeEach(^{
                hasStickyHeader = YES;
                layoutInfo.stickyHeader = hasStickyHeader;
            });
            
            it(@"should remember the last section with a sticky header", ^{
                [[theValue(layoutInfo.hasStickyHeader) should] equal:theValue(hasStickyHeader)];
            });
        });
    });
    
    context(@"last section with a sticky header", ^{
        context(@"default value", ^{
            it(@"should be zero by default", ^{
                [[theValue(layoutInfo.lastSectionWithStickyHeader) should] equal:theValue(0)];
            });
        });
        
        context(@"once set", ^{
            __block NSInteger lastSectionWithStickyHeader = 0;
            
            beforeEach(^{
                lastSectionWithStickyHeader = 4;
                layoutInfo.lastSectionWithStickyHeader = 4;
            });
            
            it(@"should remember the last section with a sticky header", ^{
                [[theValue(layoutInfo.lastSectionWithStickyHeader) should] equal:theValue(lastSectionWithStickyHeader)];
            });
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
