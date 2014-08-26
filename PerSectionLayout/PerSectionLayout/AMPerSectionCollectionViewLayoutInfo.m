//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMPerSectionCollectionViewLayout.h"
#import "AMPerSectionCollectionViewLayoutAttributes.h"

@interface AMPerSectionCollectionViewLayoutInfo ()

@property (nonatomic, strong) NSMutableArray *sections;
@end

@implementation AMPerSectionCollectionViewLayoutInfo

- (id)init
{
  self = [super init];
  if (self)
  {
    _sections = [NSMutableArray array];
    [self invalidate];
  }

  return self;
}

- (void)invalidate
{
  self.valid = NO;
}

#pragma mark - Sections

- (NSArray *)layoutInfoSections
{
  return [self.sections copy];
}

- (NSInteger)lastSectionIndex
{
  return MAX(0, ((NSInteger)self.sections.count - 1));
}

- (NSObject *)addSection
{
  AMPerSectionCollectionViewLayoutSection *layoutSection = [[AMPerSectionCollectionViewLayoutSection alloc] init];
  [self.sections addObject:layoutSection];
  layoutSection.index = (NSInteger)[self.sections indexOfObject:layoutSection];

  [self invalidate];

  return layoutSection;
}

- (AMPerSectionCollectionViewLayoutSection *)sectionAtIndex:(NSInteger)section
{
  if (section >= (NSInteger)self.layoutInfoSections.count)
  {
    return nil;
  }

  if (section < 0 || section >= (NSInteger)self.layoutInfoSections.count)
  {
    return nil;
  }

  return self.layoutInfoSections[(NSUInteger)section];
}

- (AMPerSectionCollectionViewLayoutSection *)firstSectionAtPoint:(CGPoint)point
{
  for (AMPerSectionCollectionViewLayoutSection *section in self.sections)
  {
    if (!CGPointEqualToPoint(section.frame.origin, CGPointZero) && CGRectContainsPoint(section.frame, point))
    {
      return section;
    }
  }

  return nil;
}

- (NSInteger)firstSectionIndexBelowHeaderForYOffset:(CGFloat)yOffset
{
  AMPerSectionCollectionViewLayoutSection *firstSection = [self firstSectionAtPoint:CGPointMake(0.f, yOffset + CGRectGetMaxY(self.headerFrame))];

  NSInteger firstSectionIndex = (NSInteger)[self.layoutInfoSections indexOfObject:firstSection];
  if (firstSectionIndex == NSNotFound)
  {
    firstSectionIndex = 0;
  }

  return firstSectionIndex;
}

#pragma mark - Items

- (AMPerSectionCollectionViewLayoutItem *)itemAtIndexPath:(NSIndexPath *)indexPath
{
  AMPerSectionCollectionViewLayoutSection *section = [self sectionAtIndex:indexPath.section];
  if (indexPath.item >= (NSInteger)section.layoutSectionItems.count)
  {
    return nil;
  }

  return section.layoutSectionItems[(NSUInteger)indexPath.item];
}

#pragma mark - Sticky Header

- (CGRect)stickyHeaderFrameForYOffset:(CGFloat)yOffset
{
  CGRect normalizedHeaderFrame = self.headerFrame;

  if (self.hasStickyHeader)
  {
    NSInteger lastSectionWithStickyHeader = self.lastSectionWithStickyHeader;
    if ([self firstSectionIndexBelowHeaderForYOffset:yOffset] <= lastSectionWithStickyHeader)
    {
      normalizedHeaderFrame.origin.y = yOffset + CGRectGetMinY(normalizedHeaderFrame);
    }
    else
    {
      normalizedHeaderFrame.origin.y = CGRectGetMaxY([self sectionAtIndex:lastSectionWithStickyHeader].frame) - CGRectGetHeight(normalizedHeaderFrame);
    }
  }

  return normalizedHeaderFrame;
}

