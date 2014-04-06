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
