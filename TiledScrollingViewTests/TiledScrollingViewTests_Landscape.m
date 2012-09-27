//
//  TiledScrollingViewTests.m
//  TiledScrollingViewTests
//
//  Created by Francisco Gindre on 9/15/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import "TiledScrollingViewTests_Landscape.h"
#import "ACTilePlaceholder.h"
#import "ACTileView.h"
#import "ACTiledScrollview_Private.h"

@implementation TiledScrollingViewTests_Landscape

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
    
   
    [_scrollview autorelease];
    _scrollview =nil;
     [super tearDown];
}

- (void)testIsPlaceholder
{
    NSObject *obj = [[[NSObject alloc]init] autorelease];
    
    ACTilePlaceholder *ph = [ACTilePlaceholder sharedPlaceholder];
    
    NSAssert(![ACTilePlaceholder isPlaceholder:obj], @"Object is placeholder when it shouldn't be");
    
    NSAssert([ACTilePlaceholder isPlaceholder:ph], @"Object is not placeholder when it shouldbe");
}


-(void)testInitWithTileSize{
    CGSize size;
    size.width = 256;
    size.height = 192;
    

    ACTiledScrollView *_scroll = [[[ACTiledScrollView alloc]initWithTileSize:size height:1 width:1] autorelease];
    
    NSAssert2(CGSizeEqualToSize(_scroll.frame.size, size), @"Sizes are not equal actual %@  expected:%@", NSStringFromCGSize(_scroll.frame.size), NSStringFromCGSize(size));
    _scroll = [[[ACTiledScrollView alloc]initWithTileSize:size height:2 width:3]autorelease];
    
    CGSize expected = CGSizeMake(size.width *3, size.height *2);
    NSAssert2(CGSizeEqualToSize(_scroll.frame.size,expected), @"Sizes are not equal actual %@  expected:%@", NSStringFromCGSize(_scroll.frame.size), NSStringFromCGSize(expected));
    
}
-(void)testSetVerticalTiles{
    
    [_scrollview setVerticalTiles:4];
    CGSize expected = CGSizeMake(_scrollview.frame.size.width, _tileSize.height *4);
    NSAssert2(CGSizeEqualToSize(_scrollview.frame.size , expected), @"Sizes are not equal actual %@  expected:%@", NSStringFromCGSize(_scrollview.frame.size), NSStringFromCGSize(expected));
    

    
}
-(void)testSetHorizontalTiles{
    [_scrollview setHorizontalTiles:3];
    
    CGSize expected = CGSizeMake(_tileSize.width *3, _scrollview.frame.size.height);
    NSAssert2(CGSizeEqualToSize(_scrollview.frame.size , expected), @"Sizes are not equal actual %@  expected:%@", NSStringFromCGSize(_scrollview.frame.size), NSStringFromCGSize(expected));
}

-(void)testAppend1x1TileToEmptyView{
    
    ACTileView *view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    
    // append 1x1to view that has zero elements
    [_scrollview appendTile:view];
    CGRect expected = CGRectMake(0,0,view.frame.size.width,view.frame.size.height);
    STAssertTrue(CGRectEqualToRect(view.frame, expected),@"When appeding 1x1 tile to empty view, rect should be: %@. Actual frame:%@",expected, view.frame);
    

}

-(void)testAppend2x2TileToEmptyView{
    ACTileView *view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(2, 2)];
    
    // append 1x1to view that has zero elements
    [_scrollview appendTile:view];
    CGRect expected = CGRectMake(0,0,view.frame.size.width,view.frame.size.height);
    STAssertTrue(CGRectEqualToRect(view.frame, expected),@"When appeding 2x2 tile to empty view, rect should be: %@. Actual frame:%@",expected, view.frame);
    
}