#pragma mark - Layout Calculation

- (void)updateItemsLayout
{
  self.contentSize = CGSizeZero;

  [self updateHeaderLayout];
  [self updateSectionsLayout];
  [self updateFooterLayout];
}

- (void)updateHeaderLayout
{
  CGRect globalHeaderFrame = self.headerFrame;
  if (!CGRectEqualToRect(globalHeaderFrame, CGRectZero))
  {
    globalHeaderFrame.origin = CGPointZero;
    globalHeaderFrame.size.width = self.collectionViewSize.width;
    self.headerFrame = globalHeaderFrame;
  }

  [self updateContentSizeWithNewFrame:self.headerFrame];
}

- (void)updateSectionsLayout
{
  [self updateSectionsSize];
  [self updateSectionsOrigin];
}

- (void)updateSectionsOrigin
{
  // Remember all the origin candidates for place the section later, every time after a section placed, put its right top and left bottom
  NSMutableArray *availableOrigins = [NSMutableArray array];
  [availableOrigins addObject:[NSValue valueWithCGPoint:CGPointMake(0.f, self.contentSize.height)]];

  // Remember the section already been placed to the right position
  NSMutableArray *placedSections = [NSMutableArray array];

  for (AMPerSectionCollectionViewLayoutSection *section in self.layoutInfoSections)
  {
    CGRect sectionFrame = section.frame;
    NSValue *legalOriginValue = [self findLegalOriginFromAvailableOrigins:availableOrigins forFrame:sectionFrame placedSections:placedSections];;
    
    if (legalOriginValue)
    {
      sectionFrame.origin = [legalOriginValue CGPointValue];
      section.frame = sectionFrame;
      [self updateContentSizeWithNewFrame:sectionFrame];
      [placedSections addObject:section];
      [self updateAvailableOrigins:availableOrigins withOldOrigin:legalOriginValue newSection:section];
      
    }
  }
}

- (NSValue *)findLegalOriginFromAvailableOrigins:(NSMutableArray *)availableOrigins forFrame:(CGRect)frame placedSections:(NSMutableArray *)placedSections
{
  for (NSValue *originValue in availableOrigins)
  {
    frame.origin = [originValue CGPointValue];

    if ([self isFrameLegal:frame withSections:placedSections])
    {
      return originValue;
    }
  }
  return nil;
}

- (void)updateAvailableOrigins:(NSMutableArray *)availableOrigins withOldOrigin:(NSValue *)oldOrigin newSection:(AMPerSectionCollectionViewLayoutSection *)section
{
  // Remove old origin
  [availableOrigins removeObject:oldOrigin];

  // Add section right top as origin
  CGFloat sectionRight = CGRectGetMaxX(section.frame);
  // If section right already hit the right edge, ignore the right top
  if (sectionRight < self.collectionViewSize.width)
  {
    [availableOrigins addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(section.frame), CGRectGetMinY(section.frame))]];
  }
  // Add section left bottom as origin
  [availableOrigins addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(section.frame), CGRectGetMaxY(section.frame))]];

  // Sort the origins by the top value
  [availableOrigins sortUsingComparator:^NSComparisonResult(NSValue *originValue1, NSValue *originValue2) {
    return [@([originValue1 CGPointValue].y) compare:@([originValue2 CGPointValue].y)];
  }];
}

- (BOOL)isFrameLegal:(CGRect)sectionFrame withSections:(NSMutableArray *)placedSections
{
  BOOL isSectionFrameLegal;
  if (CGRectGetMaxX(sectionFrame) > self.collectionViewSize.width)
  {
    isSectionFrameLegal = NO;
  }
  else if (CGRectIsEmpty(sectionFrame))
  {
    isSectionFrameLegal = YES;
  }
  else
  {
    isSectionFrameLegal = [self isFrameDetached:sectionFrame withSections:placedSections];
  }
  return isSectionFrameLegal;
}

