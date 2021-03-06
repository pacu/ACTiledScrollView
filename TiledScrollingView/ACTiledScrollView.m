//
//  ACTiledScrollViewController.m
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/15/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.


#import "ACTiledScrollView.h"
#import "ACTilePlaceholder.h"
#import "ACCGSizeComparator.h"
#import "ACTiledScrollView_Private.h"
#pragma mark -
#pragma mark functions

ACTileIndex ACTileIndexMake(NSUInteger row, NSUInteger col) {
    
    ACTileIndex idx;
    idx.row = row;
    idx.col = col;
    return idx;
}



ACTileIndex tileIndexFromIndex(NSUInteger index, NSUInteger rows) {
    
    NSUInteger row, col;
    col = index/rows;
    row = index%rows;
    ACTileIndex tileIndex;
    tileIndex.col = col;
    tileIndex.row = row;
    
    return tileIndex;
    
}

NSUInteger indexFromTileIndex (ACTileIndex index, NSUInteger rows) {
    
    NSUInteger columnOffset = index.col *rows;
    NSUInteger position = columnOffset + index.row;
    
    return position;
    
}
#pragma mark -
#pragma mark implementation


@implementation ACTiledScrollView

#pragma  mark properties
@synthesize minHeight = _minHeight;
@synthesize verticalTiles = _vTiles;
@synthesize horizontalTiles = _hTiles;


#pragma mark view life cycle

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    return self;
}
-(id)initWithTileSize:(CGSize)tileSize height:(NSUInteger)vTiles width:(NSUInteger)hTiles {
    
    
    if (vTiles <= 0 || hTiles <= 0){
        @throw [[[NSException alloc] initWithName:@"Invalid Argument" reason:@"height and size can't be Zero" userInfo:nil] autorelease];
    }
    CGRect rect=CGRectMake(0, 0, tileSize.width * hTiles,tileSize.height * vTiles);
    self = [self initWithFrame:rect];
    
    if (self)  {
        _minHeight = vTiles;
        _vTiles = vTiles;
        _hTiles = hTiles;
        _tileSize = tileSize;
        _lastUsedIndex = 0;
        [self setContentSize:rect.size];
        NSUInteger capacity = (vTiles*hTiles);
        NSNull *nullObject = [NSNull null];
        _tiles = [[NSMutableArray alloc] initWithCapacity:capacity];
        
        for (int i = 0; i<capacity; i++) {
            
            [_tiles addObject:nullObject];
        }
        _reuseDictionary = [[NSMutableDictionary alloc]initWithCapacity:10];
        
    }
    return self;
    
}

-(void)dealloc {
    
    
    [_tiles release];
    _tiles = nil;
    [_reuseDictionary release];
    _reuseDictionary = nil;
    [super dealloc];
}


-(void)didReceiveMemoryWarning {
    
    [_reuseDictionary release];
    _reuseDictionary = [[NSMutableDictionary alloc] initWithCapacity:5];
}


#pragma view layout methods
-(void)rearrange {
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:[_tiles count]];
    
    NSNull *nullObject = [NSNull null];
    for (NSUInteger idx = 0;idx< [_tiles count]; idx++) {
        [newArray addObject:nullObject];
    }
    
    NSMutableArray *oldArray = _tiles;
    
    _tiles = newArray;
    _lastUsedIndex = 0;
    [oldArray enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj conformsToProtocol:@protocol(TiledViewProtocol)]){
            [self addTile:(id<TiledViewProtocol>)obj at:tileIndexFromIndex(0, _vTiles)];
        }
    }];
    
    [oldArray autorelease];
    
}


-(CGSize)sizeInTiles {
    return CGSizeMake(_hTiles, _vTiles);
}

/**
 Sets the size of this view measured in tiles
 */
