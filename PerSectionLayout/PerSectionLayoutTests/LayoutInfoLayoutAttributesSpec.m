//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMPerSectionCollectionViewLayoutAttributes.h"
#import "AMPerSectionCollectionViewLayout.h"

SPEC_BEGIN(LayoutInfoLayoutAttributesSpec)

describe(@"LayoutItemAttributes", ^{

    __block CGPoint cannedOffset;
    __block AMPerSectionCollectionViewLayoutInfo *layoutInfo;

    beforeEach(^{
        cannedOffset = CGPointMake(100, 100);
    });

    context(@"global header layout attributes", ^{
        __block AMPerSectionCollectionViewLayoutAttributes *layoutAttr;

        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
            layoutInfo.headerFrame = CGRectMake(100, 100, 100, 100);
            layoutAttr = (id)[layoutInfo layoutAttributesForGlobalHeaderWithOffset:cannedOffset];
        });

        it(@"should have an adjustment offset", ^{
            [[theValue(layoutAttr.adjustmentOffset) should] equal:theValue(cannedOffset)];
        });

        it(@"should have the right zIndex", ^{
            [[theValue(layoutAttr.zIndex) should] equal:theValue(AMPerSectionCollectionElementAlwaysShowOnTopZIndex)];
        });

        it(@"should have the right indexPath", ^{
            [[theValue(layoutAttr.indexPath.section) should] equal:theValue(0)];
            [[theValue(layoutAttr.indexPath.row) should] equal:theValue(0)];
        });

        it(@"should represent the right element kind", ^{
            [[layoutAttr.representedElementKind should] equal:AMPerSectionCollectionElementKindHeader];
        });

        it(@"should maintain the size of the header", ^{
            CGSize headerSize = layoutAttr.frame.size;
            [[theValue(headerSize) should] equal:theValue(CGSizeMake(100, 100))];
        });

        //NB: The header frame is calcaulted initially
        it(@"should maintain the origin of the header frame", ^{
            CGPoint headerOrigin = layoutAttr.frame.origin;
            [[theValue(headerOrigin) should] equal:theValue(CGPointMake(100, 100))];
        });

        context(@"a header frame height of zero", ^{
            beforeEach(^{
                layoutInfo.headerFrame = CGRectMake(100, 100, 9001, 0);
                layoutAttr = (id)[layoutInfo layoutAttributesForGlobalHeaderWithOffset:cannedOffset];
            });

            it(@"should not return layout attributes", ^{
                [[layoutAttr should] beNil];
            });
        });

        context(@"with a sicky header", ^{
            beforeEach(^{
                layoutInfo.stickyHeader = YES;
                layoutAttr = (id)[layoutInfo layoutAttributesForGlobalHeaderWithOffset:cannedOffset];
            });

            //NB: The header frame is calcaulted initially.
            // Sticky header and the other methods called are tested on their own.
            xit(@"should alter the origin of the header frame", ^{
//                CGPoint headerOrigin = layoutAttr.frame.origin;
//                [[theValue(headerOrigin) should] equal:theValue(CGPointMake(100, 100))];
            });
        });

    });

    context(@"global footer layout attributes", ^{
        __block AMPerSectionCollectionViewLayoutAttributes *layoutAttr;

        beforeEach(^{
            layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
            layoutInfo.footerFrame = CGRectMake(100, 100, 100, 100);
            layoutAttr = (id)[layoutInfo layoutAttributesForGlobalFooterWithOffset:cannedOffset];
        });

        it(@"should have an adjustment offset", ^{
            [[theValue(layoutAttr.adjustmentOffset) should] equal:theValue(cannedOffset)];
        });

        it(@"should have the right indexPath", ^{
            [[theValue(layoutAttr.indexPath.section) should] equal:theValue(0)];
            [[theValue(layoutAttr.indexPath.row) should] equal:theValue(0)];
        });

        it(@"should represent the right element kind", ^{
            [[layoutAttr.representedElementKind should] equal:AMPerSectionCollectionElementKindFooter];
        });

        context(@"a footer frame height of zero", ^{
            beforeEach(^{
                layoutInfo.footerFrame = CGRectMake(100, 100, 9001, 0);
                layoutAttr = (id)[layoutInfo layoutAttributesForGlobalFooterWithOffset:cannedOffset];
            });

            it(@"should not return layout attributes", ^{
                [[layoutAttr should] beNil];
            });
        });

    });

});

SPEC_END