- (BOOL)isFrameDetached:(CGRect)sectionFrame withSections:(NSMutableArray *)placedSections
{
// Test if the this section intersect with any of the existing sections
  BOOL isDetached = YES;
  NSEnumerator *placedSectionsEnumerator = [placedSections objectEnumerator];
  AMPerSectionCollectionViewLayoutSection *placedSection = nil;
  while (isDetached && (placedSection = [placedSectionsEnumerator nextObject]))
  {
    CGRect existFrame = placedSection.frame;
    isDetached = CGRectIsEmpty(existFrame) || !CGRectIntersectsRect(sectionFrame, existFrame);
  }
  return isDetached;
}

- (void)updateSectionsSize
{
// first pass, compute all of the frames, ignoring position
  for (AMPerSectionCollectionViewLayoutSection *section in self.layoutInfoSections)
  {
    CGFloat sectionWidth = section.width;
    section.width = (isnan(sectionWidth)) ? self.collectionViewSize.width : sectionWidth;
    [section computeLayout:self];
  }
}

- (void)updateFooterLayout
{
  CGRect globalFooterFrame = self.footerFrame;
  if (CGRectGetHeight(globalFooterFrame) > 0)
  {
    globalFooterFrame.origin.x = 0;
    globalFooterFrame.origin.y = self.contentSize.height;
    globalFooterFrame.size.width = self.collectionViewSize.width;
    self.footerFrame = globalFooterFrame;
  }

  [self updateContentSizeWithNewFrame:self.footerFrame];
}

- (void)updateContentSizeWithNewFrame:(CGRect)frame
{
  CGSize contentSize = self.contentSize;
  contentSize.width = MAX(contentSize.width, CGRectGetMaxX(frame));
  contentSize.height = MAX(contentSize.height, CGRectGetMaxY(frame));
  self.contentSize = contentSize;
}

#pragma mark - UICollectionViewLayoutAttributes

- (UICollectionViewLayoutAttributes *)layoutAttributesForGlobalHeaderWithOffset:(CGPoint)offset
{
  CGRect headerFrame = [self stickyHeaderFrameForYOffset:offset.y];
  if (CGRectGetHeight(headerFrame) > 0)
  {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    AMPerSectionCollectionViewLayoutAttributes *attr = [AMPerSectionCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindHeader withIndexPath:indexPath];
    attr.frame = headerFrame;
    attr.zIndex = AMPerSectionCollectionElementAlwaysShowOnTopZIndex;
    attr.adjustmentOffset = offset;
    return attr;
  }

  return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForGlobalFooterWithOffset:(CGPoint)offset
{
  CGRect footerFrame = self.footerFrame;
  if (CGRectGetHeight(footerFrame) > 0)
  {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    AMPerSectionCollectionViewLayoutAttributes *attr = [AMPerSectionCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindFooter withIndexPath:indexPath];
    attr.frame = footerFrame;
    attr.adjustmentOffset = offset;
    return attr;
  }

  return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath withOffset:(CGPoint)offset
{
  AMPerSectionCollectionViewLayoutSection *section = [self sectionAtIndex:indexPath.section];
  return [section layoutAttributesForItemAtIndexPath:indexPath withOffset:offset];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind withIndexPath:(NSIndexPath *)indexPath withOffset:(CGPoint)offset
{
  AMPerSectionCollectionViewLayoutSection *section = [self sectionAtIndex:indexPath.section];
  return [section layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath withOffset:offset];
}

#pragma mark - NSObject

- (NSString *)description
{
  return [NSString stringWithFormat:@"<%@: %p contentSize:%@ sections:%@ headerFrame:%@ footerFrame:%@>", NSStringFromClass([self class]), self, NSStringFromCGSize(self.contentSize), self.sections, NSStringFromCGRect(self.headerFrame), NSStringFromCGRect(self.footerFrame)];
}

@end
