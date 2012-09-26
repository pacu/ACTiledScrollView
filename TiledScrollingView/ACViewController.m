//
//  ACViewController.m
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
#import "ACViewController.h"
#import "ACTiledScrollView.h"
#import "ACTileView.h"
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
    
    ACTileView *tile = [[[ACTileView alloc] initWithFrame:CGRectZero] autorelease];
    [tile setBackgroundColor:[UIColor redColor]];
    [tile setTileSize:tileSize];
    [tile setSizeInTiles:CGSizeMake(2, 2)];
    
    [scrollview addTile:tile at:tileIndexFromIndex(0, 3)];
    
    for (NSUInteger idx =0; idx<15; idx++) {
        ACTileView *v = [[[ACTileView alloc] initWithFrame:CGRectZero] autorelease];
        [v setBackgroundColor:[UIColor greenColor]];
        [v setTileSize:tileSize];
        [v setSizeInTiles:CGSizeMake(1, 1)];
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
