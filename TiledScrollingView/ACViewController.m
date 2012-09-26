//
//  ACViewController.m
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/15/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import "ACViewController.h"
#import "ACTiledScrollView.h"
#import "ACTileView.h"
#import <QuartzCore/QuartzCore.h>
@interface ACViewController ()

@end
    
@implementation ACViewController
@synthesize array,scrollview;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGSize tileSize = CGSizeMake(256,192);
    self.scrollview = [[[ACTiledScrollView alloc]initWithTileSize:tileSize height:3 width:4] autorelease];
    
    self.scrollview.frame =self.view.frame;
    [self.scrollview setBackgroundColor:[UIColor grayColor]];
    ACTileView *tile = [[[ACTileView alloc] initWithFrame:CGRectZero] autorelease];
    [tile setBackgroundColor:[UIColor redColor]];
    [tile setTileSize:tileSize];
    [tile setSizeInTiles:CGSizeMake(2, 2)];

    [tile.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [tile.layer setBorderWidth:2.0];
    [scrollview addTile:tile at:tileIndexFromIndex(0, 3)];
    
    for (NSUInteger idx =0; idx<15; idx++) {
        ACTileView *v = [[[ACTileView alloc] initWithFrame:CGRectZero] autorelease];
        [v setBackgroundColor:[UIColor greenColor]];
        [v setTileSize:tileSize];
        [v setSizeInTiles:CGSizeMake(1, 1)];
        [v.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [v.layer setBorderWidth:2.0];
        [self.scrollview addTile:v at:tileIndexFromIndex(0, 3)];
    }
    
    [self.view addSubview:self.scrollview];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.scrollview = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
