//
//  ACViewController.h
//  TiledScrollingView
//
//  Created by Francisco Gindre on 9/15/12.
//  Copyright (c) 2012 AppCrafter.biz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ACTiledScrollView;
@interface ACViewController : UIViewController


@property (nonatomic,retain) ACTiledScrollView *scrollview;
@property (nonatomic,retain) NSMutableArray *array;

@end
