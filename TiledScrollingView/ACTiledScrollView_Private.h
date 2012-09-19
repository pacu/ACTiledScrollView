//
//  ACTiledScrollView_Private.h
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/16/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import "ACTiledScrollView.h"

@interface ACTiledScrollView (Private)
-(NSIndexSet*)indexesForTile:(id<TiledViewProtocol>)tile at:(ACTileIndex)position;
-(NSIndexSet*)indexesForTile:(id<TiledViewProtocol>)tile atPosition:(NSUInteger)position;
-(BOOL)tile:(id<TiledViewProtocol>)tile fitsIn:(ACTileIndex)index;
-(BOOL)isTileCompatible:(id<TiledViewProtocol>)tile;

/*
 resizes the tile array to fit the given indexSet. if indexset is within bounds returns the
 received array. If otherwise the array will be copied to a new instance  that can fit the
 lastIndex of the indexSet filling the array with NSNull
 */
-(NSMutableArray*)resizeArray:(NSMutableArray*)array ToFitIndexSet:(NSIndexSet*)indexSet;



-(void)addTile:(id<TiledViewProtocol>)tile at:(ACTileIndex)index;

-(void)rearrange;
@end

@implementation ACTiledScrollView (TestingHelpers)

/*
 DO NOT USE THIS METHOD. TESTING PURPOSES ONLY
 */
-(void)setTileArray:(NSMutableArray*)array {
    
    [_tiles autorelease];
    _tiles = [array retain];
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    
    [self rearrange];
}

/*
 DO NOT USE THIS METHOD. TESTING PURPOSES ONLY
 */
-(NSMutableArray*)tileArray{

    return _tiles;
}

@end
