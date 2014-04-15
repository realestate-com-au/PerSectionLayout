//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutSection.h"
#import "AMPerSectionCollectionViewLayoutAttributes.h"
#import "AMPerSectionCollectionViewLayout.h"
#import "AMPerSectionCollectionViewLayoutItem.h"
#import "AMPerSectionCollectionViewLayoutRow.h"

SPEC_BEGIN(LayoutSectionLayoutAttributesSpecSpec)

describe(@"Layout Section Layout Attributes", ^{

    __block CGPoint cannedOffset;
    __block AMPerSectionCollectionViewLayoutSection *section;

    beforeEach(^{
        cannedOffset = CGPointMake(100, 100);
    });

    context(@"Section Header", ^{
        __block AMPerSectionCollectionViewLayoutAttributes *layoutAttr;

        beforeEach(^{
            section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
            section.index = 4;
            section.headerFrame = CGRectMake(100, 100, 100, 100);
            layoutAttr = (id)[section layoutAttributesForSectionHeaderWithOffset:cannedOffset];
        });

        it(@"should have an adjustment offset", ^{
            [[theValue(layoutAttr.adjustmentOffset) should] equal:theValue(cannedOffset)];
        });

        it(@"should have the right indexPath", ^{
            [[theValue(layoutAttr.indexPath.section) should] equal:theValue(4)];
            [[theValue(layoutAttr.indexPath.item) should] equal:theValue(0)];
        });

        it(@"should represent the right element kind", ^{
            [[layoutAttr.representedElementKind should] equal:AMPerSectionCollectionElementKindSectionHeader];
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
                section.headerFrame = CGRectMake(100, 100, 9001, 0);
                layoutAttr = (id)[section layoutAttributesForSectionHeaderWithOffset:cannedOffset];
            });

            it(@"should not return layout attributes", ^{
                [[layoutAttr should] beNil];
            });
        });

    });

    context(@"section Footer", ^{
        __block AMPerSectionCollectionViewLayoutAttributes *layoutAttr;

        beforeEach(^{
            section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
            section.index = 4;
            section.footerFrame = CGRectMake(100, 100, 100, 100);
            [section stub:@selector(lastItemIndex) andReturn:0];
            layoutAttr = (id)[section layoutAttributesForSectionFooterWithOffset:cannedOffset];
        });

        it(@"should have an adjustment offset", ^{
            [[theValue(layoutAttr.adjustmentOffset) should] equal:theValue(cannedOffset)];
        });

        it(@"should have the right indexPath", ^{
            [[theValue(layoutAttr.indexPath.section) should] equal:theValue(4)];
            [[theValue(layoutAttr.indexPath.item) should] equal:theValue(0)];
        });

        it(@"should represent the right element kind", ^{
            [[layoutAttr.representedElementKind should] equal:AMPerSectionCollectionElementKindSectionFooter];
        });

        context(@"a footer frame height of zero", ^{
            beforeEach(^{
                section.footerFrame = CGRectMake(100, 100, 9001, 0);
                layoutAttr = (id)[section layoutAttributesForSectionFooterWithOffset:cannedOffset];
            });

            it(@"should not return layout attributes", ^{
                [[layoutAttr should] beNil];
            });
        });

    });

    context(@"supplementary views", ^{
        __block NSIndexPath *indexPath;

        beforeEach(^{
            indexPath = [NSIndexPath indexPathForItem:0 inSection:4];
            section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
            section.index = indexPath.section;
            [section stub:@selector(lastItemIndex) andReturn:0];

            section.headerFrame = CGRectMake(0, 0, 100, 100);
            section.footerFrame = CGRectMake(0, 0, 100, 100);
        });

        context(@"asking for a valid supp view", ^{
            it(@"should return for header type", ^{
                id attr = [section layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionHeader withIndexPath:indexPath withOffset:CGPointZero];
                [[attr should] beNonNil];
            });

            it(@"should return for footer type", ^{
                id attr = [section layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionFooter withIndexPath:indexPath withOffset:CGPointZero];
                [[attr should] beNonNil];
            });

            context(@"using invalid index path", ^{
                beforeEach(^{
                    indexPath = [NSIndexPath indexPathForItem:900 inSection:2];
                });

                it(@"should not return for header type", ^{
                    id attr = [section layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionHeader withIndexPath:indexPath withOffset:CGPointZero];
                    [[attr should] beNil];
                });

                it(@"should not return for header type", ^{
                    id attr = [section layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionFooter withIndexPath:indexPath withOffset:CGPointZero];
                    [[attr should] beNil];
                });
            });
        });
    });

    context(@"at index path", ^{
        __block AMPerSectionCollectionViewLayoutAttributes *layoutAttr;

        beforeEach(^{
            section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
            section.stretch = NO;
            section.index = 2;
            section.frame = CGRectMake(100, 100, 200, 1000);

            AMPerSectionCollectionViewLayoutItem *item = [section addItem];
            item.frame = CGRectMake(1, 1, 100, 50);

            AMPerSectionCollectionViewLayoutRow *row = [section addRow];
            [row addItem:item];
            [row computeLayoutInSection:section];

            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section.index];
            layoutAttr = (id)[section layoutAttributesForItemAtIndexPath:indexPath withOffset:cannedOffset];
        });

        it(@"should have an adjustment offset", ^{
            [[theValue(layoutAttr.adjustmentOffset) should] equal:theValue(cannedOffset)];
        });

        it(@"should report the right frame", ^{
            CGRect expectedFrame = CGRectMake(100, 100, 100, 50);
            [[theValue(layoutAttr.frame) should] equal:theValue(expectedFrame)];
        });
    });

    context(@"within a rect", ^{
        __block NSArray *attrs;

        beforeEach(^{
            section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
            section.stretch = NO;
            section.index = 1;
            section.frame = CGRectMake(100, 0, 100, 200);
        });

        context(@"section frame doesn sit within the rect", ^{
            beforeEach(^{
                attrs = [section layoutAttributesArrayForSectionInRect:CGRectMake(0, 0, 100, 200) withOffset:CGPointZero];
            });

            it(@"should return a blank array", ^{
                [[attrs should] beEmpty];
            });
        });

        

        context(@"stretching", ^{

        });

    });

});

SPEC_END
