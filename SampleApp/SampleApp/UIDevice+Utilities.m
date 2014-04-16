//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import "UIDevice+Utilities.h"

@implementation UIDevice (Utilities)

- (BOOL)isiPad
{
    return [self userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

@end
