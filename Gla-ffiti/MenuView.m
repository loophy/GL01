//
//  MenuView.m
//  Gla-ffiti
//
//  Created by Tomo Kobayashi on 12/12/16.
//  Copyright (c) 2012年 GrnBoy. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

@synthesize view;
@synthesize drawViewController;



-(void)dealloc{
    [view release];
    [super dealloc];
    
}

-(id)init{
    self = [super init];
    if (self != nil) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil];
            [self configureView];
        }else{
            [[NSBundle mainBundle] loadNibNamed:@"MenuView_ipad" owner:self options:nil];
        }
    }
    menu = 1;
    return self;
}


- (IBAction)saveImage:(id)sender {
    
    //保存確認アラート
    [drawViewController.saveAlert show];
    
}

- (IBAction)clearDraw:(id)sender {
    
    //消去確認アラート
    [drawViewController.clearAlert show];
    
    [drawViewController.glassView removeFromSuperview];
    
    //画面取得
    UIScreen *sc = [UIScreen mainScreen];
    
    //ステータスバー込みのサイズ
    CGRect rect = sc.bounds;
    
    //曇り処理用画面の作成
    drawViewController.glassView = [[GlassView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [drawViewController.view addSubview:drawViewController.glassView];
    
    [drawViewController.view bringSubviewToFront:drawViewController.menuView.view];
}

- (IBAction)changeImage:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"ベースにする画像を選択しましょう！"
                                  delegate:drawViewController
                                  cancelButtonTitle:@
                                  "Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"カメラを起動",@"フォトライブラリから選択", nil];
    [actionSheet showInView:drawViewController.view];
    [actionSheet release];
}

- (IBAction)menuCtrl:(id)sender {
    CGSize winSize = [[UIScreen mainScreen] bounds].size;
    if (menu==1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.center = CGPointMake(160, winSize.height-95);
            self.view.alpha=1.0;
        }
                     completion:^(BOOL finished){
    //アクション終了イベント
                     }];
        menu = 2;
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.view.center = CGPointMake(160, winSize.height+10);
            self.view.alpha=0.2;
        }
                         completion:^(BOOL finished){
                             //アクション終了イベント
                         }];
        menu = 1;
    }
}

- (void)configureView
{
    customAdView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 100, 320, 45)];
    customAdView.delegate = self;
    [self.view addSubview:customAdView];
    
}

@end