//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutAttributes.h"

@implementation AMPerSectionCollectionViewLayoutAttributes

- (BOOL)isEqual:(AMPerSectionCollectionViewLayoutAttributes *)object
{
  if (self == object) return YES;
  
  if ([object class] == [self class])
  {
    if (!CGPointEqualToPoint(self.adjustmentOffset, object.adjustmentOffset))
    {
      return NO;
    }
  }
  
  return [super isEqual:object];
}

- (id)copyWithZone:(NSZone *)zone
{
  AMPerSectionCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
  attributes.adjustmentOffset = self.adjustmentOffset;
  
  return attributes;
}

@end
