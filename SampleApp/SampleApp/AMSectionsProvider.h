//.
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSectionController.h"

@interface AMSectionsProvider : NSObject

- (void)addSectionControllerForClass:(Class<AMSectionController>)sectionControllerClass;
- (void)registerCustomElementsForCollectionView:(UICollectionView *)collectionView;
- (id<AMSectionController>)controllerForSection:(NSInteger)section;
- (NSUInteger)sectionControllersCount;

@end
