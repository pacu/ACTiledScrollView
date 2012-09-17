//
//  ACTileView.m
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/16/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import "ACTileView.h"
#import "ACTiledScrollView.h"
@implementation ACTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(CGSize)sizeInTiles{
    
    return _sizeInTiles;

}
-(CGSize)tileSize{
    return _tileSize;
}
-(UIView*) tileView{
    return self;
    
}
-(void)setTileSize:(CGSize)tileSize{

    _tileSize = tileSize;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, tileSize.width * _sizeInTiles.width , tileSize.height *_sizeInTiles.height)];
    
    
}
-(void)setSizeInTiles:(CGSize)sizeInTiles{
    _sizeInTiles = sizeInTiles;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _tileSize.width * _sizeInTiles.width , _tileSize.height *_sizeInTiles.height)];
}
-(ACTileIndex)tileIndex{
    return _tileIndex;
}
-(void)setTileIndex:(ACTileIndex)index{
    _tileIndex = index;
}
@end
