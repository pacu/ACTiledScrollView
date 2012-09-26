//
//  ACTilePlaceholder.m
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/15/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import "ACTilePlaceholder.h"

@implementation ACTilePlaceholder


static ACTilePlaceholder * instance = nil;


+(ACTilePlaceholder*) sharedPlaceholder {

    if (instance) {
        return instance;
    }
    
    instance = [[ACTilePlaceholder alloc] init];
    
    return instance;
}
+(BOOL)isPlaceholder:(id)object {
    
    return ( [object class]== [self class]);
    
}

-(id)retain {
    return instance;
}

-(id)autorelease {
    return  instance;
}

-(oneway void)release {
    
    
    
}


-(NSUInteger) retainCount {
    return NSUIntegerMax;
}
@end
