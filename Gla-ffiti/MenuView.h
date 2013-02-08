//
//  MenuView.h
//  Gla-ffiti
//
//  Created by Tomo Kobayashi on 12/12/16.
//  Copyright (c) 2012年 GrnBoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawViewController.h"
#import <iAd/iAd.h>

@class DrawViewController;

@interface MenuView : NSObject <ADBannerViewDelegate>
{
    int menu;
    DrawViewController *drawViewController;
    ADBannerView *customAdView;
}

@property(nonatomic, retain)IBOutlet UIView *view;
@property (nonatomic, assign) int m;
@property (strong, nonatomic) DrawViewController *drawViewController;

- (IBAction)saveImage:(id)sender;
- (IBAction)clearDraw:(id)sender;
- (IBAction)changeImage:(id)sender;
- (IBAction)menuCtrl:(id)sender;

@end