-(void)setSizeInTiles:(CGSize)sizeInTiles {
    

    if (sizeInTiles.width <=0) {
        
        @throw [[NSException alloc] initWithName:@"InvalidArgumentException" reason:@"size can't be zero" userInfo:nil];
    }
    
//    if (sizeInTiles.width * _tileSize.width > [[UIScreen mainScreen] bounds].size.width) {
//        @throw [[NSException alloc] initWithName:@"InvalidArgumentException" reason:@"width can't be bigger than screen size" userInfo:nil];
//    }
    if (sizeInTiles.height <=0) {
        
        @throw [[NSException alloc] initWithName:@"InvalidArgumentException" reason:@"size can't be zero" userInfo:nil];
    }
//    if (sizeInTiles.height * _tileSize.height > [[UIScreen mainScreen] bounds].size.height) {
//        @throw [[NSException alloc] initWithName:@"InvalidArgumentException" reason:@"height can't be bigger than screen size" userInfo:nil];
//    }
    _hTiles = sizeInTiles.width;
    _vTiles = sizeInTiles.height;
    
    [(UIScrollView*)self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _hTiles*_tileSize.width, _vTiles*_tileSize.height)];
    [self setContentSize:CGSizeMake(_hTiles * _tileSize.width, _vTiles * _tileSize.height)];
    [self rearrange];
}

-(CGPoint)origin {
    return [self frame].origin;
}



-(CGSize)sizeThatFits:(CGSize)size {
    
    return CGSizeMake(_hTiles * _tileSize.width, _vTiles * _tileSize.height);
}

#pragma mark getters and setters

-(void)setHorizontalTiles:(NSUInteger)hTiles {
    if (hTiles <=0) {
        
        @throw [[NSException alloc] initWithName:@"InvalidArgumentException" reason:@"size can't be zero" userInfo:nil];
    }
    if (hTiles * _tileSize.width > [[UIScreen mainScreen] bounds].size.width) {
        @throw [[NSException alloc] initWithName:@"InvalidArgumentException" reason:@"width can't be bigger than screen size" userInfo:nil];
    }
    
    _hTiles = hTiles;
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _hTiles*_tileSize.width, self.frame.size.height )];
    [self rearrange];
    
    
    
}

-(void)setVerticalTiles:(NSUInteger)vTiles {
    if (vTiles <=0) {
        
        @throw [[NSException alloc] initWithName:@"InvalidArgumentException" reason:@"size can't be zero" userInfo:nil];
    }
    if (vTiles * _tileSize.height > [[UIScreen mainScreen] bounds].size.height) {
        @throw [[NSException alloc] initWithName:@"InvalidArgumentException" reason:@"height can't be bigger than screen size" userInfo:nil];
    }
    
    _vTiles = vTiles;
    
    [(UIScrollView*)self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _vTiles*_tileSize.height)];
    [self rearrange];
}

#pragma mark -
#pragma mark tile mgmt
/**
 adds a tile to the view beginning at the desired tile. If it does not fit in it will be added with a best fit criteria
 */

-(void)addTile:(id<TiledViewProtocol>)tile at:(ACTileIndex)index {
    
    // check if size matches
    BOOL sizeMatches = [self isTileCompatible:tile];
    
    if (!sizeMatches) {
        
        @throw [NSException exceptionWithName:@"InvalidTileSize"
                                       reason:[NSString stringWithFormat:@"TileSize %@ does not match this tilesize %@",
                                               NSStringFromCGSize([tile tileSize]),
                                               NSStringFromCGSize(_tileSize)]
                                     userInfo:nil];
    }
    BOOL sizeCouldFitAtIndex = [self tile:tile fitsIn:index];
    
    if (sizeCouldFitAtIndex) {
        
        NSIndexSet *indexSet = [self indexesForTile:tile at:index];
        
        if ([self isIndexSetAvailable:indexSet]){
        
            [self addTile:tile withIndexSet:indexSet];
        }else {
            [self addTile:tile withBestFitCriteriaFromIndex:indexFromTileIndex(index, _vTiles)];
        }
    } else {
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self,tile, nil] forKeys:[NSArray arrayWithObjects:@"view",@"tile", nil]];
        
        @throw [NSException exceptionWithName:@"TileDoesNotFitException"
                                       reason:@"tile does not fit this ACTiledScrollView" userInfo:dict];
    }
    


}

