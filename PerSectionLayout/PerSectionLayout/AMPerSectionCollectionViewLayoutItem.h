//
//  Copyright (c) 2014 REA Group. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AMPerSectionCollectionViewLayoutRow;

@interface AMPerSectionCollectionViewLayoutItem : NSObject
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) AMPerSectionCollectionViewLayoutRow *row;
@end