-(void)testAppendTile {
    
    // add 2x2 tile to empty view.
    [self testAppend2x2TileToEmptyView];
    
    ACTileView *view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    
    
    // then add a 1x1 tile, if the height is 3,it should be on index 2,1
    [_scrollview appendTile:view];
    
    
    CGRect expected = CGRectMake(_tileSize.width,_tileSize.height*2,view.frame.size.width,view.frame.size.height);
    
    STAssertTrue(CGRectEqualToRect(view.frame, expected),@"When appending the second 1x1 tile to this view, rect should be: %@. Actual frame:%@",NSStringFromCGRect(expected), NSStringFromCGRect(view.frame));

    
    view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    
    // then add a 1x1 tile, if the height is 3,it should be on index 0,2
    [_scrollview appendTile:view];
    
    
    expected =  CGRectMake(_tileSize.width *2 ,0,view.frame.size.width,view.frame.size.height);
    
    STAssertTrue(CGRectEqualToRect(view.frame, expected),@"When appending a third 1x1 tile to this view,, rect should be: %@. Actual frame:%@",NSStringFromCGRect(expected), NSStringFromCGRect(view.frame));
    
    view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    
    // then add a 1x1 tile, if the height is 3,it should be on index 1,2
    [_scrollview appendTile:view];
    
    
    expected =  CGRectMake(_tileSize.width*2,_tileSize.height,view.frame.size.width,view.frame.size.height);
    
    STAssertTrue(CGRectEqualToRect(view.frame, expected),@"When appending a fourth 1x1 tile to this view,, rect should be: %@. Actual frame:%@",NSStringFromCGRect(expected), NSStringFromCGRect(view.frame));
    
    view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    
    // then add a 1x1 tile, if the height is 3,it should be on index 2,2
    [_scrollview appendTile:view];
    
    
    expected =  CGRectMake(_tileSize.width*2,_tileSize.height*2,view.frame.size.width,view.frame.size.height);
    
    STAssertTrue(CGRectEqualToRect(view.frame, expected),@"When appending a fifth 1x1 tile to this view,, rect should be: %@. Actual frame:%@",NSStringFromCGRect(expected), NSStringFromCGRect(view.frame));
    
    
    view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    
    // then add a 1x1 tile, if the height is 3,it should be on index 0,3
    [_scrollview appendTile:view];
    
    
    expected =  CGRectMake(_tileSize.width*3,0,view.frame.size.width,view.frame.size.height);
    
    STAssertTrue(CGRectEqualToRect(view.frame, expected),@"When appending a sixth 1x1 tile to this view,, rect should be: %@. Actual frame:%@",NSStringFromCGRect(expected), NSStringFromCGRect(view.frame));
    
    view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(2, 2)];
    
    // then add a 2x2 tile, if the height is 3 on row 1, column 3. And content size should be
    // Height: _tileSize.height * _scrollview.sizeInTiles.height
    // width: the maximum reach of any of the tiles. When a tile is added the content size should be checked and updated.
    [_scrollview appendTile:view];
    
    
    expected =  CGRectMake(_tileSize.width*3,_tileSize.height,view.frame.size.width,view.frame.size.height);
    
    STAssertTrue(CGRectEqualToRect(view.frame, expected),@"When appending a seventh 1x1 tile to this view, rect should be: %@. Actual frame:%@",NSStringFromCGRect(expected), NSStringFromCGRect(view.frame));
    
    // check if size is correct when adding a tile to the view
    CGSize size;
    
    size = [_scrollview contentSize];
    
    
    CGSize expectedSize = CGSizeMake(expected.origin.x+expected.size.width, _scrollview.frame.size.height);
    STAssertTrue(CGSizeEqualToSize(expectedSize,size),@"size should be the maximum reach of any of the tiles and the current height: %@ actual size: %@", NSStringFromCGSize(expectedSize),NSStringFromCGSize(size));
}
-(void)testRemoveTile{
    
    [self testAppendTile];
    
    NSMutableArray *array = [_scrollview tileArray];
    
    
    ACTileView *v = [array objectAtIndex:0];
    
    
    NSIndexSet *set = [_scrollview indexesForTile:v atPosition:0];
    
    [_scrollview removeTile:0];
    
    [array enumerateObjectsAtIndexes:set options:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
        STAssertEqualObjects([obj class], [NSNull class], @"object at index %u is not NSNull. is:%@",idx,[obj class]);
    }];
        
        
    

}

