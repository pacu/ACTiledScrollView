//
//  TiledScrollingViewTests.h
//  TiledScrollingViewTests
//
//  Created by Francisco Gindre on 9/15/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//
// MIT License
//Permission is hereby granted, free of charge, to any person obtaining
//a copy of this software and associated documentation files (the "Software"),
//to deal in the Software without restriction, including without limitation
//the rights to use, copy, modify, merge, publish, distribute, sublicense,
//and/or sell copies of the Software, and to permit persons to whom the
//Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included
//in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//
#import <SenTestingKit/SenTestingKit.h>
#import "ACTiledScrollView.h"

@interface TiledScrollingViewTests : SenTestCase
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
