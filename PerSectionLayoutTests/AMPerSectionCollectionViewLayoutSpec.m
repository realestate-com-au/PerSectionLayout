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
                 [[theValue([layout sizeForHeader]) should] equal:theValue(CGSizeMake(CGRectGetWidth(collectionView.frame), layout.headerReferenceSize.height))];
            });
            
            it(@"sizeForFooter", ^{
                 [[theValue([layout sizeForFooter]) should] equal:theValue(CGSizeMake(CGRectGetWidth(collectionView.frame), layout.footerReferenceSize.height))];
            });
            
            it(@"sizeForHeaderInSection", ^{
                [[theValue([layout sizeForHeaderInSection:0]) should] equal:theValue(CGSizeMake(CGRectGetWidth(collectionView.frame), layout.sectionHeaderReferenceSize.height))];
            });
            
            it(@"sizeForFooterInSection", ^{
                [[theValue([layout sizeForFooterInSection:0]) should] equal:theValue(CGSizeMake(CGRectGetWidth(collectionView.frame), layout.sectionFooterReferenceSize.height))];
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
            
            __block AMFakeCollectionViewDelegateDataSource *delegate = nil;
            
            beforeEach(^{
                delegate = [[AMFakeCollectionViewDelegateDataSource alloc] init];
                
                delegate.itemSize = CGSizeMake(70.f, 80.f);
                delegate.headerReferenceSize = CGSizeMake(27.f, 48.f);
                delegate.footerReferenceSize = CGSizeMake(17.f, 58.f);
                delegate.sectionHeaderReferenceSize = CGSizeMake(227.f, 148.f);
                delegate.sectionFooterReferenceSize = CGSizeMake(127.f, 458.f);
                delegate.sectionInset =  UIEdgeInsetsMake(10.f, 25.f, 20.f, 5.f);
                delegate.minimumLineSpacing = 8.f;
                delegate.minimumInteritemSpacing = 10.f;
                
                collectionView.delegate = delegate;
            });
            
            it(@"sizeForItemAtIndexPath", ^{
                [[theValue([layout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]) should] equal:theValue(delegate.itemSize)];
            });
            
            it(@"sizeForHeader", ^{
                [[theValue([layout sizeForHeader]) should] equal:theValue(CGSizeMake(CGRectGetWidth(collectionView.frame), delegate.headerReferenceSize.height))];
            });
            
            it(@"sizeForFooter", ^{
                [[theValue([layout sizeForFooter]) should] equal:theValue(CGSizeMake(CGRectGetWidth(collectionView.frame), delegate.footerReferenceSize.height))];
            });
            
            it(@"sizeForHeaderInSection", ^{
                [[theValue([layout sizeForHeaderInSection:0]) should] equal:theValue(CGSizeMake(CGRectGetWidth(collectionView.frame), delegate.sectionHeaderReferenceSize.height))];
            });
            
            it(@"sizeForFooterInSection", ^{
                [[theValue([layout sizeForFooterInSection:0]) should] equal:theValue(CGSizeMake(CGRectGetWidth(collectionView.frame), delegate.sectionFooterReferenceSize.height))];
            });
            
            it(@"insetForSectionAtIndex", ^{
                [[theValue([layout insetForSectionAtIndex:0]) should] equal:theValue(delegate.sectionInset)];
            });
            
            it(@"minimumLineSpacingForSectionAtIndex", ^{
                [[theValue([layout minimumLineSpacingForSectionAtIndex:0]) should] equal:theValue(delegate.minimumLineSpacing)];
            });
            
            it(@"minimumInteritemSpacing", ^{
                [[theValue([layout minimumInteritemSpacingForSectionAtIndex:0]) should] equal:theValue(delegate.minimumInteritemSpacing)];
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
            [[theValue(layout.layoutInfo.headerFrame.size) should] equal:theValue([layout sizeForHeader])];
        });
        
        it(@"should set the footer frame size", ^{
             [[theValue(layout.layoutInfo.footerFrame.size) should] equal:theValue([layout sizeForFooter])];
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
                [[theValue(layoutSection.sectionMargins) should] equal:theValue([layout sizeForHeaderInSection:section])];
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
        
        // FIXME: revist me once compute layout is working
        
        it(@"should compute the collection view content size", ^{
            [[theValue([layout collectionViewContentSize]) shouldNot] equal:theValue(CGSizeZero)];
        });
        
        for (AMPerSectionCollectionViewLayoutSection *layoutSection in layout.layoutInfo.layoutInfoSections)
        {
            it(@"should compute the layout of each section", ^{
                [[theValue(layoutSection.frame) shouldNot] equal:theValue(CGRectZero)];
            });
        }
        
        it(@"should compute the global footer frame", ^{
            [[theValue([layout.layoutInfo footerFrame]) shouldNot] equal:theValue(CGRectZero)];
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