-(void)testIndexesForTileAt{

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
-(void)testIndexesForTileAtPosition{
    
    ACTileView *invalidView = [[[ACTileView alloc] initWithFrame:CGRectZero] autorelease];
    
    STAssertNil([_scrollview indexesForTile:invalidView atPosition:0], @"CGSizeZero tile should return nil");
    
    [invalidView setTileSize:CGSizeMake(234, 223)];
    STAssertNil([_scrollview indexesForTile:invalidView atPosition:0], @"incompatible tile should return nil");
    
    invalidView = [[[ACTileView alloc] initWithFrame:CGRectZero]autorelease];
    
    [invalidView setTileSize:_tileSize];
    
    [invalidView setSizeInTiles:CGSizeMake(32, 22)];
    
    STAssertNil([_scrollview indexesForTile:invalidView atPosition:0], @"incompatible tile should return nil");
    
    ACTileView *validView = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [validView setTileSize:_tileSize];
    [validView setSizeInTiles:CGSizeMake(2, 1)];
    
    STAssertNotNil([_scrollview indexesForTile:validView atPosition:4],@"valid tile could have been inserted in valid position");
    
    

}
-(void)testIsTileCompatible
{

    // tile is compatible if  CGSizeZero and it's not the same size than receiver's tileSize
    
    ACTileView *invalidView = [[[ACTileView alloc]initWithFrame:CGRectZero]autorelease];
    
    STAssertFalse([_scrollview isTileCompatible:invalidView],@"View should be invalid %@",invalidView);
    
    [invalidView setTileSize:CGSizeMake(123, 11)];
    
    STAssertFalse([_scrollview isTileCompatible:invalidView],@"View should be invalid %@",invalidView);
    
    // check if returns true with adecquate size
    
    
    ACTileView *validView = [[[ACTileView alloc]initWithFrame:CGRectZero]autorelease];
    
    [validView setTileSize:_tileSize];
    
    STAssertTrue([_scrollview isTileCompatible:validView], @"view should be compatible %@",validView);
    

}


-(void)testTileFitsIn{
    ACTileView *invalidView = [[[ACTileView alloc] initWithFrame:CGRectZero]autorelease];
    ACTileView *view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [invalidView setTileSize:_tileSize];
    [invalidView setSizeInTiles:CGSizeMake(5, 2)];
    
    STAssertFalse([_scrollview tile:invalidView fitsIn:ACTileIndexMake(0, 0)], @"Tile of size %@ should not fit in size:%@",NSStringFromCGSize([invalidView sizeInTiles]),NSStringFromCGSize([_scrollview sizeInTiles]));
    
    [invalidView setSizeInTiles:CGSizeMake(1, 5)];
    STAssertFalse([_scrollview tile:invalidView fitsIn:ACTileIndexMake(0, 0)], @"Tile of size %@ should not fit in size:%@",NSStringFromCGSize([invalidView sizeInTiles]),NSStringFromCGSize([_scrollview sizeInTiles]));
    
    // test a valid view. in a ACTiledScrollView of 3x4 tiles put a 2x2 at 0,0
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(2, 2)];

      STAssertTrue([_scrollview tile:view fitsIn:ACTileIndexMake(0, 0)], @"Tile of size %@ should not fit in size:%@",NSStringFromCGSize([view sizeInTiles]),NSStringFromCGSize([_scrollview sizeInTiles]));
}
-(void)testResizeArrayToFitIndexSet{

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:12];
    
    for (NSUInteger idx; idx<12; idx++) {
        [array addObject:[NSNull null]];
    }
    // pass an index set that makes the method return the same instance
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    
    [indexSet addIndex:7];
    [indexSet addIndex:8];
    [indexSet addIndex:10];
    [indexSet addIndex:11];
    
    NSMutableArray *sameArray = [_scrollview resizeArray:array ToFitIndexSet:indexSet];
    
    STAssertTrue(array == sameArray, @"arrays should be the same expected: %@, actual: %@", array,sameArray);
    
    
    // extend the array to fit a 2x3 tile  at index 1,3
    
    
    indexSet = [NSMutableIndexSet indexSetWithIndex:10];
    [indexSet addIndex:11];
    [indexSet addIndex:13];
    [indexSet addIndex:14];
    [indexSet addIndex:16];
    [indexSet addIndex:17];
    
    
    NSMutableArray *newArray = [_scrollview resizeArray:array ToFitIndexSet:indexSet];
    
    STAssertNotNil(newArray, @"the array should not be nil");
    
    STAssertTrue([newArray count]>= [indexSet lastIndex],@"new array item count should be >= the last index in the set. count: %d  lastIndex: %d",[newArray count], [indexSet lastIndex]);
    

}
-(void)testAdd1x1TileAtEmptyView{
    
    
    ACTileView *view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    NSAssert2(CGSizeEqualToSize(view.frame.size, _tileSize), @"Sizes are not equal actual %@  expected:%@", NSStringFromCGSize(view.frame.size), NSStringFromCGSize(view.frame.size));
    
    
    ACTileView *invalidView = [[[ACTileView alloc] initWithFrame:CGRectZero]autorelease];
    
    
    STAssertThrows([_scrollview addTile:invalidView at:ACTileIndexMake(0, 0)] , @"exception not thrown when incompatible view was added");
     
    [_scrollview addTile:view at:ACTileIndexMake(0, 0)];
    
    STAssertTrue(CGRectEqualToRect([view frame], CGRectMake(0, 0, _tileSize.width,_tileSize.height)), @"View was not added with the correct frame. Actual: %@, Expected:%@", NSStringFromCGRect([view frame]), NSStringFromCGRect(CGRectMake(0, 0, _tileSize.width,_tileSize.height)));
    
    
    [_scrollview addTile:view at:ACTileIndexMake(0, 1)];
    
    STAssertTrue(CGRectEqualToRect([view frame], CGRectMake(_tileSize.width, 0, _tileSize.width,_tileSize.height)), @"View was not added with the correct frame. Actual: %@, Expected:%@", NSStringFromCGRect([view frame]), NSStringFromCGRect(CGRectMake(_tileSize.width, 0, _tileSize.width,_tileSize.height)));
    
    [_scrollview addTile:view at:ACTileIndexMake(1, 0)];
    
    STAssertTrue(CGRectEqualToRect([view frame], CGRectMake(0, _tileSize.height, _tileSize.width,_tileSize.height)), @"View was not added with the correct frame. Actual: %@, Expected:%@", NSStringFromCGRect([view frame]), NSStringFromCGRect(CGRectMake(0,_tileSize.height, _tileSize.width,_tileSize.height)));
    
    [_scrollview addTile:view at:ACTileIndexMake(1, 1)];
    
    STAssertTrue(CGRectEqualToRect([view frame], CGRectMake(_tileSize.width, _tileSize.height, _tileSize.width,_tileSize.height)), @"View was not added with the correct frame. Actual: %@, Expected:%@", NSStringFromCGRect([view frame]), NSStringFromCGRect(CGRectMake(0,_tileSize.height, _tileSize.width,_tileSize.height)));

}