-(void)addTile:(id<TiledViewProtocol>)tile withBestFitCriteriaFromIndex:(NSUInteger)index {
    NSUInteger idx =index;
    NSIndexSet *indexSet;
    BOOL foundIndex = NO;
    NSRange range;
    range.location =idx;
    range.length = [_tiles count]-idx;
    do {
        
        idx = [_tiles indexOfObjectIdenticalTo:[NSNull null] inRange:range];
        
        if (idx != NSNotFound) {
            ACTileIndex tileIndex = tileIndexFromIndex(idx, _vTiles);
            BOOL tileFits = [self tile:tile fitsIn:tileIndex];
            indexSet = [self indexesForTile:tile at:tileIndex];
            BOOL tileSizeAvailable = [self isIndexSetAvailable:indexSet];
            
            if (tileFits && tileSizeAvailable)
                foundIndex = YES;
            else{
                idx ++;
                range.location =idx;
                range.length = [_tiles count]-idx;
            }
        }
       
        
        
    }while (!foundIndex && idx != NSNotFound);
    
    if (!foundIndex)
        [self appendTile:tile];
    else {
       // indexSet = [self indexesForTile:tile atPosition:idx];
        
        [self addTile:tile withIndexSet:indexSet];
    }
}
/**
 adds the tile to the view. Assumes the tile is compatible and that there is room for it.
 */
-(void)addTile:(id<TiledViewProtocol>)tile withIndexSet:(NSIndexSet*)indexSet {
    
    [_tiles replaceObjectAtIndex:[indexSet firstIndex] withObject:tile];
    [indexSet enumerateIndexesWithOptions:NSEnumerationReverse usingBlock:^(NSUInteger idx, BOOL *stop) {
        
        if (idx ==[indexSet firstIndex]) {
            *stop = YES;
        }else {
            [_tiles replaceObjectAtIndex:idx withObject:[ACTilePlaceholder sharedPlaceholder]];
        }
        
    }];
    
    CGRect frame = [self frameForTile:tile at:[indexSet firstIndex]];
    [[tile tileView] setFrame:frame];
    
    
    ACTileIndex tileIndex = tileIndexFromIndex([indexSet firstIndex], _vTiles);
    
    [tile setTileIndex:tileIndex];
    
    [self addSubview:[tile tileView]];
    if ([indexSet lastIndex] > _lastUsedIndex){
        _lastUsedIndex = [indexSet lastIndex];
    }
    // readjust content size
    CGFloat newOffset = (frame.origin.x + frame.size.width);
    if (newOffset > self.contentSize.width) {
        
        CGSize newContentSize = CGSizeMake(newOffset, self.frame.size.height);
        [self setContentSize:newContentSize];
    }
    
}

/**
 adds a tile to the view to the tail of the content with best fit criteria
 */

-(void)appendTile:(id<TiledViewProtocol>)tile {
    
    NSNull *nullObject = [NSNull null];
    NSInteger idx=_lastUsedIndex;
    BOOL foundIndex = NO;
    NSIndexSet *indexSet  = nil;
    ACTileIndex tileIndex = tileIndexFromIndex(_lastUsedIndex, _vTiles);
    
    for (idx = _lastUsedIndex; idx<[_tiles count] &&  !foundIndex; idx++) {
        tileIndex = tileIndexFromIndex(idx, _vTiles);
        BOOL tileFits = [self tile:tile fitsIn:tileIndex];
        if(tileFits) {
            indexSet = [self indexesForTile:tile at:tileIndex];
            foundIndex = [self isIndexSetAvailable:indexSet];
            
            
        }
        
    }
    
//    if (!tileFits) {
//        
//        @throw [NSException exceptionWithName:@"InvalidTileSize"
//                                       reason:[NSString stringWithFormat:@"TileSize %@ does not match this tilesize %@",
//                                               NSStringFromCGSize([tile tileSize]),
//                                               NSStringFromCGSize(_tileSize)]
//                                     userInfo:nil];
//    }
    
    
    
    // if necessary expand the tiles array
    if (!foundIndex) {
        
        
        [self resizeArrayByAddingFullGrid];
        [self appendTile:tile];
        
    }else {
        NSIndexSet *possibleIndexSet = [self indexesForTile:tile at:tileIndex];
        [self addTile:tile withIndexSet:possibleIndexSet];
    }
    
    
    
}
    
    


/**
 removes the desired tile from the view using the supplied block to compare the view;
 */
