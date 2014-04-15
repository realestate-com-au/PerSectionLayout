//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "UIDevice+iOS7Compatibility.h"

@implementation UIDevice (iOS7Compatibility)

- (BOOL)isPerSectionLayoutRunningOnAtLeastiOS7
{
    return floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1;
}

@end
