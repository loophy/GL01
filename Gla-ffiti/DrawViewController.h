//
//  DrawViewController.h
//  Gla-ffiti
//
//  Created by Tomo Kobayashi on 12/12/17.
//  Copyright (c) 2012年 GrnBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Social/Social.h>
#import "GlassView.h"
#import "MenuView.h"
#import "SnsView.h"

@class GlassView;
@class MenuView;
@class SnsView;

@interface DrawViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIImage *finImage;
    UIImagePickerController *imagePicker;
    GlassView* glassView;
    MenuView* menuView;
    UIAlertView *saveAlert;
    UIAlertView *clearAlert;
}

@property (strong, nonatomic) GlassView *glassView;
@property (strong, nonatomic) MenuView *menuView;
@property (retain, nonatomic,) UIImage *finImage;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) UIAlertView *saveAlert;
@property (nonatomic, assign) UIAlertView *clearAlert;



@end
