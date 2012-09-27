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
@synthesize label;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.label = [[[UILabel alloc]initWithFrame:self.bounds]autorelease];
        [self.label setFont:[UIFont fontWithName:@"Arial" size:20]];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setTextColor:[UIColor blackColor]];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.label];
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
