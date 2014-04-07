//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import Foundation;
@class AMPerSectionCollectionViewLayoutRow;

@interface AMPerSectionCollectionViewLayoutItem : NSObject
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, weak) AMPerSectionCollectionViewLayoutRow *row;
@end
