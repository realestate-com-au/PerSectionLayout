//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "AMPerSectionCollectionViewLayoutInfo.h"

@interface AMPerSectionCollectionViewLayoutInfo ()
@property (nonatomic, assign) BOOL isInvalid;
@property (nonatomic, strong) NSMutableArray *sections;
@end

@implementation AMPerSectionCollectionViewLayoutInfo

- (id)init
{
    self = [super init];
    if (self)
    {
        _sections = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Sections

- (NSArray *)layoutInfoSections
{
    return [self.sections copy];
}

- (NSObject *)addSection
{
    NSObject *layoutSection = [[NSObject alloc] init];
    [self.sections addObject:layoutSection];
    [self invalidate];
    
    return layoutSection;
}

- (void)invalidate
{
    self.isInvalid = YES;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p contentSize:%@ sections:%@ headerFrame:%@ footerFrame:%@>", NSStringFromClass([self class]), self, NSStringFromCGSize(self.contentSize), self.sections, NSStringFromCGRect(self.headerFrame), NSStringFromCGRect(self.footerFrame)];
}

@end
