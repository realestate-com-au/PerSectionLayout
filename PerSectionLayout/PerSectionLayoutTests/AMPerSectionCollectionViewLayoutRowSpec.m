//
//  Copyright 2014 REA Group. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutRow.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMPerSectionCollectionViewLayoutSection.h"

SPEC_BEGIN(AMPerSectionCollectionViewLayoutRowSpec)

describe(@"AMPerSectionCollectionViewLayoutRow", ^{
  __block AMPerSectionCollectionViewLayoutRow *row;
  
  context(@"adding an item", ^{
    __block AMPerSectionCollectionViewLayoutItem *item;
    
    beforeEach(^{
      row = [[AMPerSectionCollectionViewLayoutRow alloc] init];
      item = [[AMPerSectionCollectionViewLayoutItem alloc] init];
      [row addItem:item];
    });
    
    it(@"should add a new layout item the array of items", ^{
      [[row.layoutSectionItems should] contain:item];
    });
    
    it(@"should set itelf as the item row object", ^{
      AMPerSectionCollectionViewLayoutRow *itemRow = item.row;
      [[row should] equal:itemRow];
    });
  });
  
  context(@"invalidate", ^{
    beforeEach(^{
      row = [[AMPerSectionCollectionViewLayoutRow alloc] init];\
      row.frame = CGRectMake(1, 1, 1, 1);
    });
    
    it(@"should reset the size and frame values to zeros", ^{
      [row invalidate];
      [[theValue(row.frame) should] equal:theValue(CGRectZero)];
    });
  });
  
  context(@"row loyout", ^{
    __block AMPerSectionCollectionViewLayoutSection *section;
    __block AMPerSectionCollectionViewLayoutItem *item;
    
    beforeEach(^{
      section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
    });
    
    context(@"with a single item", ^{
      beforeEach(^{
        row = [[AMPerSectionCollectionViewLayoutRow alloc] init];
        item = [[AMPerSectionCollectionViewLayoutItem alloc] init];
        
        item.frame = (CGRect){.size = CGSizeMake(100, 100)};
        [row addItem:item];
        
        [row computeLayoutInSection:section];
      });
      
      it(@"the item should have the appropriate frame", ^{
        [[theValue(item.frame) should] equal:theValue(CGRectMake(0, 0, 100, 100))];
      });
    });
    
    context(@"with multiple items", ^{
      __block AMPerSectionCollectionViewLayoutItem *item2;
      
      beforeEach(^{
        row = [[AMPerSectionCollectionViewLayoutRow alloc] init];
        
        item = [[AMPerSectionCollectionViewLayoutItem alloc] init];
        item.frame = (CGRect){.size = CGSizeMake(100, 100)};
        item2 = [[AMPerSectionCollectionViewLayoutItem alloc] init];
        item2.frame = (CGRect){.size = CGSizeMake(100, 110)};
        
        [row addItem:item];
        [row addItem:item2];
        
        [row computeLayoutInSection:section];
      });
      
      it(@"should layout items horizontally", ^{
        [[theValue(item.frame) should] equal:theValue(CGRectMake(0, 0, 100, 100))];
        [[theValue(item2.frame) should] equal:theValue(CGRectMake(100, 0.f, 100, 110))];
      });
    });
    
    context(@"with more items", ^{
      __block AMPerSectionCollectionViewLayoutItem *item2;
      __block AMPerSectionCollectionViewLayoutItem *item3;
      
      beforeEach(^{
        row = [[AMPerSectionCollectionViewLayoutRow alloc] init];
        
        item = [[AMPerSectionCollectionViewLayoutItem alloc] init];
        item.frame = (CGRect){.origin = CGPointMake(1, 10), .size = CGSizeMake(100, 100)};
        item2 = [[AMPerSectionCollectionViewLayoutItem alloc] init];
        item2.frame = (CGRect){.origin = CGPointMake(1, 10), .size = CGSizeMake(150, 110)};
        item3 = [[AMPerSectionCollectionViewLayoutItem alloc] init];
        item3.frame = (CGRect){.origin = CGPointMake(1, 10), .size = CGSizeMake(200, 115)};
        
        [row addItem:item];
        [row addItem:item2];
        [row addItem:item3];
        
        [row computeLayoutInSection:section];
      });
      
      it(@"should layout the items horizontally", ^{
        [[theValue(item.frame) should] equal:theValue(CGRectMake(0, 0, 100, 100))];
        [[theValue(item2.frame) should] equal:theValue(CGRectMake(100, 0, 150, 110))];
        [[theValue(item3.frame) should] equal:theValue(CGRectMake(250, 0, 200, 115))];
      });
    });
    
    context(@"with section horizontal interstice", ^{
      __block AMPerSectionCollectionViewLayoutItem *item2;
      
      beforeEach(^{
        section.horizontalInterstice = 10.f;
        row = [[AMPerSectionCollectionViewLayoutRow alloc] init];
        
        item = [[AMPerSectionCollectionViewLayoutItem alloc] init];
        item.frame = (CGRect){.size = CGSizeMake(100, 100)};
        item2 = [[AMPerSectionCollectionViewLayoutItem alloc] init];
        item2.frame = (CGRect){.size = CGSizeMake(100, 100)};
        
        [row addItem:item];
        [row addItem:item2];
        
        [row computeLayoutInSection:section];
      });
      
      it(@"should layout the items taking into account the hozontal interstice", ^{
        [[theValue(item.frame) should] equal:theValue(CGRectMake(0, 0, 100, 100))];
        [[theValue(item2.frame) should] equal:theValue(CGRectMake(110, 0, 100, 100))];
      });
    });
  });
});

SPEC_END