-(void)testAdd2x2TileAtEmptyView{
    ACTileView *view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(2, 2)];
    
    
    ACTileView *invalidView = [[[ACTileView alloc] initWithFrame:CGRectZero]autorelease];
    
    
    STAssertThrows([_scrollview addTile:invalidView at:ACTileIndexMake(0, 0)] , @"exception not thrown when incompatible view was added");
    
    [_scrollview addTile:view at:ACTileIndexMake(0, 0)];
    
    STAssertTrue(CGRectEqualToRect([view frame], CGRectMake(0, 0, _tileSize.width*2,_tileSize.height*2)), @"View was not added with the correct frame. Actual: %@, Expected:%@", NSStringFromCGRect([view frame]), NSStringFromCGRect(CGRectMake(0, 0, _tileSize.width,_tileSize.height)));
    
    [_scrollview addTile:view at:ACTileIndexMake(0, 1)];
    
    STAssertTrue(CGRectEqualToRect([view frame], CGRectMake(view.frame.size.width, 0, view.frame.size.width,view.frame.size.height)), @"View was not added with the correct frame. Actual: %@, Expected:%@", NSStringFromCGRect([view frame]), NSStringFromCGRect(CGRectMake(_tileSize.width, 0, _tileSize.width,_tileSize.height)));
    
    [_scrollview addTile:view at:ACTileIndexMake(1, 0)];
    
    STAssertTrue(CGRectEqualToRect([view frame], CGRectMake(1024, 0, view.frame.size.width,view.frame.size.height)), @"View was not added with the correct frame. Actual: %@, Expected:%@", NSStringFromCGRect([view frame]), NSStringFromCGRect(CGRectMake(0,_tileSize.height, _tileSize.width,_tileSize.height)));
    
    [_scrollview addTile:view at:ACTileIndexMake(1, 1)];
    
    STAssertTrue(CGRectEqualToRect([view frame], CGRectMake(1536, 0, view.frame.size.width,view.frame.size.height)), @"View was not added with the correct frame. Actual: %@, Expected:%@", NSStringFromCGRect([view frame]), NSStringFromCGRect(CGRectMake(1536, 0, view.frame.size.width,view.frame.size.height)));
    
    
}

