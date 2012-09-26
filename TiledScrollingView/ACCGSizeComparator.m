//
//  ACCGSizeCoparator.m
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/15/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import "ACCGSizeComparator.h"

@implementation ACCGSizeComparator



+(NSComparisonResult) compareSize:(CGSize)size1 to:(CGSize)size2 {
    
    
    if (CGSizeEqualToSize(size1, size2))
        return NSOrderedSame;
    CGRect sizeRect1 = CGRectMake(0, 0, size1.width, size1.height);
    CGRect sizeRect2 = CGRectMake(0, 0, size2.width, size2.height);
    
    //if rect 1 contains rect 2 means that that rect 1 is bigger that rect2
    
    if (CGRectContainsRect(sizeRect1, sizeRect2))
        return NSOrderedDescending;
    
    if (CGRectContainsRect(sizeRect2, sizeRect1))
        return NSOrderedAscending;
    

    return NSOrderedSame;
}
@end
