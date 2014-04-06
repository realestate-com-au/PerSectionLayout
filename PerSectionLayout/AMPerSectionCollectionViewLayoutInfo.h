//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import Foundation;
#import "AMPerSectionCollectionViewLayoutSection.h"

@interface AMPerSectionCollectionViewLayoutInfo : NSObject

- (NSArray *)layoutInfoSections;
- (AMPerSectionCollectionViewLayoutSection *)addSection;
- (void)invalidate;

@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGSize collectionViewSize;
@property (nonatomic, assign) CGRect headerFrame;
@property (nonatomic, assign) CGRect footerFrame;

@end
