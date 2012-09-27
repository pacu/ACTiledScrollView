//
//  TiledScrollingViewTests_Portrait.h
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/27/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
@class ACTiledScrollView;
@interface TiledScrollingViewTests_Portrait : SenTestCase
{
@private
    ACTiledScrollView *_scrollview;
    
    CGSize _tileSize;
}

-(void)testInitWithTileSize;
-(void)testSetVerticalTiles;
-(void)testSetHorizontalTiles;
-(void)testAppendTile;
-(void)testRemoveTile;
-(void)testIndexesForTileAt;
-(void)testIndexesForTileAtPosition;
-(void)testIsTileCompatible;
-(void)testTileFitsIn;
-(void)testResizeArrayToFitIndexSet;
-(void)testBestFit2x2Tile;
-(void)testBestFit1x1Tile;
-(void)testAdd2x2TileAtEmptyView;
-(void)testAdd1x1TileAtEmptyView;
@end
