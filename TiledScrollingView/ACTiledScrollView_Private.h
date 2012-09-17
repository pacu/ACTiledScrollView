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
-(BOOL)tile:(id<TiledViewProtocol>)tile fitsIn:(ACTileIndex)index;
    
@end
