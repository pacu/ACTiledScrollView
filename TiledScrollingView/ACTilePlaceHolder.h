//
//  ACTilePlaceholder.h
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/15/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACTilePlaceholder : NSObject
+(ACTilePlaceholder*) sharedPlaceholder;
+(BOOL)isPlaceholder:(id)object;
@end
