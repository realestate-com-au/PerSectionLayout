//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutAttributes.h"

@implementation AMPerSectionCollectionViewLayoutAttributes

- (BOOL)isEqual:(AMPerSectionCollectionViewLayoutAttributes *)object
{
    BOOL isEqual = [super isEqual:object];
    return (isEqual && CGPointEqualToPoint(self.adjustmentOffset, object.adjustmentOffset));
}

- (id)copyWithZone:(NSZone *)zone
{
    AMPerSectionCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.adjustmentOffset = self.adjustmentOffset;
    
    return attributes;
}

@end
