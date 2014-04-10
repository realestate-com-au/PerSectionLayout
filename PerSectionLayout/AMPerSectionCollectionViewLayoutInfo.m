//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutInfo.h"

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

- (NSObject *)addSection
{
    AMPerSectionCollectionViewLayoutSection *layoutSection = [[AMPerSectionCollectionViewLayoutSection alloc] init];
    [self.sections addObject:layoutSection];
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
        if (CGRectContainsPoint(section.frame, point))
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
            normalizedHeaderFrame.origin.y = yOffset;
        }
        else
        {
            normalizedHeaderFrame.origin.y = CGRectGetMaxY([self sectionAtIndex:lastSectionWithStickyHeader].frame) - CGRectGetHeight(normalizedHeaderFrame);
        }
    }
    
    return normalizedHeaderFrame;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p contentSize:%@ sections:%@ headerFrame:%@ footerFrame:%@>", NSStringFromClass([self class]), self, NSStringFromCGSize(self.contentSize), self.sections, NSStringFromCGRect(self.headerFrame), NSStringFromCGRect(self.footerFrame)];
}

@end
