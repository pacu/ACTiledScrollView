//
//  TiledScrollingViewTests.m
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
#import "TiledScrollingViewTests.h"
#import "ACTilePlaceholder.h"
#import "ACTileView.h"
#import "ACTiledScrollview_Private.h"

@implementation TiledScrollingViewTests

- (void)setUp
{
    [super setUp];
    CGSize size;
    size.width = 256;
    size.height = 192;
    _tileSize = size;
    _scrollview = [[ACTiledScrollView alloc]initWithTileSize:size height:3 width:4];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    [_scrollview autorelease];
    _scrollview =nil;
}

- (void)testExample
{
    NSObject *obj = [[[NSObject alloc]init] autorelease];
    
    ACTilePlaceholder *ph = [ACTilePlaceholder sharedPlaceholder];
    
    NSAssert(![ACTilePlaceholder isPlaceholder:obj], @"Object is placeholder when it shouldn't be");
    
    NSAssert([ACTilePlaceholder isPlaceholder:ph], @"Object is not placeholder when it shouldbe");
}


-(void)testInitWithTileSizeTest{
    CGSize size;
    size.width = 256;
    size.height = 192;
    

    ACTiledScrollView *_scroll = [[[ACTiledScrollView alloc]initWithTileSize:size height:1 width:1] autorelease];
    
    NSAssert2(CGSizeEqualToSize(_scroll.frame.size, size), @"Sizes are not equal actual %@  expected:%@", NSStringFromCGSize(_scroll.frame.size), NSStringFromCGSize(size));
    _scroll = [[[ACTiledScrollView alloc]initWithTileSize:size height:2 width:3]autorelease];
    
    CGSize expected = CGSizeMake(size.width *3, size.height *2);
    NSAssert2(CGSizeEqualToSize(_scroll.frame.size,expected), @"Sizes are not equal actual %@  expected:%@", NSStringFromCGSize(_scroll.frame.size), NSStringFromCGSize(expected));
    
}
-(void)testSetVerticalTilesTest{
    
    [_scrollview setVerticalTiles:4];
    CGSize expected = CGSizeMake(_scrollview.frame.size.width, _tileSize.height *4);
    NSAssert2(CGSizeEqualToSize(_scrollview.frame.size , expected), @"Sizes are not equal actual %@  expected:%@", NSStringFromCGSize(_scrollview.frame.size), NSStringFromCGSize(expected));
    

    
}
-(void)testSetHorizontalTilesTest{
    [_scrollview setHorizontalTiles:3];
    
    CGSize expected = CGSizeMake(_tileSize.width *3, _scrollview.frame.size.height);
    NSAssert2(CGSizeEqualToSize(_scrollview.frame.size , expected), @"Sizes are not equal actual %@  expected:%@", NSStringFromCGSize(_scrollview.frame.size), NSStringFromCGSize(expected));
}

-(void)testAppendTileTest{}
-(void)testRemoveTileTest{}
-(void)testAllTilesTest{}
-(void)testIndexesForTileAtTest{

    ACTileView *view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    
    /**
     test if sizes are compatible
     */
    STAssertTrue(CGSizeEqualToSize(view.frame.size, _tileSize), @"Sizes are not equal actual %@  expected:%@", NSStringFromCGSize(view.frame.size), NSStringFromCGSize(view.frame.size));
    
    
    ACTileView *invalidView = [[[ACTileView alloc] initWithFrame:CGRectZero]autorelease];
    
    
    /**
     test if returns nil when tile is invalid
     */
    STAssertNil([_scrollview indexesForTile:invalidView at:ACTileIndexMake(0, 0)], @"Invalid view should return nil");
    
    
    
    /**
     get indexSet for a 2x3 tile inserted to tile index 0,0
     
     */
    NSIndexSet * indexSet = [_scrollview indexesForTile:view at:ACTileIndexMake(0, 0)];
 
    
    NSMutableString *expStr = [[[NSMutableString alloc]initWithCapacity:10] autorelease];
     NSMutableString *idxStr = [[[NSMutableString alloc]initWithCapacity:10] autorelease];
    
    STAssertNotNil(indexSet, @"index set should not be nil when view is valid. indexSetIs:%@",idxStr);
    
    // size is 1x1 index is 0,0. Index set should be [0]
    
    NSMutableIndexSet *expectedSet = [[[NSMutableIndexSet alloc]initWithIndex:0]autorelease];
   
    
    STAssertTrue([indexSet isEqualToIndexSet:expectedSet], @"index set should be [0]");
    
    /********
     test indexSet for possible insertion of 2x3 tile at index 0,0
     ********/
    
    [view setSizeInTiles:CGSizeMake(3,2)];
    
    indexSet = [_scrollview indexesForTile:view at:ACTileIndexMake(0, 0)];
    
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        [idxStr appendFormat:@"%u,",idx];
    }];
    
    
    
    expectedSet = [[[NSMutableIndexSet alloc]initWithIndex:0] autorelease];
    [expectedSet addIndex:1];
    [expectedSet addIndex:3];
    [expectedSet addIndex:4];
    [expectedSet addIndex:6];
    [expectedSet addIndex:7];
    
    [expectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        [expStr appendFormat:@"%u,",idx];
    }];
    
      
    STAssertTrue([indexSet isEqualToIndexSet:expectedSet], @"index set should be %@ when tile is 2x3 and tile index 0,0 Actual:%@",expStr,idxStr);
}
-(void)testIndexesForTileAtPositionTest{}
-(void)testIsTileCompatibleTest{}


-(void)testTileFitsInTest{
    ACTileView *invalidView = [[[ACTileView alloc] initWithFrame:CGRectZero]autorelease];
    ACTileView *view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    
}
-(void)testResizeArrayToFitIndexSet{}
-(void)testAddTileAt{
    
    
    ACTileView *view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    NSAssert2(CGSizeEqualToSize(view.frame.size, _tileSize), @"Sizes are not equal actual %@  expected:%@", NSStringFromCGSize(view.frame.size), NSStringFromCGSize(view.frame.size));
    
    
    ACTileView *invalidView = [[[ACTileView alloc] initWithFrame:CGRectZero]autorelease];
    
    
    STAssertThrows([_scrollview addTile:invalidView at:ACTileIndexMake(0, 0)] , @"exception not thrown when incompatible view was added");
    
    
}
@end
