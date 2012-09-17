//
//  ACTiledScrollView.h
//  TiledScrollingView
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
#import <UIKit/UIKit.h>


typedef struct _tileIndex {
    NSUInteger row;
    NSUInteger col;
} ACTileIndex;


ACTileIndex ACTileIndexMake(NSUInteger row, NSUInteger col);

@protocol TiledViewProtocol <NSObject>

-(CGSize)sizeInTiles;
-(CGSize)tileSize;
-(UIView*) tileView;
-(void)setTileSize:(CGSize)tileSize;
-(void)setSizeInTiles:(CGSize)sizeInTiles;
-(ACTileIndex)tileIndex;
-(void)setTileIndex:(ACTileIndex)index;

@end



@protocol TiledViewDatasourceProtocol <NSObject>

-(id<TiledViewProtocol>)tileAtIndex:(ACTileIndex)index;
-(void)willRemove:(id<TiledViewProtocol>)tile atIndex:(ACTileIndex)index;




@end
@interface ACTiledScrollView : UIScrollView <UIScrollViewDelegate> {
    
    @private
    CGSize _tileSize;
    NSUInteger _hTiles;
    NSUInteger _vTiles;
    NSMutableArray *_tiles;
    NSUInteger _minHeight;

}

@property (nonatomic, setter = setMinHeight:) NSUInteger minHeight;
@property (nonatomic, setter = setVerticalTiles:) NSUInteger verticalTiles;
@property (nonatomic, setter = setHorizontalTiles:) NSUInteger horizontalTiles;
@property (nonatomic, readonly) CGPoint origin;


-(id)initWithTileSize:(CGSize)tileSize height:(NSUInteger)vTiles width:(NSUInteger)hTiles;

/**
 Sets the horizontal dimension of the view in tiles. does not affect origin of the frame rect
 */

-(void)horizontalTiles:(NSUInteger)hTiles;

/**
 Sets the vertical dimension of the view in tiles. does not affect origin of the frame rect
 */

-(void)verticalTiles:(NSUInteger)vTiles;


/**
 adds a tile to the view into beginning at the desired tile. If it does not fit in it will be added with a best fit criteria
 */

-(void)addTile:(id<TiledViewProtocol>)tile at:(ACTileIndex)index;

/**
 adds a tile to the view to the tail of the content with best fit criteria
 */

-(void)appendTile:(id<TiledViewProtocol>)tile;
/** 
 removes the desired tile from the view using the supplied block to compare the view;
 */
-(void)removeTile:(id<TiledViewProtocol>)view compareBlock:(BOOL(^)(id obj, NSUInteger idx, BOOL *stop))block rearrange:(BOOL)yesOrNo;

/**
 removes the tile from the given position. ignores the call if it does not exist of if it's a placeholder
 */
-(void)removeTile:(NSUInteger)position;

/** 
 returns all the tiles in this tiled view
 */
-(NSArray*)allTiles;

@end
