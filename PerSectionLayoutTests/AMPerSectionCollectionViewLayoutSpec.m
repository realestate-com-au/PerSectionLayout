//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayout.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMFakeCollectionViewDelegateDataSource.h"
#import "math.h"
#import "AMPerSectionCollectionViewLayoutInvalidationContext.h"

@interface AMPerSectionCollectionViewLayout ()

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)sizeForHeader;
- (CGSize)sizeForFooter;
- (CGSize)sizeForHeaderInSection:(NSInteger)section;
- (CGSize)sizeForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)miniumWidthForSectionAtIndex:(NSInteger)section;
- (BOOL)hasStickyHeaderOverSection:(NSInteger)section;
- (void)getSizingInfos:(id)arg;
- (void)updateItemsLayout:(id)arg;
- (BOOL)layoutInfoFrame:(CGRect)layoutInfoFrame requiresLayoutAttritbutesForRect:(CGRect)rect;
- (CGFloat)adjustedCollectionViewContentOffset;

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
        
        it(@"should have a default item size", ^{
            [[theValue(layout.itemSize) should] equal:theValue(CGSizeMake(50.f, 50.f))];
        });
        
        it(@"should have no header reference size", ^{
            [[theValue(layout.headerReferenceSize) should] equal:theValue(CGSizeZero)];
        });
        
        it(@"should have no footer reference size", ^{
            [[theValue(layout.footerReferenceSize) should] equal:theValue(CGSizeZero)];
        });
        
        it(@"should have no section header reference size", ^{
            [[theValue(layout.sectionHeaderReferenceSize) should] equal:theValue(CGSizeZero)];
        });
        
        it(@"should have no section inset", ^{
            [[theValue(layout.sectionInset) should] equal:theValue(UIEdgeInsetsZero)];
        });
        
        it(@"should have a default minimum line spacing", ^{
            [[theValue(layout.minimumLineSpacing) should] equal:theValue(5.f)];
        });
        
        it(@"should have a default minimum inter item spacing", ^{
            [[theValue(layout.minimumInteritemSpacing) should] equal:theValue(5.f)];
        });
        
        it(@"should have a default section minimum with", ^{
            [[theValue(layout.sectionMinimumWidth) should] equal:theValue(NAN)];
        });
        
        it(@"should have by default non stick header", ^{
            [[theValue(layout.hasStickyHeader) should] equal:theValue(NO)];
        });
    });
    
    context(@"layout invalidation", ^{
        context(@"invalidationContextClass", ^{
            it(@"should be a custom class", ^{
                [[[AMPerSectionCollectionViewLayout invalidationContextClass] should] equal:[AMPerSectionCollectionViewLayoutInvalidationContext class]];
            });
        });
        
        context(@"invalidationContextForBoundsChange", ^{
            it(@"should set invalidateHeader to YES", ^{
                AMPerSectionCollectionViewLayoutInvalidationContext *context = (AMPerSectionCollectionViewLayoutInvalidationContext *)[layout invalidationContextForBoundsChange:CGRectMake(0.f, 0.f, 200.f, 50.f)];
                [[theValue(context.invalidateHeader) should] beTrue];
            });
        });
        
        context(@"invalidateLayoutWithContext", ^{
            
            __block AMPerSectionCollectionViewLayoutInvalidationContext *invalidationContext = nil;
            
            beforeEach(^{
                invalidationContext = [[AMPerSectionCollectionViewLayoutInvalidationContext alloc] init];
                layout.layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
            });
            
            context(@"invalidateHeader is Yes", ^{
                beforeEach(^{
                    invalidationContext.invalidateHeader = YES;
                    [layout invalidateLayoutWithContext:invalidationContext];
                });
                
                it(@"should keep layout info", ^{
                    [[layout.layoutInfo should] beNonNil];
                });
            });
            
            context(@"invalidateHeader is No", ^{
                beforeEach(^{
                    invalidationContext.invalidateHeader = NO;
                    [layout invalidateLayoutWithContext:invalidationContext];
                });
                
                it(@"should nil layout info", ^{
                    [[layout.layoutInfo should] beNil];
                });
            });
        });
    });
    
    context(@"AMPerSectionCollectionViewLayoutDelegate", ^{
        
        __block UICollectionView *collectionView = nil;
        
        beforeEach(^{
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 250.f) collectionViewLayout:layout];
        });
        
        context(@"with a delegate that doesn't implement any of the optional methods", ^{
            
            __block id delegate = nil;
            
            beforeEach(^{
                delegate = [[NSObject alloc] init];
                
                layout.itemSize = CGSizeMake(70.f, 80.f);
                layout.headerReferenceSize = CGSizeMake(27.f, 48.f);
                layout.footerReferenceSize = CGSizeMake(17.f, 58.f);
                layout.sectionHeaderReferenceSize = CGSizeMake(227.f, 148.f);
                layout.sectionFooterReferenceSize = CGSizeMake(127.f, 458.f);
                layout.sectionInset =  UIEdgeInsetsMake(10.f, 25.f, 20.f, 5.f);
                layout.sectionMinimumWidth = 400.f;
                layout.minimumLineSpacing = 8.f;
                layout.minimumInteritemSpacing = 10.f;
                
                collectionView.delegate = delegate;
            });
            
            it(@"sizeForItemAtIndexPath", ^{
                [[theValue([layout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]) should] equal:theValue(layout.itemSize)];
            });
            
            it(@"sizeForHeader", ^{
                [[theValue([layout sizeForHeader]) should] equal:theValue(layout.headerReferenceSize)];
            });
            
            it(@"sizeForFooter", ^{
                [[theValue([layout sizeForFooter]) should] equal:theValue(layout.footerReferenceSize)];
            });
            
            it(@"sizeForHeaderInSection", ^{
                [[theValue([layout sizeForHeaderInSection:0]) should] equal:theValue(layout.sectionHeaderReferenceSize)];
            });
            
            it(@"sizeForFooterInSection", ^{
                [[theValue([layout sizeForFooterInSection:0]) should] equal:theValue(layout.sectionFooterReferenceSize)];
            });
            
            it(@"insetForSectionAtIndex", ^{
                [[theValue([layout insetForSectionAtIndex:0]) should] equal:theValue(layout.sectionInset)];
            });
            
            it(@"miniumWidthForSectionAtIndex", ^{
                [[theValue([layout miniumWidthForSectionAtIndex:0]) should] equal:theValue(layout.sectionMinimumWidth)];
            });
            
            it(@"minimumLineSpacingForSectionAtIndex", ^{
                [[theValue([layout minimumLineSpacingForSectionAtIndex:0]) should] equal:theValue(layout.minimumLineSpacing)];
            });
            
            it(@"minimumInteritemSpacing", ^{
                [[theValue([layout minimumInteritemSpacingForSectionAtIndex:0]) should] equal:theValue(layout.minimumInteritemSpacing)];
            });
            
            it(@"hasStickyHeaderOverSection", ^{
                [[theValue([layout hasStickyHeaderOverSection:0]) should] equal:theValue(layout.hasStickyHeader)];
            });
            
            it(@"isSectionStickyAtIndex", ^{
                [[theValue([layout hasStickyHeaderOverSection:0]) should] beFalse];
            });
        });
        
        context(@"with a delegate that doesn't implement any of the optional methods", ^{
            
            __block AMFakeCollectionViewDelegateDataSource *delegateDataSource = nil;
            
            beforeEach(^{
                delegateDataSource = [[AMFakeCollectionViewDelegateDataSource alloc] init];
                
                delegateDataSource.itemSize = CGSizeMake(70.f, 80.f);
                delegateDataSource.headerReferenceSize = CGSizeMake(27.f, 48.f);
                delegateDataSource.footerReferenceSize = CGSizeMake(17.f, 58.f);
                delegateDataSource.sectionHeaderReferenceSize = CGSizeMake(227.f, 148.f);
                delegateDataSource.sectionFooterReferenceSize = CGSizeMake(127.f, 458.f);
                delegateDataSource.sectionInset =  UIEdgeInsetsMake(10.f, 25.f, 20.f, 5.f);
                delegateDataSource.minimumLineSpacing = 8.f;
                delegateDataSource.minimumInteritemSpacing = 10.f;
                
                collectionView.delegate = delegateDataSource;
                collectionView.dataSource = delegateDataSource;
                [delegateDataSource registerCustomElementsForCollectionView:collectionView];
            });
            
            it(@"sizeForItemAtIndexPath", ^{
                [[theValue([layout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]) should] equal:theValue(delegateDataSource.itemSize)];
            });
            
            it(@"sizeForHeader", ^{
                [[theValue([layout sizeForHeader]) should] equal:theValue(delegateDataSource.headerReferenceSize)];
            });
            
            it(@"sizeForFooter", ^{
                [[theValue([layout sizeForFooter]) should] equal:theValue(delegateDataSource.footerReferenceSize)];
            });
            
            it(@"sizeForHeaderInSection", ^{
                [[theValue([layout sizeForHeaderInSection:0]) should] equal:theValue(delegateDataSource.sectionHeaderReferenceSize)];
            });
            
            it(@"sizeForFooterInSection", ^{
                [[theValue([layout sizeForFooterInSection:0]) should] equal:theValue(delegateDataSource.sectionFooterReferenceSize)];
            });
            
            it(@"insetForSectionAtIndex", ^{
                [[theValue([layout insetForSectionAtIndex:0]) should] equal:theValue(delegateDataSource.sectionInset)];
            });
            it(@"miniumWidthForSectionAtIndex", ^{
                [[theValue([layout miniumWidthForSectionAtIndex:0]) should] equal:theValue(delegateDataSource.sectionMinimumWidth)];
            });
            
            it(@"minimumLineSpacingForSectionAtIndex", ^{
                [[theValue([layout minimumLineSpacingForSectionAtIndex:0]) should] equal:theValue(delegateDataSource.minimumLineSpacing)];
            });
            
            it(@"minimumInteritemSpacing", ^{
                [[theValue([layout minimumInteritemSpacingForSectionAtIndex:0]) should] equal:theValue(delegateDataSource.minimumInteritemSpacing)];
            });
            
            it(@"hasStickyHeaderOverSection", ^{
                [[theValue([layout hasStickyHeaderOverSection:0]) should] equal:theValue(delegateDataSource.hasStickyHeader)];
            });
            
            it(@"isSectionStickyAtIndex", ^{
                [[theValue([layout hasStickyHeaderOverSection:0]) should] equal:theValue(delegateDataSource.hasStickyHeaderOverSection)];
            });
        });
    });
    
    xit(@"prepareLayout", ^{

        //FIXME: This test should be reworked after the invalidaiton work is done

        __block UICollectionView *collectionView = nil;
        
        beforeEach(^{
            collectionView = [UICollectionView nullMock];
            [collectionView stub:@selector(bounds) andReturn:theValue(CGRectMake(0.f, 0.f, 70.f, 130.f))];
            
            [layout stub:@selector(collectionView) andReturn:collectionView];
            [layout prepareLayout];
        });
        
        it(@"should set the layoutInfo property if it doesn't have one", ^{
        });

        it(@"should be given the collection view size", ^{
            [[theValue(layout.layoutInfo.collectionViewSize) should] equal:theValue(collectionView.bounds.size)];
        });
    });
    
    context(@"adjustedCollectionViewContentOffset", ^{
        __block UICollectionView *collectionView = nil;
        
        beforeEach(^{
            collectionView = [UICollectionView nullMock];
            [collectionView stub:@selector(bounds) andReturn:theValue(CGRectMake(0.f, 0.f, 70.f, 130.f))];
            [collectionView stub:@selector(contentOffset) andReturn:theValue(CGPointMake(0.f, 40.f))];
            [collectionView stub:@selector(contentInset) andReturn:theValue(UIEdgeInsetsMake(20.f, 10.f, 30.f, 40.f))];
            
            [layout stub:@selector(collectionView) andReturn:collectionView];
        });
        
        [[theValue([layout adjustedCollectionViewContentOffset]) should] equal:theValue(60.f)];
    });
        
    context(@"layout attributes frame validation", ^{
        
        __block CGRect layoutInfoFrame = CGRectZero;
        __block CGRect rect = CGRectZero;
        
        context(@"when both rects intersect", ^{
            beforeEach(^{
                rect = CGRectMake(0.f, 0.f, 100.f, 100.f);
            });
            
            it(@"should be true if layoutInfoFrame height is greater than zero", ^{
                layoutInfoFrame = CGRectMake(0.f, 0.f, 50.f, 70.f);
                [[theValue([layout layoutInfoFrame:layoutInfoFrame requiresLayoutAttritbutesForRect:rect]) should] beTrue];
            });
            
            it(@"should be false if layoutInfoFrame height of zero", ^{
                layoutInfoFrame = CGRectMake(0.f, 0.f, 50.f, 0.f);
                [[theValue([layout layoutInfoFrame:layoutInfoFrame requiresLayoutAttritbutesForRect:rect]) should] beFalse];
            });
        });
        
        context(@"when rects don't intersect", ^{
            beforeEach(^{
                rect = CGRectMake(1000.f, 1000.f, 100.f, 100.f);
            });
            
            it(@"should be false if layoutInfoFrame height is greater than zero", ^{
                layoutInfoFrame = CGRectMake(0.f, 0.f, 50.f, 70.f);
                [[theValue([layout layoutInfoFrame:layoutInfoFrame requiresLayoutAttritbutesForRect:rect]) should] beFalse];
            });
            
            it(@"should be false if layoutInfoFrame height of zero", ^{
                layoutInfoFrame = CGRectMake(0.f, 0.f, 50.f, 0.f);
                [[theValue([layout layoutInfoFrame:layoutInfoFrame requiresLayoutAttritbutesForRect:rect]) should] beFalse];
            });
        });
    });
    
    context(@"getSizingInfos", ^{
        
        __block UICollectionView *collectionView = nil;
        __block AMFakeCollectionViewDelegateDataSource *delegate = nil;
        
        beforeEach(^{
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 250.f) collectionViewLayout:layout];
            delegate = [[AMFakeCollectionViewDelegateDataSource alloc] init];
            
            delegate.numberOfSections = 1;
            delegate.numberOfItemsInSection = 5;
            
            delegate.itemSize = CGSizeMake(70.f, 80.f);
            delegate.headerReferenceSize = CGSizeMake(27.f, 48.f);
            delegate.footerReferenceSize = CGSizeMake(17.f, 58.f);
            delegate.sectionHeaderReferenceSize = CGSizeMake(227.f, 148.f);
            delegate.sectionFooterReferenceSize = CGSizeMake(127.f, 458.f);
            delegate.sectionInset =  UIEdgeInsetsMake(10.f, 25.f, 20.f, 5.f);
            delegate.minimumLineSpacing = 8.f;
            delegate.minimumInteritemSpacing = 10.f;
            
            collectionView.delegate = delegate;
            [layout prepareLayout];
        });
        
        it(@"should set the header frame size", ^{
            [[theValue(layout.layoutInfo.headerFrame.size) should] equal:theValue(CGSizeMake(CGRectGetWidth(collectionView.frame), [layout sizeForHeader].height))];
        });
        
        it(@"should set the footer frame size", ^{
            [[theValue(layout.layoutInfo.footerFrame.size) should] equal:theValue(CGSizeMake(CGRectGetWidth(collectionView.frame), [layout sizeForFooter].height))];
        });
        
        for (NSInteger section = 0; section < [collectionView numberOfSections]; section++)
        {
            AMPerSectionCollectionViewLayoutSection *layoutSection = layout.layoutInfo.layoutInfoSections[(NSUInteger)section];
            
            it(@"should set the section header frame size", ^{
                [[theValue(layoutSection.headerFrame.size) should] equal:theValue([layout sizeForHeaderInSection:section])];
            });
            
            it(@"should set the section footer frame size", ^{
                [[theValue(layoutSection.footerFrame.size) should] equal:theValue([layout sizeForFooterInSection:section])];
            });
            
            it(@"should set the section margin", ^{
                [[theValue(layoutSection.sectionMargins) should] equal:theValue([layout insetForSectionAtIndex:section])];
            });
            
            it(@"should set the vertical interstice", ^{
                [[theValue(layoutSection.verticalInterstice) should] equal:theValue([layout minimumLineSpacingForSectionAtIndex:section])];
            });
            
            it(@"should set the horizontal interstice", ^{
                [[theValue(layoutSection.horizontalInterstice) should] equal:theValue([layout minimumInteritemSpacingForSectionAtIndex:section])];
            });
            
            
            for (NSInteger item = 0; item < [collectionView numberOfItemsInSection:section]; item++)
            {
                AMPerSectionCollectionViewLayoutItem *layoutItem = layoutSection.layoutSectionItems[(NSUInteger)item];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                [[theValue(layoutItem.frame) should] equal:theValue([layout sizeForItemAtIndexPath:indexPath])];
            }
        }
    });
    
    context(@"layout methods to override", ^{
        __block UICollectionView *collectionView = nil;
        __block AMFakeCollectionViewDelegateDataSource *delegateDataSource = nil;
        
        beforeEach(^{
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, 250.f, 500.f) collectionViewLayout:layout];
            delegateDataSource = [[AMFakeCollectionViewDelegateDataSource alloc] init];
            
            
            delegateDataSource.numberOfSections = 3;
            delegateDataSource.numberOfItemsInSection = 10;
            delegateDataSource.itemSize = CGSizeMake(50.f, 50.f);
            delegateDataSource.headerReferenceSize = CGSizeMake(25.f, 30.f);
            delegateDataSource.footerReferenceSize = CGSizeMake(25.f, 40.f);
            delegateDataSource.sectionHeaderReferenceSize = CGSizeMake(27.f, 50.f);
            delegateDataSource.sectionFooterReferenceSize = CGSizeMake(17.f, 70.f);
            delegateDataSource.minimumLineSpacing = 10.f;
            delegateDataSource.minimumInteritemSpacing = 10.f;
            delegateDataSource.sectionMinimumWidth = CGRectGetWidth(collectionView.frame);
            delegateDataSource.stickyHeader = YES;
            delegateDataSource.lastSectionWithStickyHeader = 1;
            
            collectionView.delegate = delegateDataSource;
            collectionView.dataSource = delegateDataSource;
            
            [layout prepareLayout];
        });
        
        context(@"sticky header", ^{
            it(@"should enable on the layout info sticky header", ^{
                [[theValue(layout.layoutInfo.hasStickyHeader) should] equal:theValue(delegateDataSource.hasStickyHeader)];
            });
            
            it(@"should set the layout info last section with sticky header", ^{
                [[theValue(layout.layoutInfo.lastSectionWithStickyHeader) should] equal:theValue(delegateDataSource.lastSectionWithStickyHeader)];
            });
        });
    });
    
    context(@"layout methods to override", ^{
        __block UICollectionView *collectionView = nil;
        __block AMFakeCollectionViewDelegateDataSource *delegateDataSource = nil;
        
        beforeEach(^{
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, 250.f, 500.f) collectionViewLayout:layout];
            delegateDataSource = [[AMFakeCollectionViewDelegateDataSource alloc] init];
            
            
            delegateDataSource.numberOfSections = 3;
            delegateDataSource.numberOfItemsInSection = 10;
            delegateDataSource.itemSize = CGSizeMake(50.f, 50.f);
            delegateDataSource.headerReferenceSize = CGSizeMake(25.f, 30.f);
            delegateDataSource.footerReferenceSize = CGSizeMake(25.f, 40.f);
            delegateDataSource.sectionHeaderReferenceSize = CGSizeMake(27.f, 50.f);
            delegateDataSource.sectionFooterReferenceSize = CGSizeMake(17.f, 70.f);
            delegateDataSource.minimumLineSpacing = 10.f;
            delegateDataSource.minimumInteritemSpacing = 10.f;
            delegateDataSource.sectionMinimumWidth = CGRectGetWidth(collectionView.frame);
            delegateDataSource.stickyHeader = YES;
            delegateDataSource.lastSectionWithStickyHeader = 1;
            
            collectionView.delegate = delegateDataSource;
            collectionView.dataSource = delegateDataSource;
            
            [layout prepareLayout];
        });
        
        context(@"collectionViewContentSize", ^{
            it(@"should ask the layout info for the collection view content size", ^{
                [[theValue(layout.collectionViewContentSize) should] equal:theValue(layout.layoutInfo.contentSize)];
            });
        });
        
        context(@"layoutAttributesForElementsInRect", ^{
            __block NSArray *layoutAttributesForElementsInRect = nil;
            
            context(@"given the collection view content size", ^{
                beforeEach(^{
                    layoutAttributesForElementsInRect = [layout layoutAttributesForElementsInRect:CGRectMake(0.f, 0.f, layout.collectionViewContentSize.width, layout.collectionViewContentSize.height)];
                });
                
                it(@"should return all elements", ^{
                    [[layoutAttributesForElementsInRect should] beNonNil];
                    
                    // header + footer + 30 * (rows) + 3 * header + footer ==> 38
                    [[layoutAttributesForElementsInRect should] haveCountOf:38];
                });
            });
            
            context(@"emulating a scroll", ^{
                beforeEach(^{
                    CGFloat yOffset = delegateDataSource.headerReferenceSize.height + 60;
                    
                    [layout stub:@selector(adjustedCollectionViewContentOffset) andReturn:theValue(yOffset)];
                    layoutAttributesForElementsInRect = [layout layoutAttributesForElementsInRect:CGRectMake(0.f,  yOffset, layout.collectionViewContentSize.width,  layout.collectionViewContentSize.height - yOffset)];
                });
                
                it(@"should return the sticky header", ^{
                    [[layoutAttributesForElementsInRect should] beNonNil];
                    
                    [[[layoutAttributesForElementsInRect valueForKey:@"elementKind"] should] contain:AMPerSectionCollectionElementKindHeader];
                });
            });
        });
        
        context(@"layoutAttributesForItemAtIndexPath", ^{
            __block UICollectionViewLayoutAttributes *attributes;
            
            context(@"first indexPath", ^{
                beforeEach(^{
                    attributes = [layout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                });
                
                it(@"should return a layout attributes", ^{
                    [[attributes should] beNonNil];
                });
                
                it(@"should have a frame", ^{
                    [[theValue(attributes.frame) should] equal:theValue(CGRectMake(0.f, 80.f, 50.f, 50.f))];
                });
            });
            
            context(@"last indexPath", ^{
                beforeEach(^{
                    attributes = [layout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:9 inSection:2]];
                });
                
                it(@"should return a layout attributes", ^{
                    [[attributes should] beNonNil];
                });
                
                it(@"should return a layout attributes with a frame", ^{
                    [[theValue(attributes.frame) should] equal:theValue(CGRectMake(60.f, 800.f, 50.f, 50.f))];
                });
            });
        });
        
        context(@"layoutAttributesForSupplementaryViewOfKind", ^{
            __block UICollectionViewLayoutAttributes *attributes;
            
            context(@"AMPerSectionCollectionElementKindHeader", ^{
                beforeEach(^{
                    attributes = [layout layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                });
                
                it(@"should return a layout attributes", ^{
                    [[attributes should] beNonNil];
                });
                
                it(@"should return a layout attributes with a frame", ^{
                    [[theValue(attributes.frame) should] equal:theValue(layout.layoutInfo.headerFrame)];
                });
            });
            
            context(@"AMPerSectionCollectionElementKindFooter", ^{
                beforeEach(^{
                    attributes = [layout layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                });
                
                it(@"should return a layout attributes", ^{
                    [[attributes should] beNonNil];
                });
                
                it(@"should return a layout attributes with a frame", ^{
                    [[theValue(attributes.frame) should] equal:theValue(layout.layoutInfo.footerFrame)];
                });
            });
            
            context(@"for a given section", ^{
                __block AMPerSectionCollectionViewLayoutSection *section = nil;
                
                beforeEach(^{
                    section = [layout.layoutInfo sectionAtIndex:1];
                });
                
                context(@"AMPerSectionCollectionElementKindSectionHeader", ^{
                    beforeEach(^{
                        attributes = [layout layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
                    });
                    
                    it(@"should return a layout attributes", ^{
                        [[attributes should] beNonNil];
                    });
                    
                    it(@"should return a layout attributes with a frame", ^{
                        [[theValue(attributes.frame) should] equal:theValue(section.headerFrame)];
                    });
                });
                
                context(@"AMPerSectionCollectionElementKindSectionFooter", ^{
                    beforeEach(^{
                        attributes = [layout layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
                    });
                    
                    it(@"should return a layout attributes", ^{
                        [[attributes should] beNonNil];
                    });
                    
                    it(@"should return a layout attributes with a frame", ^{
                        [[theValue(attributes.frame) should] equal:theValue(section.footerFrame)];
                    });
                });
            });
        });
        
        context(@"layoutAttributesForDecorationViewOfKind", ^{
            it(@"should return nothing", ^{
                [[[layout layoutAttributesForDecorationViewOfKind:@"test" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]] should] beNil];
            });
        });
        
        context(@"shouldInvalidateLayoutForBoundsChange", ^{
            it(@"should not invalide layout for bounds change", ^{
                [[theValue([layout shouldInvalidateLayoutForBoundsChange:CGRectMake(0.f, 0.f, 40.f, 50.f)]) should] beTrue];
            });
            
            // FIXME: what if bounds width / height differ ?
        });
    });
});

SPEC_END