-(void)removeTile:(id<TiledViewProtocol>)view compareBlock:(BOOL(^)(id obj, NSUInteger idx, BOOL *stop))block rearrange:(BOOL)yesOrNo
{
    NSUInteger index = [_tiles indexOfObjectPassingTest:block];
    [self removeTile:index];
    
    if (yesOrNo) {
        [self rearrange];
    }
}

/**
 removes the tile from the given position. ignores the call if it does not exist of if it's a placeholder
 */
-(void)removeTile:(NSUInteger)position {
    
    id<TiledViewProtocol>  tile = [_tiles objectAtIndex:position];
    [[tile tileView] removeFromSuperview];
    NSIndexSet *indices  = [self indexesForTile:tile atPosition:position];
    [indices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        [_tiles replaceObjectAtIndex:idx withObject:[NSNull null]];
    }];
    
}

/**
 returns all the tiles in this tiled view
 */
-(NSArray*)allTiles {
    
    return [self subviews];
}

#pragma mark -
#pragma mark indexSet handling methods
/**
 returns the indexes that, theoretically speaking, this tile could use. Returns nil if the tile can't be inserted in this scrollview.
 */

-(NSIndexSet*)indexesForTile:(id<TiledViewProtocol>)tile at:(ACTileIndex)position {
    
    if (![self tile:tile fitsIn:position]){
        return nil;
    }
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
    
    CGSize size = [tile sizeInTiles];
    NSInteger row, col;
    col = position.col;
    row = position.row;
    NSUInteger index =0;
    for (NSUInteger i = col; i< (col+ size.width); i++) {
        for (NSUInteger j = row; j<(row +size.height); j++) {
             index = i * _vTiles + j;
            [set addIndex:index];
        }
    }
    [set autorelease];
    return [[[NSIndexSet alloc]initWithIndexSet:set] autorelease];
    
}

/**
 returns the indexes that, theoretically speaking, this tile could use. Returns nil if the tile can't be inserted in this scrollview.
 */
-(NSIndexSet*)indexesForTile:(id<TiledViewProtocol>)tile atPosition:(NSUInteger)position {

    ACTileIndex index = tileIndexFromIndex(position, _vTiles);
    return [self indexesForTile:tile at:index];
}


/**
 checks if the indices of the indexSet point to positions of the _tiles Array that are available (with NSNull) 
 */

-(BOOL)isIndexSetAvailable:(NSIndexSet*)indexSet {
    if (indexSet == nil)
        return false;
    BOOL firstIndexInBounds =[indexSet firstIndex] >= [_tiles count];
    BOOL lastIndexInBounds = [indexSet lastIndex]>= [_tiles count];
    if (firstIndexInBounds || lastIndexInBounds) {
        return NO;
    }
    
    __block BOOL isAvailable = YES;
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        isAvailable = [_tiles objectAtIndex:idx] == [NSNull null];
        
        if (!isAvailable){
            *stop = YES;
        }
    }];
    return isAvailable;
    
}

#pragma  mark -
#pragma mark Tile Verification methods
/**
 checks compatibility between the given tile and this instance of ACTiledScrollView
 */

-(BOOL)isTileCompatible:(id<TiledViewProtocol>)tile {
    
    return !CGSizeEqualToSize([tile tileSize], CGSizeZero) && CGSizeEqualToSize([tile tileSize], _tileSize);
}

/**
 returns whether the tile could fit in this tiling scrollview. This means that the tile can be displayed entirely within the bounds of the scrollview.
 */
-(BOOL)tile:(id<TiledViewProtocol>)tile fitsIn:(ACTileIndex)index{
    
    BOOL couldFit = [ACCGSizeComparator compareSize:[tile sizeInTiles] to:CGSizeMake(_hTiles, _minHeight)] != NSOrderedDescending;
    
    if (!couldFit || ![self isTileCompatible:tile])
        return NO;
         
    NSUInteger row, col;
    row = index.row;
    col = index.col;
    
    BOOL fitsVertically = (_vTiles-row) >= [tile sizeInTiles].height;
    
    if (!fitsVertically)
        return NO;
    
    BOOL fitsHorizontally = [tile sizeInTiles].width <=_hTiles;
    
    if (!fitsHorizontally) {
        return NO;  
    }
    
    return YES;
}



