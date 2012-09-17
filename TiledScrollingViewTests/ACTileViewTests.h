//
//  ACTileViewTests.h
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/16/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "ACTileView.h"
@interface ACTileViewTests : SenTestCase
{
    @private
    ACTileView *_view;
}

-(void)testSetTileSize;
-(void)setSizeInTiles;
@end
