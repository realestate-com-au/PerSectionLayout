//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutInvalidationContext.h"

SPEC_BEGIN(AMPerSectionCollectionViewLayoutInvalidationContextSpec)

describe(@"AMPerSectionCollectionViewLayoutInvalidationContext", ^{
    
    __block AMPerSectionCollectionViewLayoutInvalidationContext *invalidationContext = nil;
    
    beforeEach(^{
        invalidationContext = [[AMPerSectionCollectionViewLayoutInvalidationContext alloc] init];
    });
    
    context(@"default", ^{
        [[theValue(invalidationContext) should] equal:theValue(YES)];
    });
    
    context(@"invalidateHeader", ^{
        __block BOOL invalidateHeader = NO;
        
        beforeEach(^{
            invalidateHeader = YES;
            invalidationContext.invalidateHeader = invalidateHeader;
        });
    });
});

SPEC_END
