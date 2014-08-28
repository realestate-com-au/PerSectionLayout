//
//  Copyright 2014 REA Group. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayout.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMFakeCollectionViewDelegateDataSource.h"
#import "math.h"
#import "AMPerSectionCollectionViewLayoutInvalidationContext.h"
#import "AMPerSectionCollectionViewLayoutAttributes.h"
#import "UIDevice+iOS7Compatibility.h"

@interface AMPerSectionCollectionViewLayout ()

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)sizeForHeader;
- (CGSize)sizeForFooter;
- (CGSize)sizeForHeaderInSection:(NSInteger)section;
- (CGSize)sizeForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)widthForSectionAtIndex:(NSInteger)section;
- (CGFloat)minimumHeightForSectionAtIndex:(NSInteger)section;
- (BOOL)hasStickyHeaderOverSection:(NSInteger)section;
- (BOOL)canStretchSectionAtIndex:(NSInteger)section;
- (void)getSizingInfos:(id)arg;
- (void)updateItemsLayout:(id)arg;
- (CGPoint)adjustedCollectionViewContentOffset;

@property (nonatomic, strong) AMPerSectionCollectionViewLayoutInfo *layoutInfo;
@property (nonatomic, assign, getter = isTransitioning) BOOL transitioning;
@property (nonatomic, assign) CGPoint transitionTargetContentOffset;
@property (nonatomic, assign, getter = isPerformingCollectionViewUpdates) BOOL performingCollectionViewUpdates;

@end

SPEC_BEGIN(AMPerSectionCollectionViewLayoutSpec)

