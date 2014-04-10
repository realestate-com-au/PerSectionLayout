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
            normalizedHeaderFrame.origin.y = yOffset;
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
    CGSize contentSize = CGSizeZero;

    // global header
    CGRect globalHeaderFrame = self.headerFrame;
    if (CGRectGetWidth(globalHeaderFrame) > 0)
    {
        globalHeaderFrame.size.width = self.collectionViewSize.width;
        self.headerFrame = globalHeaderFrame;
    }

    contentSize.width = MAX(contentSize.width, CGRectGetWidth(self.headerFrame));
    contentSize.height += CGRectGetHeight(self.headerFrame);

    // first pass, compute all of the frames, ignoring position
	for (AMPerSectionCollectionViewLayoutSection *section in self.layoutInfoSections)
    {
        CGFloat sectionWidth = section.width;
        //FIXME: JC - I don't like this NAN
        section.width = (isnan(sectionWidth)) ? self.collectionViewSize.width : sectionWidth;
        //FIXME: Unused layoutInfo in computeLayout
		[section computeLayout:self];

        CGRect sectionFrame = section.frame;

        CGRect headerFrame = section.headerFrame;
        if (CGRectGetHeight(headerFrame) > 0)
        {
            headerFrame.size.width = CGRectGetWidth(sectionFrame);
            section.headerFrame = headerFrame;
        }

        CGRect footerFrame = section.footerFrame;
        if (CGRectGetHeight(footerFrame) > 0)
        {
            footerFrame.size.width = CGRectGetWidth(sectionFrame);
            section.footerFrame = footerFrame;
        }
	}

    CGPoint nextOrigin = CGPointMake(0.f, contentSize.height);
    for (AMPerSectionCollectionViewLayoutSection *section in self.layoutInfoSections)
    {
        CGRect sectionFrame = section.frame;

        sectionFrame.origin = nextOrigin;
        section.frame = sectionFrame;

        contentSize.width = MAX(CGRectGetMaxX(sectionFrame), contentSize.width);
        contentSize.height = MAX(CGRectGetMaxY(sectionFrame), contentSize.height);

        if (CGRectGetMaxX(section.frame) >= self.collectionViewSize.width)
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
        globalFooterFrame.size.width = self.collectionViewSize.width;
        self.footerFrame = globalFooterFrame;
    }

	contentSize.height += CGRectGetHeight(self.footerFrame);
    self.contentSize = contentSize;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p contentSize:%@ sections:%@ headerFrame:%@ footerFrame:%@>", NSStringFromClass([self class]), self, NSStringFromCGSize(self.contentSize), self.sections, NSStringFromCGRect(self.headerFrame), NSStringFromCGRect(self.footerFrame)];
}

@end
