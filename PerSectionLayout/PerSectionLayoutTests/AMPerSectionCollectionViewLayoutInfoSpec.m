//
//  Copyright 2014 REA Group. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutInfo.h"

SPEC_BEGIN(AMPerSectionCollectionViewLayoutInfoSpec)

describe(@"AMPerSectionCollectionViewLayoutInfo", ^{
    
    __block AMPerSectionCollectionViewLayoutInfo *layoutInfo;
    __block AMPerSectionCollectionViewLayoutSection *section;

    context(@"initial state", ^{
        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
        });

        it(@"should be marked as invalid", ^{
            [[theValue(layoutInfo.isValid) should] beNo];
        });
    });

    context(@"adding a section", ^{
        __block id secondSection;

        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
            section = [layoutInfo addSection];
            secondSection = [layoutInfo addSection];
        });

        it(@"added section should be of a layoutSection", ^{
            [[section should] beKindOfClass:[AMPerSectionCollectionViewLayoutSection class]];
        });

        it(@"the section object should be present in the array of sections", ^{
            [[layoutInfo.layoutInfoSections should] contain:section];
        });

        it(@"should leave the layout info invalidated", ^{
            [[theValue(layoutInfo.isValid) should] beNo];
        });

        it(@"should be given an index value", ^{
            [[theValue([section index]) should] equal:theValue(0)];
            [[theValue([secondSection index]) should] equal:theValue(1)];
        });

    });

    context(@"invalidation", ^{
        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
            layoutInfo.valid = YES;
            [layoutInfo invalidate];
        });

        it(@"should flag the layout info as invalid", ^{
            [[theValue(layoutInfo.isValid) should] beNo];
        });
    });

    context(@"sectionAtIndex", ^{
        __block AMPerSectionCollectionViewLayoutSection *section2;

        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
            section = [layoutInfo addSection];
            section2 = [layoutInfo addSection];
        });

        it(@"should return the appopriate secion at a valid index", ^{
            [[[layoutInfo sectionAtIndex:0] should] beIdenticalTo:section];
            [[[layoutInfo sectionAtIndex:1] should] beIdenticalTo:section2];
        });

        it(@"should not return a section for an invalid index", ^{
            id invalidSectionIndex = [layoutInfo sectionAtIndex:3];
            [[invalidSectionIndex should] beNil];
        });
    });
    
    context(@"lastSectionIndex", ^{
        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
        });
        
        context(@"with no section", ^{
            it(@"should be zero", ^{
                [[theValue([layoutInfo lastSectionIndex]) should] equal:theValue(0)];
            });
        });
        
        
        context(@"with 3 sections", ^{
            beforeEach(^{
                [layoutInfo addSection];
                [layoutInfo addSection];
                [layoutInfo addSection];
            });
            
            it(@"should return the last section index", ^{
                [[theValue([layoutInfo lastSectionIndex]) should] equal:theValue(2)];
            });
        });
    });

    context(@"firstSectionAtPoint", ^{
        __block AMPerSectionCollectionViewLayoutSection *section2;

        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
            layoutInfo.valid = YES;

            section = [layoutInfo addSection];
            section.frame = CGRectMake(0, 10, 100, 100);

            section2 = [layoutInfo addSection];
            section2.frame = CGRectMake(0, 100, 100, 100);

            AMPerSectionCollectionViewLayoutSection *thirdSection = [layoutInfo addSection];
            thirdSection.frame = CGRectMake(0, 200, 100, 100);
        });
        
        it(@"should return a section if point is contained in section's frame", ^{
            [[[layoutInfo firstSectionAtPoint:CGPointMake(50, 50)] should] beIdenticalTo:section];
            [[[layoutInfo firstSectionAtPoint:CGPointMake(50, 150)] should] beIdenticalTo:section2];
        });
        
        it(@"should not return a section if point is contained insection section frame", ^{
            [[[layoutInfo firstSectionAtPoint:CGPointMake(50, 350)] should] beNil];
        });
    });
    
    context(@"firstSectionIndexBelowHeader", ^{
        __block AMPerSectionCollectionViewLayoutSection *firstSection;
        
        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
            layoutInfo.headerFrame = CGRectMake(0, 0, 200, 40);
            
            section = [layoutInfo addSection];
            section.frame = CGRectMake(0, 40, 200, 360);
            
            AMPerSectionCollectionViewLayoutSection *secondSection = [layoutInfo addSection];
            secondSection.frame = CGRectMake(0, 400, 200, 300);
            
            AMPerSectionCollectionViewLayoutSection *thirdSection = [layoutInfo addSection];
            thirdSection.frame = CGRectMake(0, 700, 200, 200);
        });
        
        context(@"when there is a section located below the header", ^{
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
            beforeEach(^{
                firstSection.frame = CGRectMake(0, 100, 200, 360);
            });

            it(@"should return the first section index", ^{
                [[theValue([layoutInfo firstSectionIndexBelowHeaderForYOffset:0]) should] equal:theValue(0)];
            });
        });
    });

    context(@"items at index path", ^{
        __block AMPerSectionCollectionViewLayoutItem *addedItem;

        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
            [layoutInfo addSection]; //section 0
            [layoutInfo addSection]; //section 1
            AMPerSectionCollectionViewLayoutSection *thirdSection = [layoutInfo addSection];
            [thirdSection addItem]; //item 0
            [thirdSection addItem]; //item 1
            [thirdSection addItem]; //item 2
            [thirdSection addItem]; //item 3
            addedItem = [thirdSection addItem]; // item 4

            [layoutInfo addSection]; // section 3
            [layoutInfo addSection]; // section 4
        });

        it(@"should return valid items at index paths", ^{
            NSIndexPath *index = [NSIndexPath indexPathForItem:4 inSection:2];
            [[[layoutInfo itemAtIndexPath:index] should] beIdenticalTo:addedItem];
        });

        it(@"should return nil for invlaid index paths", ^{
            NSIndexPath *index = [NSIndexPath indexPathForItem:2 inSection:3];
            [[[layoutInfo itemAtIndexPath:index] should] beNil];
        });
    });

    context(@"stickyHeaderFrameForYOffset", ^{
        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
            layoutInfo.headerFrame = CGRectMake(0, 0, 200, 50);
            
            layoutInfo.headerFrame = CGRectMake(0, 0, 200, 40);
            
            AMPerSectionCollectionViewLayoutSection *firstSection = [layoutInfo addSection];
            firstSection.frame = CGRectMake(0, 40, 200, 360);
            
            AMPerSectionCollectionViewLayoutSection *secondSection = [layoutInfo addSection];
            secondSection.frame = CGRectMake(0, 400, 200, 300);
            
            AMPerSectionCollectionViewLayoutSection *thirdSection = [layoutInfo addSection];
            thirdSection.frame = CGRectMake(0, 700, 200, 200);
        });
        
        context(@"when has sticky header", ^{
            beforeEach(^{
                layoutInfo.stickyHeader = YES;
            });
            
            it(@"should have the same frame as the original header frame", ^{
                CGFloat yOffset = CGRectGetHeight(layoutInfo.headerFrame) + 400;
                [[theValue([layoutInfo stickyHeaderFrameForYOffset:yOffset]) should] equal:theValue(CGRectMake(0, 360, 200, 40))];
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
});

SPEC_END
