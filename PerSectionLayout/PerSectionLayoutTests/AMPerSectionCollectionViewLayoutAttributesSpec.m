//
//  Copyright 2014 REA Group. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutAttributes.h"


SPEC_BEGIN(AMPerSectionCollectionViewLayoutAttributesSpec)

describe(@"AMPerSectionCollectionViewLayoutAttributes", ^{
  
  __block AMPerSectionCollectionViewLayoutAttributes *attributes = nil;
  
  beforeEach(^{
    attributes = [AMPerSectionCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  });
  
  it(@"default", ^{
    [[theValue(attributes.adjustmentOffset) should] equal:theValue(CGPointZero)];
  });
  
  context(@"once set", ^{
    
    __block CGPoint adjustmentOffset = CGPointZero;
    
    beforeEach(^{
      adjustmentOffset = CGPointMake(10.f, 20.f);
      attributes.adjustmentOffset = CGPointMake(10.f, 20.f);
    });
    
    it(@"should remember it's value", ^{
      [[theValue(attributes.adjustmentOffset) should] equal:theValue(adjustmentOffset)];
    });
  });
  
  context(@"isEqual", ^{
    __block AMPerSectionCollectionViewLayoutAttributes *otherAttributes = nil;
    
    beforeEach(^{
      otherAttributes = [AMPerSectionCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:attributes.indexPath];
    });
    
    context(@"when equal", ^{
      __block CGPoint adjustmentOffset = CGPointZero;
      
      beforeEach(^{
        adjustmentOffset = CGPointMake(10.f, 40.f);
        attributes.adjustmentOffset = adjustmentOffset;
        attributes.alpha = 0.5f;
        
        otherAttributes.adjustmentOffset = adjustmentOffset;
        otherAttributes.alpha = 0.5f;
      });
      
      it(@"should be equal", ^{
        [[theValue([attributes isEqual:otherAttributes]) should] beYes];
      });
    });
    
    context(@"when inequal", ^{
      beforeEach(^{
        attributes.adjustmentOffset = CGPointMake(10.f, 40.f);
        
        otherAttributes.adjustmentOffset = CGPointMake(13.f, 40.f);
      });
      
      it(@"should not be equal", ^{
        [[theValue([attributes isEqual:otherAttributes]) should] beNo];
      });
    });
  });
  
  context(@"copyWithZone", ^{
    
    __block CGPoint adjustmentOffset = CGPointZero;
    
    beforeEach(^{
      adjustmentOffset = CGPointMake(10.f, 20.f);
      attributes.adjustmentOffset = CGPointMake(10.f, 20.f);
    });
    
    context(@"once copied", ^{
      it(@"should still have an adjustment offset", ^{
        [[theValue([[attributes copy] adjustmentOffset]) should] equal:theValue(adjustmentOffset)];
      });
    });
  });
});

SPEC_END
