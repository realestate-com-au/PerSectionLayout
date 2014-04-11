//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMPerSectionCollectionViewLayout.h"

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
    CGFloat dimension = self.collectionViewSize.width;
    CGSize contentSize = CGSizeZero;

    // global header
    CGRect globalHeaderFrame = self.headerFrame;
    if (!CGRectEqualToRect(globalHeaderFrame, CGRectZero))
    {
        globalHeaderFrame.origin = CGPointZero;
        globalHeaderFrame.size.width = dimension;
        self.headerFrame = globalHeaderFrame;
    }

    contentSize.width = MAX(contentSize.width, CGRectGetWidth(self.headerFrame));
    contentSize.height += CGRectGetHeight(self.headerFrame);

    // first pass, compute all of the frames, ignoring position
    NSArray *layoutSections = self.layoutInfoSections;
	for (AMPerSectionCollectionViewLayoutSection *section in layoutSections)
    {
        CGFloat sectionWidth = section.width;
        section.width = sectionWidth > 0 ? sectionWidth : dimension;
		[section computeLayout:self];
	}

    CGPoint nextOrigin = CGPointMake(0.f, contentSize.height);
    for (AMPerSectionCollectionViewLayoutSection *section in layoutSections)
    {
        CGRect sectionFrame = section.frame;
        
        while (nextOrigin.x + CGRectGetWidth(sectionFrame) > dimension)
        {
            // go to new line
            nextOrigin.y += CGRectGetHeight(section.frame);
            
            // reset x
            AMPerSectionCollectionViewLayoutSection *sectionInMyWay = [self firstSectionAtPoint:CGPointMake(0.f, nextOrigin.y)];
            nextOrigin.x = CGRectGetMaxX(sectionInMyWay.frame);
        }

        sectionFrame.origin = nextOrigin;
        section.frame = sectionFrame;

        contentSize.width = MAX(CGRectGetMaxX(sectionFrame), contentSize.width);
        contentSize.height = MAX(CGRectGetMaxY(sectionFrame), contentSize.height);

        if (CGRectGetMaxX(section.frame) >= dimension)
        {
            // go to new line
            nextOrigin.y = CGRectGetMaxY(section.frame);

            // reset x
            AMPerSectionCollectionViewLayoutSection *sectionInMyWay = [self firstSectionAtPoint:CGPointMake(0.f, nextOrigin.y)];
            nextOrigin.x = CGRectGetMaxX(sectionInMyWay.frame);
        }
        else
        {
            nextOrigin.x = CGRectGetMaxX(section.frame);
            nextOrigin.y = CGRectGetMinY(section.frame);
        }
    }

    // global footer
    CGRect globalFooterFrame =  self.footerFrame;
    if (CGRectGetWidth(globalFooterFrame) > 0)
    {
        globalFooterFrame.origin.x = 0;
        globalFooterFrame.origin.y = contentSize.height;
        globalFooterFrame.size.width = dimension;
        self.footerFrame = globalFooterFrame;
    }

	contentSize.height += CGRectGetHeight(self.footerFrame);
    self.contentSize = contentSize;
}

#pragma mark - UICollectionViewLayoutAttributes

- (UICollectionViewLayoutAttributes *)layoutAttributesForGlobalHeaderInRect:(CGRect)rect withOffset:(CGPoint)offset
{
    CGRect headerFrame = [self stickyHeaderFrameForYOffset:offset.y];

    //FIXME: abstract this, there's points where a reference rect is not required and the method must return something
    if (CGRectEqualToRect(rect, CGRectZero) || (CGRectGetHeight(headerFrame) > 0 && CGRectIntersectsRect(headerFrame, rect)))
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindHeader withIndexPath:indexPath];
		attr.frame = headerFrame;
        attr.zIndex = AMPerSectionCollectionElementAlwaysShowOnTopZIndex;

        return attr;
    }

    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForGlobalFooterInRect:(CGRect)rect withOffset:(CGPoint)offset
{
    CGRect footerFrame = self.footerFrame;

    //FIXME: abstract this, there's points where a reference rect is not required and the method must return something
    if (CGRectEqualToRect(rect, CGRectZero) || (CGRectGetHeight(footerFrame) > 0 && CGRectIntersectsRect(footerFrame, rect)))
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:AMPerSectionCollectionElementKindFooter withIndexPath:indexPath];
		attr.frame = footerFrame;

        return attr;
    }

    return nil;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p contentSize:%@ sections:%@ headerFrame:%@ footerFrame:%@>", NSStringFromClass([self class]), self, NSStringFromCGSize(self.contentSize), self.sections, NSStringFromCGRect(self.headerFrame), NSStringFromCGRect(self.footerFrame)];
}

@end