describe(@"AMPerSectionCollectionViewLayout", ^{
  __block AMPerSectionCollectionViewLayout *layout;
  __block UICollectionView *collectionView = nil;
  
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
      [[theValue(layout.sectionWidth) should] equal:theValue(NAN)];
    });
    
    it(@"should have by default non stick header", ^{
      [[theValue(layout.hasStickyHeader) should] equal:theValue(NO)];
    });
    
    it(@"should have no transition target content offset", ^{
      [[theValue(layout.transitionTargetContentOffset) should] equal:theValue(CGPointZero)];
    });
  });
  
  context(@"layoutAttributesClass", ^{
    it(@"should use the custom AMPerSectionCollectionViewLayoutAttributes class", ^{
      [[[AMPerSectionCollectionViewLayout layoutAttributesClass] should] equal:[AMPerSectionCollectionViewLayoutAttributes class]];
    });
  });
  
  if ([[UIDevice currentDevice] isPerSectionLayoutRunningOnAtLeastiOS7])
  {
    context(@"layout invalidation", ^{
      context(@"invalidationContextClass", ^{
        it(@"should be a custom class", ^{
          [[[AMPerSectionCollectionViewLayout invalidationContextClass] should] equal:[AMPerSectionCollectionViewLayoutInvalidationContext class]];
        });
      });
      
      context(@"invalidationContextForBoundsChange", ^{
        beforeEach(^{
          collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 50.f) collectionViewLayout:layout];
          [layout stub:@selector(collectionView) andReturn:collectionView];
        });
        
        context(@"when the collection view bounds size has changed", ^{
          it(@"should set invalidateHeader to No", ^{
            AMPerSectionCollectionViewLayoutInvalidationContext *context = (AMPerSectionCollectionViewLayoutInvalidationContext *)[layout invalidationContextForBoundsChange:CGRectMake(0.f, 0.f, 250.f, 50.f)];
            [[theValue(context.invalidateHeader) should] beFalse];
          });
        });
        
        context(@"when the collection view bounds size stays the same", ^{
          
          
          it(@"should set invalidateHeader to Yes", ^{
            AMPerSectionCollectionViewLayoutInvalidationContext *context = (AMPerSectionCollectionViewLayoutInvalidationContext *)[layout invalidationContextForBoundsChange:CGRectMake(0.f, 0.f, 200.f, 50.f)];
            [[theValue(context.invalidateHeader) should] beTrue];
          });
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
  }
  
  context(@"target content offset for used in layout to layout transition", ^{
    context(@"when is transitioning", ^{
      beforeEach(^{
        layout.transitioning = YES;
      });
      
      context(@"when have a transition target offset", ^{
        beforeEach(^{
          layout.transitionTargetContentOffset = CGPointMake(0.f, 40.f);
        });
        
        it(@"should use it the transition target offset to compute adjustedCollectionViewContentOffset", ^{
          [[theValue(layout.adjustedCollectionViewContentOffset) should] equal:theValue(CGPointMake(0.f, 40.f))];
        });
      });
      
      context(@"when doesn't have a transition target offset", ^{
        beforeEach(^{
          layout.transitionTargetContentOffset = CGPointZero;
        });
        
        it(@"should use it the transition target offset to compute adjustedCollectionViewContentOffset", ^{
          [[theValue(layout.adjustedCollectionViewContentOffset) should] equal:theValue(CGPointZero)];
        });
      });
    });
    
    context(@"when isn't transitioning", ^{
      beforeEach(^{
        layout.transitioning = NO;
      });
      
      context(@"when have a transition target offset", ^{
        beforeEach(^{
          layout.transitionTargetContentOffset = CGPointMake(0.f, 40.f);
        });
        
        it(@"should use it the transition target offset to compute adjustedCollectionViewContentOffset", ^{
          [[theValue(layout.adjustedCollectionViewContentOffset) should] equal:theValue(CGPointMake(0.f, 0.f))];
        });
      });
    });
  });
  
  if ([[UIDevice currentDevice] isPerSectionLayoutRunningOnAtLeastiOS7])
  {
    context(@"transitioning", ^{
      
      __block AMPerSectionCollectionViewLayout *newLayout = nil;
      
      beforeEach(^{
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 250.f) collectionViewLayout:layout];
        collectionView.contentInset = UIEdgeInsetsMake(45.f, 15.f, 25.f, 13.f);
        [layout stub:@selector(collectionView) andReturn:collectionView];
        
        newLayout = [[AMPerSectionCollectionViewLayout alloc] init];
        [newLayout stub:@selector(collectionView) andReturn:collectionView];
      });
      
      context(@"when preparing to transition to a new layout", ^{
        beforeEach(^{
          [layout prepareForTransitionToLayout:newLayout];
        });
        
        it(@"should mark the new layout as being transitioned", ^{
          [[theValue(newLayout.transitioning) should] beYes];
        });
      });
      
      context(@"when target content offset is called", ^{
        context(@"when proposed content offset is different from target content offset", ^{
          beforeEach(^{
            [layout prepareForTransitionToLayout:newLayout];
            [newLayout targetContentOffsetForProposedContentOffset:CGPointMake(0.f, 60.f)];
          });
          
          it(@"should udpate the transition target content offset", ^{
            [[theValue(newLayout.transitionTargetContentOffset) should] equal:theValue(CGPointMake(0.f, -45.f))];
          });
        });
        
        context(@"when proposed content offset is equal to the target content offset", ^{
          beforeEach(^{
            [layout prepareForTransitionToLayout:newLayout];
            [newLayout targetContentOffsetForProposedContentOffset:CGPointMake(0.f, -45.f)];
          });
          
          it(@"should udpate the transition target content offset", ^{
            [[theValue(newLayout.transitionTargetContentOffset.y) should] equal:-44.9 withDelta:0.0001f];
          });
        });
      });
      
      context(@"when transition is finalized", ^{
        beforeEach(^{
          [layout prepareForTransitionToLayout:newLayout];
          [newLayout finalizeLayoutTransition];
        });
        
        it(@"should mark the new layout as being transitioned", ^{
          [[theValue(newLayout.transitioning) should] beNo];
        });
        
        it(@"should no longer have a transition target content offset", ^{
          [[theValue(newLayout.transitionTargetContentOffset) should] equal:theValue(CGPointZero)];
        });
      });
    });
    
    context(@"performingCollectionViewUpdates", ^{
      beforeEach(^{
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 250.f) collectionViewLayout:layout];
        collectionView.contentInset = UIEdgeInsetsMake(45.f, 15.f, 25.f, 13.f);
        [layout stub:@selector(collectionView) andReturn:collectionView];
      });
      
      context(@"when performing collection view updates", ^{
        beforeEach(^{
          [layout prepareForCollectionViewUpdates:[NSArray array]];
        });
        
        it(@"should mark the layout as performing updates", ^{
          [[theValue(layout.performingCollectionViewUpdates) should] beYes];
        });
      });
      
      context(@"when target content offset is called", ^{
        context(@"when proposed content offset is different from target content offset", ^{
          beforeEach(^{
            [layout prepareForCollectionViewUpdates:[NSArray array]];
           
          });
          
          it(@"should udpate the target content offset", ^{
            [[theValue([layout targetContentOffsetForProposedContentOffset:CGPointMake(0.f, 60.f)]) should] equal:theValue(CGPointMake(0.f, -45.f))];
          });
        });
      });
      
      context(@"when collection view updates is finalized", ^{
        beforeEach(^{
          [layout prepareForCollectionViewUpdates:[NSArray array]];
          [layout finalizeCollectionViewUpdates];
        });
        
        it(@"should mark the new layout as being transitioned", ^{
          [[theValue(layout.performingCollectionViewUpdates) should] beNo];
        });
      });
    });
  }
  
  context(@"AMPerSectionCollectionViewLayoutDelegate", ^{
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
        layout.sectionWidth = 40.f;
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
      
      context(@"widthForSectionAtIndex", ^{
        it(@"should use the layout value", ^{
          [[theValue([layout widthForSectionAtIndex:0]) should] equal:theValue(layout.sectionWidth)];
        });
        
        it(@"should limit the width the the collection view bounds width", ^{
          layout.sectionWidth = 100.f;
          [[theValue([layout widthForSectionAtIndex:0]) should] equal:theValue(CGRectGetWidth(layout.collectionView.bounds))];
        });
      });
      
      it(@"widthForSectionAtIndex", ^{
        [[theValue([layout widthForSectionAtIndex:0]) should] equal:theValue(layout.sectionWidth)];
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
      
      it(@"canStretchSectionAtIndex", ^{
        [[theValue([layout canStretchSectionAtIndex:0]) should] beFalse];
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
        delegateDataSource.sectionIndexToStretch = 0;
        delegateDataSource.sectionWidth = 40;
        
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
      
      context(@"widthForSectionAtIndex", ^{
        it(@"should query it's delegate for the value", ^{
          [[theValue([layout widthForSectionAtIndex:0]) should] equal:theValue(delegateDataSource.sectionWidth)];
        });
        
        it(@"should limit the width the the collection view bounds width", ^{
          delegateDataSource.sectionWidth = 400.f;
          [[theValue([layout widthForSectionAtIndex:0]) should] equal:theValue(CGRectGetWidth(layout.collectionView.bounds))];
        });
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
      
      it(@"canStretchSectionAtIndex", ^{
        [[theValue([layout canStretchSectionAtIndex:0]) should] beTrue];
      });
    });
    
    context(@"prepareLayout", ^{
      beforeEach(^{
        collectionView = [UICollectionView nullMock];
        [collectionView stub:@selector(bounds) andReturn:theValue(CGRectMake(0.f, 0.f, 70.f, 130.f))];
        
        [layout stub:@selector(collectionView) andReturn:collectionView];
        [layout prepareLayout];
      });
      
      it(@"should fetch items info only if has no layout info", ^{
        layout.layoutInfo = nil;
        [[layout should] receive:@selector(getSizingInfos:)];
        [layout prepareLayout];
      });
      
      it(@"should not fetch items info if has a layout info", ^{
        [[layout shouldNot] receive:@selector(getSizingInfos:)];
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
    
    context(@"widthForSectionAtIndex", ^{
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
        delegateDataSource.sectionIndexToStretch = 0;
        
        collectionView.delegate = delegateDataSource;
        collectionView.dataSource = delegateDataSource;
        [delegateDataSource registerCustomElementsForCollectionView:collectionView];
      });
    });
    
    context(@"adjustedCollectionViewContentOffset", ^{
      beforeEach(^{
        collectionView = [UICollectionView nullMock];
        [collectionView stub:@selector(bounds) andReturn:theValue(CGRectMake(0.f, 0.f, 70.f, 130.f))];
        [collectionView stub:@selector(contentOffset) andReturn:theValue(CGPointMake(0.f, 40.f))];
        [collectionView stub:@selector(contentInset) andReturn:theValue(UIEdgeInsetsMake(20.f, 10.f, 30.f, 40.f))];
        
        [layout stub:@selector(collectionView) andReturn:collectionView];
      });
      
      [[theValue([layout adjustedCollectionViewContentOffset]) should] equal:theValue(60.f)];
    });
    
    context(@"getSizingInfos", ^{
      
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
    
    context(@"sticky header", ^{
      
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
        delegateDataSource.sectionWidth = CGRectGetWidth(collectionView.frame);
        delegateDataSource.stickyHeader = YES;
        delegateDataSource.lastSectionWithStickyHeader = 1;
        
        collectionView.delegate = delegateDataSource;
        collectionView.dataSource = delegateDataSource;
        
        [layout prepareLayout];
      });
      
      it(@"should enable on the layout info sticky header", ^{
        [[theValue(layout.layoutInfo.hasStickyHeader) should] equal:theValue(delegateDataSource.hasStickyHeader)];
      });
      
      it(@"should set the layout info last section with sticky header", ^{
        [[theValue(layout.layoutInfo.lastSectionWithStickyHeader) should] equal:theValue(delegateDataSource.lastSectionWithStickyHeader)];
      });
    });
    
    context(@"layout methods to override", ^{
      
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
        delegateDataSource.sectionWidth = CGRectGetWidth(collectionView.frame);
        delegateDataSource.stickyHeader = YES;
        delegateDataSource.lastSectionWithStickyHeader = 1;
        delegateDataSource.sectionIndexToStretch = 0;
        
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
          
          it(@"should have all it's returned attributes be of AMPerSectionCollectionViewLayoutAttributes class kind", ^{
            for (AMPerSectionCollectionViewLayoutAttributes *attributes in layoutAttributesForElementsInRect)
            {
              [[attributes should] beKindOfClass:[AMPerSectionCollectionViewLayoutAttributes class]];
            }
          });
          
          it(@"should have all it's returned attributes without an adjustment offset", ^{
            for (AMPerSectionCollectionViewLayoutAttributes *attributes in layoutAttributesForElementsInRect)
            {
              [[theValue(attributes.adjustmentOffset) should] equal:theValue(CGPointZero)];
            }
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
          
          it(@"should be of AMPerSectionCollectionViewLayoutAttributes class kind", ^{
            [[attributes should] beKindOfClass:[AMPerSectionCollectionViewLayoutAttributes class]];
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
          
          it(@"should be of AMPerSectionCollectionViewLayoutAttributes class kind", ^{
            [[attributes should] beKindOfClass:[AMPerSectionCollectionViewLayoutAttributes class]];
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
          
          it(@"should be of AMPerSectionCollectionViewLayoutAttributes class kind", ^{
            [[attributes should] beKindOfClass:[AMPerSectionCollectionViewLayoutAttributes class]];
          });
        });
        
        context(@"AMPerSectionCollectionElementKindFooter", ^{
          beforeEach(^{
            attributes = [layout layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindFooter atIndexPath:[NSIndexPath indexPathForItem:9 inSection:2]];
          });
          
          it(@"should return a layout attributes", ^{
            [[attributes should] beNonNil];
          });
          
          it(@"should return a layout attributes with a frame", ^{
            [[theValue(attributes.frame) should] equal:theValue(layout.layoutInfo.footerFrame)];
          });
          
          it(@"should be of AMPerSectionCollectionViewLayoutAttributes class kind", ^{
            [[attributes should] beKindOfClass:[AMPerSectionCollectionViewLayoutAttributes class]];
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
              [[theValue(attributes.frame) should] equal:theValue(CGRectMake(0.f, 330.f, 250.f, 50.f))];
            });
            
            it(@"should be of AMPerSectionCollectionViewLayoutAttributes class kind", ^{
              [[attributes should] beKindOfClass:[AMPerSectionCollectionViewLayoutAttributes class]];
            });
          });
          
          context(@"AMPerSectionCollectionElementKindSectionFooter", ^{
            beforeEach(^{
              attributes = [layout layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:9 inSection:1]];
            });
            
            it(@"should return a layout attributes", ^{
              [[attributes should] beNonNil];
            });
            
            it(@"should return a layout attributes with a frame", ^{
              [[theValue(attributes.frame) should] equal:theValue(CGRectMake(0.f, 560.f, 250.f, 70.f))];
            });
            
            it(@"should be of AMPerSectionCollectionViewLayoutAttributes class kind", ^{
              [[attributes should] beKindOfClass:[AMPerSectionCollectionViewLayoutAttributes class]];
            });
          });
        });
        
        context(@"layoutAttributesForDecorationViewOfKind", ^{
          context(@"for a given section", ^{
            __block AMPerSectionCollectionViewLayoutSection *section = nil;
            
            beforeEach(^{
              section = [layout.layoutInfo sectionAtIndex:1];
              
              attributes = [layout layoutAttributesForDecorationViewOfKind:AMPerSectionCollectionElementKindSectionBackground atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
            });
            
            it(@"should return no layout attributes", ^{
              [[attributes should] beNil];
            });
          });
        });
      });
      
      context(@"shouldInvalidateLayoutForBoundsChange", ^{
        it(@"should not invalide layout for bounds change", ^{
          [[theValue([layout shouldInvalidateLayoutForBoundsChange:CGRectMake(0.f, 0.f, 40.f, 50.f)]) should] beTrue];
        });
      });
    });
  });
});

SPEC_END
