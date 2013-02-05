//
//  SnsView.h
//  Gla-ffiti
//
//  Created by Tomo Kobayashi on 13/01/06.
//  Copyright (c) 2013年 GrnBoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawViewController.h"

@class DrawViewController;

@interface SnsView : NSObject{
    DrawViewController *drawViewController;
}

@property (retain, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) DrawViewController *drawViewController;


- (IBAction)ShareTwitter:(id)sender;
- (IBAction)ShareFacebook:(id)sender;
- (IBAction)ShareCancel:(id)sender;
@end
