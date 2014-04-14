//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import "UIDevice+Utilities.h"

@implementation UIDevice (Utilities)

- (BOOL)isiPad
{
    return [self userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

@end