/** 
 Make an array that has [2x2Tile,ph, 1x1Tile, ph, ph, NSNull,1x1Tile,NSNull,NSNull,NSNull,NSNull,NSNull] and test best fit for it. it should add the tile to index 5
 */
-(void)testBestFit1x1Tile {
    
    
    NSMutableArray *array = [[[NSMutableArray alloc]initWithCapacity:12] autorelease];
    
    for (NSUInteger i=0; i<12; i++) {
        [array addObject:[NSNull null]];
    }
    ACTileView *view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(2, 2)];
    
    [array replaceObjectAtIndex:0 withObject:view];
    
    [array replaceObjectAtIndex:1 withObject:[ACTilePlaceholder sharedPlaceholder]];

    // 1x1 tile
    view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    [array replaceObjectAtIndex:2 withObject:view];
    
    [array replaceObjectAtIndex:3 withObject:[ACTilePlaceholder sharedPlaceholder]];
    [array replaceObjectAtIndex:4 withObject:[ACTilePlaceholder sharedPlaceholder]];
    
    //another 1x1 tile
    // 1x1 tile
    view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    [array replaceObjectAtIndex:6 withObject:view];

    [_scrollview setTileArray:array];
    
    view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    [_scrollview addTile:view at:ACTileIndexMake(0, 0)];
    
    NSMutableArray *newArray = [_scrollview tileArray];
    
    STAssertEqualObjects([newArray objectAtIndex:5], view, @"BestFit algorithm did not place the tile object %@ at index 5 as expected",view);
    

    
}

/**
 Make an array that has [1x1Tile,NSNull,1x1Tile, NSNull, NSNull, 1x1Tile,NSNull,NSNull,1x1Tile,NSNull,NSNull,NSNull] and test best fit for it. it should add the tile to index 5
 */
