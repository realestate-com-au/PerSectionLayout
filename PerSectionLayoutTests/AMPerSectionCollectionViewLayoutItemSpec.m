//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutItem.h"
#import "AMPerSectionCollectionViewLayoutRow.h"

SPEC_BEGIN(AMPerSectionCollectionViewLayoutItemSpec)

describe(@"AMPerSectionCollectionViewLayoutItem", ^{
    
    __block AMPerSectionCollectionViewLayoutItem *item = nil;
    
    beforeEach(^{
        item = [[AMPerSectionCollectionViewLayoutItem alloc] init];
    });
    
    context(@"frame", ^{
        
        __block CGRect frame = CGRectZero;
        
        beforeEach(^{
            frame = CGRectMake(20.f, 0.f, 50.f, 25.f);
            item.frame = frame;
        });
        
        it(@"should remember it's frame", ^{
            [[theValue(item.frame) should] equal:theValue(frame)];
        });
    });
    
    context(@"row", ^{
        
        __block AMPerSectionCollectionViewLayoutRow *row = nil;
        
        beforeEach(^{
            row = [[AMPerSectionCollectionViewLayoutRow alloc] init];
            item.row = row;
        });
        
        it(@"should remember it's row", ^{
            AMPerSectionCollectionViewLayoutRow *itemRow = item.row;
            [[row should] equal:itemRow];
        });
    });
});

SPEC_END
