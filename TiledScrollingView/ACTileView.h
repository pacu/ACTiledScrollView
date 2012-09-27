//
//  ACTileView.h
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/16/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACTiledScrollView.h"

@interface ACTileView : UIView <TiledViewProtocol>
{
    @private
    CGSize _tileSize;
    CGSize _sizeInTiles;
    ACTileIndex _tileIndex;
    
}
@property (nonatomic,retain) UILabel *label;
@end
