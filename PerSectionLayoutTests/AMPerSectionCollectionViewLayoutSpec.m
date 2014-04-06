//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayout.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"

@interface AMPerSectionCollectionViewLayout ()
@property (nonatomic, strong) AMPerSectionCollectionViewLayoutInfo *layoutInfo;
@end

SPEC_BEGIN(AMPerSectionCollectionViewLayoutSpec)

describe(@"AMPerSectionCollectionViewLayout", ^{
    __block AMPerSectionCollectionViewLayout *layout;
    
    beforeEach(^{
        layout = [[AMPerSectionCollectionViewLayout alloc] init];
    });
    
    context(@"initialization", ^{
        it(@"should have no layout info", ^{
            [[layout.layoutInfo should] beNil];
        });
    });
    
    context(@"prepareLayout", ^{
        
        __block UICollectionView *collectionView = nil;
        
        beforeEach(^{
            collectionView = [UICollectionView nullMock];
            [collectionView stub:@selector(frame) andReturn:theValue(CGRectMake(0.f, 0.f, 70.f, 130.f))];
            
            [layout stub:@selector(collectionView) andReturn:collectionView];
            [layout prepareLayout];
        });
        
        context(@"layout info", ^{
            it(@"should have one", ^{
                [[layout.layoutInfo should] beNonNil];
            });
            
            it(@"should be given the collection view size", ^{
                [[theValue(layout.layoutInfo.collectionViewSize) should] equal:theValue(collectionView.frame.size)];
            });
        });
    });
    
    context(@"invalidateLayout", ^{
        beforeEach(^{
            [layout prepareLayout];
        });
        
        it(@"should invalidate it's layout info", ^{
            [[layout.layoutInfo should] receive:@selector(invalidate)];
            [layout invalidateLayout];
        });
    });
    
    context(@"layout methods to override", ^{
        context(@"collectionViewContentSize", ^{
            beforeEach(^{
                [layout prepareLayout];
                layout.layoutInfo.contentSize = CGSizeMake(20.f, 50.f);
            });
            
            it(@"should ask the layout info for the collection view content size", ^{
                [[theValue(layout.collectionViewContentSize) should] equal:theValue(layout.layoutInfo.contentSize)];
            });
        });
        
        context(@"layoutAttributesForElementsInRect", ^{
            it(@"should return nothing", ^{
                [[[layout layoutAttributesForElementsInRect:CGRectMake(0.f, 0.f, 40.f, 50.f)] should] beNil];
            });
        });
        
        context(@"layoutAttributesForItemAtIndexPath", ^{
            it(@"should return nothing", ^{
                [[[layout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]] should] beNil];
            });
        });
        
        context(@"layoutAttributesForSupplementaryViewOfKind", ^{
            it(@"should return nothing", ^{
                [[[layout layoutAttributesForSupplementaryViewOfKind:@"test" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]] should] beNil];
            });
        });
        
        context(@"layoutAttributesForDecorationViewOfKind", ^{
            it(@"should return nothing", ^{
                [[[layout layoutAttributesForDecorationViewOfKind:@"test" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]] should] beNil];
            });
        });
        
        context(@"shouldInvalidateLayoutForBoundsChange", ^{
            it(@"should not invalide layout for bounds change", ^{
                [[theValue([layout shouldInvalidateLayoutForBoundsChange:CGRectMake(0.f, 0.f, 40.f, 50.f)]) should] beFalse];
            });
            
            // FIXME: what if bounds width / height differ ?
        });
    });
});

SPEC_END
