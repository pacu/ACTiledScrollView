//
//  ACCGSizeCoparator.h
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/15/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACCGSizeComparator : NSObject


+(NSComparisonResult) compareSize:(CGSize)size1 to:(CGSize)size2;
@end
