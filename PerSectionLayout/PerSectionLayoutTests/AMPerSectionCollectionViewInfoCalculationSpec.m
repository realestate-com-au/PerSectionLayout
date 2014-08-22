//
//  Copyright 2014 REA Group. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMPerSectionCollectionViewLayoutSection.h"
#import "AMPerSectionCollectionViewLayoutItem.h"


SPEC_BEGIN(AMPerSectionCollectionViewInfoCalculationSpec)

describe(@"AMPerSectionCollectionViewInfoCalculation", ^{
  __block AMPerSectionCollectionViewLayoutInfo *layoutInfo;
  
  xit(@"a standard layout", ^{
    beforeEach(^{
      layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
      layoutInfo.collectionViewSize = CGSizeMake(300, 300);
      
      //AMPerSectionCollectionViewLayoutSection *section = [layoutInfo addSection];
      //AMPerSectionCollectionViewLayoutSection *section2 = [layoutInfo addSection];
    });
    
    //it should have a content size that accounts for the sections
    
    //it should layout the sections accordingly
    
    context(@"without section widths", ^{
      //it should set the section widths to the collectionViewSize.width
    });
    
    context(@"with a header frame", ^{
      beforeEach(^{
      });
      
      //it should set the header frame width to the width of the collectionViewSize
    });
    
    context(@"with a footer frame", ^{
      beforeEach(^{
      });
      //it should
    });
  });
  
  context(@"a complex layout with sizes that should stack", ^{
    
    beforeEach(^{
      layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
      layoutInfo.collectionViewSize = CGSizeMake(1024, 768);
      
      AMPerSectionCollectionViewLayoutSection *sectionOne = [layoutInfo addSection];
      sectionOne.width = 400;
      AMPerSectionCollectionViewLayoutItem *sectionOneItem = [sectionOne addItem];
      sectionOneItem.frame = (CGRect){.size = CGSizeMake(400, 1000)};
      
      AMPerSectionCollectionViewLayoutSection *sectionTwo = [layoutInfo addSection];
      sectionTwo.width = 259;
      AMPerSectionCollectionViewLayoutItem *sectionTwoItem = [sectionTwo addItem];
      sectionTwoItem.frame = (CGRect){.size = CGSizeMake(259, 200)};
      
      AMPerSectionCollectionViewLayoutSection *sectionThree = [layoutInfo addSection];
      sectionThree.width = 259;
      AMPerSectionCollectionViewLayoutItem *sectionThreeItem = [sectionThree addItem];
      sectionThreeItem.frame = (CGRect){.size = CGSizeMake(259, 300)};
      
      AMPerSectionCollectionViewLayoutSection *sectionFour = [layoutInfo addSection];
      sectionFour.width = 259;
      AMPerSectionCollectionViewLayoutItem *sectionFourItem = [sectionFour addItem];
      sectionFourItem.frame = (CGRect){.size = CGSizeMake(259, 300)};
      
      AMPerSectionCollectionViewLayoutSection *sectionFive = [layoutInfo addSection];
      sectionFive.width = 259;
      AMPerSectionCollectionViewLayoutItem *sectionFiveItem = [sectionFive addItem];
      sectionFiveItem.frame = (CGRect){.size = CGSizeMake(259, 300)};
      
      for (AMPerSectionCollectionViewLayoutSection *section in [layoutInfo layoutInfoSections])
      {
        section.verticalInterstice = 10;
      }
      
      [layoutInfo updateItemsLayout];
    });
    
    it(@"should compute the correct content size", ^{
      [[theValue(layoutInfo.contentSize) should] equal:theValue(CGSizeMake(918, 1010))];
    });
  });
  
  context(@"layout with one section", ^{
    
    beforeEach(^{
      layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
      layoutInfo.collectionViewSize = CGSizeMake(250, 500);
      layoutInfo.headerFrame = CGRectMake(1, 1, 25, 30); //setting bad origins because they should be controlled by the layout
      layoutInfo.footerFrame = CGRectMake(1, 11, 25, 40);
      
      AMPerSectionCollectionViewLayoutSection *section = [layoutInfo addSection];
      section.headerFrame = CGRectMake(1, 1, 27, 50); //setting bad origins because they should be controlled by the layout
      section.footerFrame = CGRectMake(1, 1, 17, 70);
      section.verticalInterstice = 10;
      section.horizontalInterstice = 10;
      section.sectionMargins = UIEdgeInsetsMake(10, 30, 20, 40);
      section.width = layoutInfo.collectionViewSize.width;
      for (int i = 0; i < 10; i++)
      {
        AMPerSectionCollectionViewLayoutItem *item = [section addItem];
        item.frame = (CGRect){.size = CGSizeMake(50, 50)};
      }
      
      [layoutInfo updateItemsLayout];
    });
    
    it(@"should compute the correct content size", ^{
      [[theValue(layoutInfo.contentSize) should] equal:theValue(CGSizeMake(250, 460))];
    });
    
    it(@"should compute the global header frame", ^{
      [[theValue(layoutInfo.headerFrame) should] equal:theValue(CGRectMake(0, 0, 250, 30))];
    });
    
    it(@"should compute the global footer frame", ^{
      [[theValue(layoutInfo.footerFrame) should] equal:theValue(CGRectMake(0, 420, 250, 40))];
    });
    
    context(@"first section", ^{
      __block AMPerSectionCollectionViewLayoutSection *layoutSection;
      
      beforeEach(^{
        layoutSection = [layoutInfo sectionAtIndex:0];
      });
      
      it(@"should compute the header frame", ^{
        [[theValue(layoutSection.headerFrame) should] equal:theValue(CGRectMake(0, 0, 250, 50))];
      });
      
      it(@"should computer the body frame", ^{
        [[theValue(layoutSection.bodyFrame) should] equal:theValue(CGRectMake(30, 60, 180, 240))];
      });
      
      it(@"should compute the footer frame", ^{
        [[theValue(layoutSection.footerFrame) should] equal:theValue(CGRectMake(0, 320, 250, 70))];
      });
      
      it(@"should compute the total frame", ^{
        [[theValue(layoutSection.frame) should] equal:theValue(CGRectMake(0, 30, 250, 390))];
      });
    });
  });
  
  context(@"updateItemsLayout with multiple sections", ^{
    __block AMPerSectionCollectionViewLayoutSection *layoutSection;
    
    beforeEach(^{
      layoutInfo = [[AMPerSectionCollectionViewLayoutInfo alloc] init];
      layoutInfo.collectionViewSize = CGSizeMake(200, 500);
      
      for (int j = 0; j < 5; j++)
      {
        AMPerSectionCollectionViewLayoutSection *section = [layoutInfo addSection];
        section.width = 100;
        for (int i = 0; i < 3; i++)
        {
          AMPerSectionCollectionViewLayoutItem *item = [section addItem];
          item.frame = (CGRect){.size = CGSizeMake(50, 50)};
        }
      }
      
      [layoutInfo updateItemsLayout];
    });
    
    it(@"should compute the collection view content size", ^{
      [[theValue(layoutInfo.contentSize) should] equal:theValue(CGSizeMake(200, 300))];
    });
    
    context(@"first section", ^{
      beforeEach(^{
        layoutSection = [layoutInfo sectionAtIndex:0];
      });
      
      it(@"should computer the body frame", ^{
        [[theValue(layoutSection.bodyFrame) should] equal:theValue(CGRectMake(0, 0, 100, 100))];
      });
      
      it(@"should compute the total frame", ^{
        [[theValue(layoutSection.frame) should] equal:theValue(CGRectMake(0, 0, 100, 100))];
      });
    });
    
    context(@"fourth section", ^{
      beforeEach(^{
        layoutSection = [layoutInfo sectionAtIndex:3];
      });
      
      it(@"should computer the body frame", ^{
        [[theValue(layoutSection.bodyFrame) should] equal:theValue(CGRectMake(0, 0, 100, 100))];
      });
      
      it(@"should compute the total frame", ^{
        [[theValue(layoutSection.frame) should] equal:theValue(CGRectMake(100, 100, 100, 100))];
      });
    });
    
    context(@"last section", ^{
      beforeEach(^{
        layoutSection = [layoutInfo sectionAtIndex:4];
      });
      
      it(@"should computer the body frame", ^{
        [[theValue(layoutSection.bodyFrame) should] equal:theValue(CGRectMake(0, 0, 100, 100))];
      });
      
      it(@"should compute the total frame", ^{
        [[theValue(layoutSection.frame) should] equal:theValue(CGRectMake(0, 200, 100, 100))];
      });
    });
  });
});

SPEC_END