-(void)testBestFit2x2Tile {
    NSMutableArray *array = [[[NSMutableArray alloc]initWithCapacity:12] autorelease];
    
    for (NSUInteger i=0; i<12; i++) {
        [array addObject:[NSNull null]];
    }
    ACTileView *view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    
    [array replaceObjectAtIndex:0 withObject:view];
    

    
    // 1x1 tile
    view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    [array replaceObjectAtIndex:2 withObject:view];
    
    
    //another 1x1 tile
    // 1x1 tile
    view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(1, 1)];
    [array replaceObjectAtIndex:5 withObject:view];
    
    [_scrollview setTileArray:array];
    
    view = [[[ACTileView alloc]initWithFrame:CGRectZero] autorelease];
    
    [view setTileSize:_tileSize];
    [view setSizeInTiles:CGSizeMake(2, 2)];
    [_scrollview addTile:view at:ACTileIndexMake(0, 0)];
    
    NSMutableArray *newArray = [_scrollview tileArray];
    
    STAssertEqualObjects([newArray objectAtIndex:3], view, @"BestFit algorithm did not place the tile object %@ at index 3 as expected",view);
    
    
}

-(void)testFrameForTileAtIndex {
    
    CGRect actual;
    CGRect expected;
    
    // 2x2 tile at index 0,0
    ACTileView *tile = [[ACTileView alloc] initWithFrame:CGRectZero];
    [tile setTileSize:_tileSize];
    [tile setSizeInTiles:CGSizeMake(2, 2)];
    actual = [_scrollview frameForTile:tile atIndex:ACTileIndexMake(0, 0)];
    expected =CGRectMake(0, 0, _tileSize.width * 2, _tileSize.height *2);
    
    STAssertTrue(CGRectEqualToRect(actual, expected), @"size for inserting 2x2 tile at 0,0 should be: %@. Actual: %@",NSStringFromCGRect(expected),NSStringFromCGRect(actual));
    
    // 2x2 tile at index 1,1
    actual = [_scrollview frameForTile:tile atIndex:ACTileIndexMake(1, 1)];
    expected = CGRectMake(_tileSize.width, _tileSize.height, _tileSize.width * 2, _tileSize.height *2);
    
    STAssertTrue(CGRectEqualToRect(actual, expected), @"size for inserting 2x2 tile at 1,1 should be: %@. Actual: %@",NSStringFromCGRect(expected),NSStringFromCGRect(actual));
    
    // 2x2 tile at index 1,2
    actual = [_scrollview frameForTile:tile atIndex:ACTileIndexMake(1, 2)];
    expected = CGRectMake(_tileSize.width *2, _tileSize.height, _tileSize.width * 2, _tileSize.height *2);
    
    STAssertTrue(CGRectEqualToRect(actual, expected), @"size for inserting 2x2 tile at 1,2 should be: %@. Actual: %@",NSStringFromCGRect(expected),NSStringFromCGRect(actual));
    
    // 3x3 tile at index 0,0
    [tile setSizeInTiles:CGSizeMake(3, 3)];

    actual = [_scrollview frameForTile:tile atIndex:ACTileIndexMake(0, 0)];
    expected = CGRectMake(0, 0, _tileSize.width * 3, _tileSize.height *3);
    
    STAssertTrue(CGRectEqualToRect(actual, expected), @"size for inserting 2x2 tile at 1,2 should be: %@. Actual: %@",NSStringFromCGRect(expected),NSStringFromCGRect(actual));
    
    [tile setSizeInTiles:CGSizeMake(1, 1)];

    actual = [_scrollview frameForTile:tile atIndex:ACTileIndexMake(1, 1)];
    expected = CGRectMake(_tileSize.width, _tileSize.height, _tileSize.width, _tileSize.height);
    
    STAssertTrue(CGRectEqualToRect(actual, expected), @"size for inserting 1x1 tile at 1,1 should be: %@. Actual: %@",NSStringFromCGRect(expected),NSStringFromCGRect(actual));
}

@end
