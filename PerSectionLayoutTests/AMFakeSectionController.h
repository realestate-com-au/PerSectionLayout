//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import Foundation;
#import "AMSectionController.h"

@interface AMFakeSectionController : NSObject <AMSectionController>

+ (NSInteger)fakeSection;

@property (nonatomic, assign) NSInteger numberOfSections;
@property (nonatomic, assign) NSInteger numberOfItemsInSection;

@end