#pragma mark convience methods

/*  
 resizes the tile array to fit the given indexSet. if indexset is within bounds returns the
 received array. If otherwise the array will be copied to a new instance  that can fit the 
 lastIndex of the indexSet filling the array with NSNull
 */

-(NSMutableArray*)resizeArray:(NSMutableArray*)array ToFitIndexSet:(NSIndexSet*)indexSet {
    // if the array can fit this index set, then return the same array
    if ([array count] >= [indexSet lastIndex])
        return  array;
    
    NSUInteger capacity = [indexSet lastIndex];
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:capacity];
    
    [newArray addObjectsFromArray:array];
    NSNull *nullObject = [NSNull null];
    
    // fill the array with null objects
    for (NSUInteger idx = [array count]; idx < capacity ; idx++) {
        [newArray addObject:nullObject];
    }
    
    
    return newArray;
    
    
}
    
-(NSMutableArray*)resizeArrayByAddingFullGrid:(NSMutableArray *)array {
    NSMutableIndexSet *newIndexSet = [NSMutableIndexSet indexSetWithIndex:[array count]];
    NSUInteger lastIndex = [array count]+ (_vTiles * _hTiles)-1;
    [newIndexSet addIndex:lastIndex];
    return [self resizeArray:array ToFitIndexSet:newIndexSet];
    
}


/*
 
 wrapper method for -(NSMutableArray*)resizeArrayByAddingFullGrid:(NSMutableArray *)array
 */

-(void)resizeArrayByAddingFullGrid {
    
    [_tiles autorelease];
    _tiles = [[self resizeArrayByAddingFullGrid:_tiles] retain];
    
}
/**
 wrapper method for -(NSMutableArray*)resizeArray:(NSMutableArray*)array ToFitIndexSet:(NSIndexSet*)indexSet
 */
-(void)resizeArrayToFitIndexSet:(NSIndexSet*)indexSet {
    [_tiles autorelease];
    _tiles = [self resizeArray:_tiles ToFitIndexSet:indexSet];
}
    

/**
 
 returns the tile size and origin to place that (assumed compatible) tile to this ACTileView 
 */
-(CGRect)frameForTile:(id<TiledViewProtocol>)tile atIndex:(ACTileIndex)index {
    
    CGRect rect = CGRectMake(_tileSize.width *index.col, _tileSize.height * index.row, [tile sizeInTiles].width * _tileSize.width, [tile sizeInTiles].height  * _tileSize.height);
    
    
    return rect;
}


-(CGRect)frameForTile:(id<TiledViewProtocol>)tile at:(NSUInteger)index {
    
    ACTileIndex idx = tileIndexFromIndex(index, _vTiles);
    
    return [self frameForTile:tile atIndex:idx];
}

#pragma mark - 
#pragma mark cell reuse
-(id<TiledViewProtocol>)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier {
    
  	NSMutableSet *cells = [_reuseDictionary objectForKey: reuseIdentifier];
	id<TiledViewProtocol> cell = (id<TiledViewProtocol>)[cells anyObject];
	if ( cell == nil )
		return ( nil );
    
	[cell prepareForReuse];
    
	[cells removeObject: cell];
	return ( cell );
}

-(void)enqueueReusableCells:(NSArray*) reusableTiles {
    for ( id<TiledViewProtocol> tile in reusableTiles )
	{
		NSMutableSet * reuseSet = [_reuseDictionary objectForKey: [tile reuseIdentifier]];
		if ( reuseSet == nil )
		{
			reuseSet = [[NSMutableSet alloc] initWithCapacity: 32];
			[_reuseDictionary setObject: reuseSet forKey: [tile reuseIdentifier]];
		}
		else if ( [reuseSet member: tile] == tile )
		{
			NSLog( @"Warning: tried to add duplicate tile" );
			continue;
		}
        
		[reuseSet addObject: tile];
	}
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}


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
    
   // [self rearrange];
}

/*
 DO NOT USE THIS METHOD. TESTING PURPOSES ONLY
 */
-(NSMutableArray*)tileArray{
    
    return _tiles;
}

@end