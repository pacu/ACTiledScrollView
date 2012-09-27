//
//  ACTiledScrollView.h
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/15/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.

#import <UIKit/UIKit.h>


typedef struct _tileIndex {
    NSUInteger row;
    NSUInteger col;
} ACTileIndex;


ACTileIndex ACTileIndexMake(NSUInteger row, NSUInteger col);

ACTileIndex tileIndexFromIndex(NSUInteger index, NSUInteger rows);

NSUInteger indexFromTileIndex (ACTileIndex index, NSUInteger rows);

@protocol TiledViewProtocol <NSObject>

@required
-(CGSize)sizeInTiles;
-(CGSize)tileSize;
-(UIView*) tileView;
-(void)setTileSize:(CGSize)tileSize;
-(void)setSizeInTiles:(CGSize)sizeInTiles;
-(ACTileIndex)tileIndex;
-(void)setTileIndex:(ACTileIndex)index;

@optional
-(NSString*)reuseIdentifier;
-(void)setReuseIdentifier:(NSString*)identifier;
-(void)prepareForReuse;
@end



@protocol TiledViewDatasourceProtocol <NSObject>

-(id<TiledViewProtocol>)tileAtIndex:(NSUInteger)index;
-(void)willRemove:(id<TiledViewProtocol>)tile atIndex:(NSUInteger)index;




@end
@interface ACTiledScrollView : UIScrollView <UIScrollViewDelegate> {
    
    @private
    CGSize _tileSize;
    NSUInteger _hTiles;
    NSUInteger _vTiles;
    NSMutableArray *_tiles;
    NSUInteger _minHeight;
    NSMutableDictionary *_reuseDictionary;
    NSUInteger _lastUsedIndex;

}

@property (nonatomic, setter = setMinHeight:) NSUInteger minHeight;
@property (nonatomic, setter = setVerticalTiles:) NSUInteger verticalTiles;
@property (nonatomic, setter = setHorizontalTiles:) NSUInteger horizontalTiles;
@property (nonatomic, readonly) CGPoint origin;


-(id)initWithTileSize:(CGSize)tileSize height:(NSUInteger)vTiles width:(NSUInteger)hTiles;

/**
 Sets the horizontal dimension of the view in tiles. does not affect origin of the frame rect
 */

-(void)setHorizontalTiles:(NSUInteger)hTiles;

/**
 Sets the vertical dimension of the view in tiles. does not affect origin of the frame rect
 */

-(void)setVerticalTiles:(NSUInteger)vTiles;


/**
 * Returns the size in terms of tiles of this view
 */
-(CGSize)sizeInTiles;
/**
 Sets the size of this view measured in tiles
 */
-(void)setSizeInTiles:(CGSize)sizeInTiles;
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
  
  
-(id<TiledViewProtocol>)dequeueReusableCellWithIdentifier:(NSString *)identifier;

/** 
 returns all the tiles in this tiled view
 */
-(NSArray*)allTiles;


/**
 remove cached objects
 
 */
-(void)didReceiveMemoryWarning;

@end
