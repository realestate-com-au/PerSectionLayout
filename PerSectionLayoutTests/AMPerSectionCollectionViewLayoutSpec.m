//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayout.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMFakeCollectionViewDelegateDataSource.h"

@interface AMPerSectionCollectionViewLayout ()

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)sizeForHeader;
- (CGSize)sizeForFooter;
- (CGSize)sizeForHeaderInSection:(NSInteger)section;
- (CGSize)sizeForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (void)fetchItemsInfo;
- (void)getSizingInfos;
- (void)updateItemsLayout;
- (AMPerSectionCollectionViewLayoutSection *)sectionAtIndex:(NSInteger)section;
- (AMPerSectionCollectionViewLayoutItem *)itemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)layoutInfoFrame:(CGRect)layoutInfoFrame requiresLayoutAttritbutesForRect:(CGRect)rect;

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
            
            it(@"minimumLineSpacingForSectionAtIndex", ^{
                [[theValue([layout minimumLineSpacingForSectionAtIndex:0]) should] equal:theValue(layout.minimumLineSpacing)];
            });
            
            it(@"minimumInteritemSpacing", ^{
                [[theValue([layout minimumInteritemSpacingForSectionAtIndex:0]) should] equal:theValue(layout.minimumInteritemSpacing)];
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
            
            it(@"minimumLineSpacingForSectionAtIndex", ^{
                [[theValue([layout minimumLineSpacingForSectionAtIndex:0]) should] equal:theValue(delegateDataSource.minimumLineSpacing)];
            });
            
            it(@"minimumInteritemSpacing", ^{
                [[theValue([layout minimumInteritemSpacingForSectionAtIndex:0]) should] equal:theValue(delegateDataSource.minimumInteritemSpacing)];
            });
        });
    });
    
    context(@"prepareLayout", ^{
        
        __block UICollectionView *collectionView = nil;
        
        beforeEach(^{
            collectionView = [UICollectionView nullMock];
            [collectionView stub:@selector(bounds) andReturn:theValue(CGRectMake(0.f, 0.f, 70.f, 130.f))];
            
            [layout stub:@selector(collectionView) andReturn:collectionView];
            [layout prepareLayout];
        });
        
        it(@"should fetch items info", ^{
            [[layout should] receive:@selector(fetchItemsInfo)];
            [layout prepareLayout];
        });
        
        context(@"layout info", ^{
            it(@"should have one", ^{
                [[layout.layoutInfo should] beNonNil];
            });
            
            it(@"should be given the collection view size", ^{
                [[theValue(layout.layoutInfo.collectionViewSize) should] equal:theValue(collectionView.bounds.size)];
            });
        });
    });
    
    context(@"fetchItemsInfo", ^{
        it(@"should get the sizing infos", ^{
            [[layout should] receive:@selector(getSizingInfos)];
            [layout fetchItemsInfo];
        });
        
        it(@"should update the items layout", ^{
            [[layout should] receive:@selector(updateItemsLayout)];
            [layout fetchItemsInfo];
        });
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
    
    context(@"updateItemsLayout", ^{
        
        __block UICollectionView *collectionView = nil;
        __block AMFakeCollectionViewDelegateDataSource *delegateDataSource = nil;
        
        beforeEach(^{
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, 250.f, 500.f) collectionViewLayout:layout];
            delegateDataSource = [[AMFakeCollectionViewDelegateDataSource alloc] init];
            
            
            delegateDataSource.numberOfSections = 1;
            delegateDataSource.numberOfItemsInSection = 10;
            delegateDataSource.itemSize = CGSizeMake(50.f, 50.f);
            delegateDataSource.headerReferenceSize = CGSizeMake(25.f, 30.f);
            delegateDataSource.footerReferenceSize = CGSizeMake(25.f, 40.f);
            delegateDataSource.sectionHeaderReferenceSize = CGSizeMake(27.f, 50.f);
            delegateDataSource.sectionFooterReferenceSize = CGSizeMake(17.f, 70.f);
            delegateDataSource.minimumLineSpacing = 10.f;
            delegateDataSource.minimumInteritemSpacing = 10.f;
            delegateDataSource.sectionInset = UIEdgeInsetsMake(10.f, 30.f, 20.f, 40.f);
            
            collectionView.delegate = delegateDataSource;
            collectionView.dataSource = delegateDataSource;
            
            [layout prepareLayout];
        });
        
        it(@"should compute the collection view content size", ^{
            [[theValue([layout collectionViewContentSize]) should] equal:theValue(CGSizeMake(250.f, 460.f))];
        });
        
        it(@"should compute the global header frame", ^{
            [[theValue([layout.layoutInfo headerFrame]) should] equal:theValue(CGRectMake(0.f, 0.f, 250.f, 30.f))];
        });
        
        it(@"should compute the global footer frame", ^{
             [[theValue([layout.layoutInfo footerFrame]) should] equal:theValue(CGRectMake(0.f, 420.f, 250.f, 40.f))];
        });
        
        context(@"first section", ^{
            
            __block AMPerSectionCollectionViewLayoutSection *layoutSection = nil;
            
            beforeEach(^{
                layoutSection = [layout sectionAtIndex:0];
            });
            
            it(@"should compute the header frame", ^{
                [[theValue(layoutSection.headerFrame) should] equal:theValue(CGRectMake(0.f, 0.f, 250.f, 50.f))];
            });
            
            it(@"should computer the body frame", ^{
                [[theValue(layoutSection.bodyFrame) should] equal:theValue(CGRectMake(30.f, 60.f, 180.f, 240.f))];
            });
            
            it(@"should compute the footer frame", ^{
                [[theValue(layoutSection.footerFrame) should] equal:theValue(CGRectMake(0.f, 320.f, 250.f, 70.f))];
            });
            
            it(@"should compute the total frame", ^{
               [[theValue(layoutSection.frame) should] equal:theValue(CGRectMake(0.f, 30.f, 250.f, 390.f))];
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
    
    context(@"Utilities", ^{
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
            
            collectionView.delegate = delegateDataSource;
            collectionView.dataSource = delegateDataSource;
            
            [layout prepareLayout];
        });
        
        context(@"sectionAtIndex", ^{
            it(@"should return a section for a valid index", ^{
                AMPerSectionCollectionViewLayoutSection *section = [layout sectionAtIndex:1];
                [[section should] beNonNil];
            });
            
            it(@"should not return a section for an invalid index", ^{
                AMPerSectionCollectionViewLayoutSection *section = [layout sectionAtIndex:3];
                [[section should] beNil];
            });
        });
        
        context(@"itemAtIndexPath", ^{
            it(@"should return an item for a valid index path", ^{
                AMPerSectionCollectionViewLayoutItem *item = [layout itemAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:2]];
                [[item should] beNonNil];
            });
            
            it(@"should not return an item for an invalid index path", ^{
                AMPerSectionCollectionViewLayoutItem *item = [layout itemAtIndexPath:[NSIndexPath indexPathForItem:10 inSection:2]];
                [[item should] beNil];
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
            
            beforeEach(^{
                layoutAttributesForElementsInRect = [layout layoutAttributesForElementsInRect:CGRectMake(0.f, 0.f, layout.collectionViewContentSize.width, layout.collectionViewContentSize.height)];
            });
            
            it(@"should return all elements", ^{
                [[layoutAttributesForElementsInRect should] beNonNil];
                
                // header + footer + 30 * (rows) + 3 * header + footer ==> 38
                [[layoutAttributesForElementsInRect should] haveCountOf:38];
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
                    section = [layout sectionAtIndex:1];
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
                [[theValue([layout shouldInvalidateLayoutForBoundsChange:CGRectMake(0.f, 0.f, 40.f, 50.f)]) should] beFalse];
            });
            
            // FIXME: what if bounds width / height differ ?
        });
    });
});

SPEC_END
