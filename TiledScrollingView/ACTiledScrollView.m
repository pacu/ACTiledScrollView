//
//  ACTiledScrollViewController.m
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/15/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
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

#import "ACTiledScrollView.h"
#import "ACTilePlaceholder.h"
#import "ACCGSizeComparator.h"
@interface ACTiledScrollView ()

@end

@implementation ACTiledScrollView

#pragma  mark properties
@synthesize minHeight = _minHeight;
@synthesize verticalTiles = _vTiles;
@synthesize horizontalTiles = _hTiles;


#pragma mark view life cycle
-(id)initWithTileSize:(CGSize)tileSize height:(NSUInteger)vTiles width:(NSUInteger)hTiles {
    if (vTiles <= 0 || hTiles <= 0){
        @throw [[[NSException alloc] initWithName:@"Invalid Argument" reason:@"height and size can't be Zero" userInfo:nil] autorelease];
    }
    self = [super initWithFrame:CGRectMake(0, 0, _tileSize.height*_vTiles, _tileSize.width * _hTiles)];
    
    if (self)  {

        _vTiles = vTiles;
        _hTiles = hTiles;
        _tileSize = tileSize;
        int capacity = (vTiles*hTiles);
        NSNull *nullObject = [NSNull null];
        _tiles = [[NSMutableArray alloc] initWithCapacity:capacity];
        for (int i = 0; i<capacity; i++) {
            
            [_tiles addObject:nullObject];
        }
        
        
    }
    return self;
    
}

-(void)dealloc {
    
    [_tiles release];
    [super dealloc];
}





#pragma view layout methods
-(void)rearrange {
    
    for (NSUInteger i=0; i<[_tiles count]; i++) {
        id <TiledViewProtocol> tile = [_tiles objectAtIndex:i];
        
        if (![ACTilePlaceholder isPlaceholder:tile]){
            
            
        }

    }
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



-(CGPoint)origin {
    return [self frame].origin;
}

-(void)setFrame:(CGRect)frame{
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    [super setFrame:newFrame];
    
}

#pragma mark tile mgmt
/**
 adds a tile to the view into beginning at the desired tile. If it does not fit in it will be added with a best fit criteria
 */

-(void)addTile:(id<TiledViewProtocol>)tile at:(ACTileIndex)index {
    
    // check if size matches
    BOOL sizeMatches = [self isTileCompatible:tile];
    
    BOOL sizeCouldFitAtIndex = [self tile:tile fitsIn:index];
    
    


}

/**
 adds a tile to the view to the tail of the content with best fit criteria
 */

-(void)appendTile:(id<TiledViewProtocol>)tile {}

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
    NSIndexSet *indices  = [self indexesForTile:tile at:position];
    [_tiles removeObjectsAtIndexes:indices];
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
/**
 returns all the tiles in this tiled view
 */
-(NSArray*)allTiles {
    
    NSIndexSet *set = [_tiles indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        
        return ![ACTilePlaceholder isPlaceholder:obj];
    }];
    
    return [_tiles objectsAtIndexes:set];
}


/**
 returns the indexes that, theoretically speaking, this tile could use. Returns nil if the tile can't be inserted in this scrollview.
 */

-(NSIndexSet*)indexesForTile:(id<TiledViewProtocol>)tile at:(ACTileIndex)position {
    
    if ([self tile:tile fitsIn:position]){
        return nil;
    }
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
    
    CGSize size = [tile tileSize];
    NSInteger row, col;
    col = position.col;
    row = position.row;
    
    for (NSUInteger i = col; i< col+ size.width; i++) {
        for (NSUInteger j = row; j<row +size.height; j++) {
            NSUInteger index = col * _vTiles + row;
            [set addIndex:index];
        }
    }
    return set;
    
}

-(NSIndexSet*)indexesForTile:(id<TiledViewProtocol>)tile atPosition:(NSUInteger)position {
    NSInteger row, col;
    col = position/_vTiles;
    row = position%_vTiles;
    ACTileIndex index;
    index.col = col;
    index.row = row;
    
    return [self indexesForTile:tile at:index];
}
-(BOOL)isTileCompatible:(id<TiledViewProtocol>)tile {
    
    return [ACCGSizeComparator compareSize:[tile tileSize] to:_tileSize] == NSOrderedSame;
}

/**
 returns whether the tile could fit in this tiling scrollview. This means that the tile can be displayed entirely within the bounds of the scrollview.
 */
-(BOOL)tile:(id<TiledViewProtocol>)tile fitsIn:(ACTileIndex)index{
    
    BOOL couldFit = [ACCGSizeComparator compareSize:[tile sizeInTiles] to:CGSizeMake(_hTiles, _minHeight)];
    
    if (!couldFit && [self isTileCompatible:tile])
        return couldFit;
         
    NSUInteger row, col;
    row = index.row;
    col = index.col;
    
    BOOL fitsVertically = (_vTiles-row) >= [tile sizeInTiles].height;
    
    if (!fitsVertically)
        return false;
    
    BOOL fitsHorizontally = (_hTiles - col) >= [tile sizeInTiles].width;
    
    if (!fitsHorizontally) {
        return false;
    }
    return true;
}


@end
