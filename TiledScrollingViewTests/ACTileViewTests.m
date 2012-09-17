//
//  ACTileViewTests.m
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/16/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import "ACTileViewTests.h"

@implementation ACTileViewTests


- (void)setUp
{
    [super setUp];
    _view = [[ACTileView alloc] initWithFrame:CGRectZero];
    
    

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    [_view autorelease];
    _view = nil;
}





-(void)testSetTileSize{
    CGSize size = CGSizeMake(256,192);
    
    [_view setTileSize:size];
    
    STAssertTrue(CGSizeEqualToSize(size, [_view tileSize]), @"tileSize does not match expected:%@, actual:%@",NSStringFromCGSize(size),NSStringFromCGSize([_view tileSize]));
    
    
}

-(void)setSizeInTiles{
    
    CGSize tileSize = CGSizeMake(256,192);
    
    [_view setTileSize:tileSize];
    
    CGSize size = CGSizeMake(3, 2);
    
    [_view setSizeInTiles:size];
    
    CGRect rect = CGRectMake(0, 0, 3 * tileSize.width, 2 * tileSize.height);
    STAssertTrue(CGRectEqualToRect(rect, [_view frame]), @"tile view frame does not match expected:%@ actual:%@",NSStringFromCGRect(rect),NSStringFromCGRect(_view.frame));
    
}


@end
