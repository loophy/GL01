//
//  DrawViewController.m
//  Gla-ffiti
//
//  Created by Tomo Kobayashi on 12/12/17.
//  Copyright (c) 2012年 GrnBoy. All rights reserved.
//

#import "DrawViewController.h"

@interface DrawViewController ()

@end

@implementation DrawViewController

@synthesize saveAlert,clearAlert,finImage,imageView;
@synthesize glassView;
@synthesize menuView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   
    
    //イメージピッカーを作成
    imagePicker = [[UIImagePickerController alloc] init];
    
    //イメージピッカーのデリゲートを設定
    imagePicker.delegate = self;
    
    //保存確認アラーとの生成と初期化
    saveAlert = [[UIAlertView alloc] init];
    saveAlert.title = @"画像を保存しますか？";
    
    //タイトル設定
    saveAlert.message = @"本当に保存しますか？";
    saveAlert.delegate = self;
    [saveAlert addButtonWithTitle:@"キャンセル"];
    [saveAlert addButtonWithTitle:@"はい"];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"ベースにする画像を選択しましょう！"
                                  delegate:self
                                  cancelButtonTitle:@
                                  "Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"カメラを起動",@"フォトライブラリから選択", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
    
    //画面取得
    UIScreen *sc = [UIScreen mainScreen];
    
    //ステータスバー込みのサイズ
    CGRect rect = sc.bounds;
    
    //曇り処理用画面の作成
    glassView = [[GlassView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self.view addSubview:glassView];
    
    //menuViewの表示
    CGSize winSize = [[UIScreen mainScreen] bounds].size;
    menuView = [[MenuView alloc] init];
    menuView.view.frame = CGRectMake(0, winSize.height-40,winSize.width,100);
    menuView.view.alpha = 0.5;
    
    menuView.drawViewController = self;
    
    [self.view addSubview:menuView.view];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [imageView release];
    [finImage release];
    [super dealloc];
}

- (void)actionSheet: (UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //カメラを起動
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //イメージピッカーを開く
            [self presentViewController:imagePicker animated:YES completion:nil];
            
            break;
            
        case 1:
            //フォトライブラリ起動
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //イメージピッカーを開く
            [self presentViewController:imagePicker animated:YES completion:nil];
            
            break;
            
        case 2:
            //キャンセル
            
            break;
            
        default:
            break;
    }
}

- (void)actionSheet2: (UIActionSheet *)actionSheet2 clickedButtonAtIndex:(NSInteger)buttonIndex2 {
    
    SLComposeViewController* controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    SLComposeViewController* controller2 = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    switch (buttonIndex2) {
        case 0:
            //Twitterへ投稿
            [controller setInitialText:@"Gla-ffitiより投稿"];
            [controller addImage:finImage];
            [self presentViewController:controller
                               animated:YES
                             completion:NULL];
            break;
            
        case 1:
            //Facebookへ投稿
            [controller2 setInitialText:@"Gla-ffitiより投稿"];
            [controller2 addImage:finImage];
            
            [self presentViewController:controller2
                               animated:YES
                             completion:NULL];
            break;
            
        case 2:
            //キャンセル
            
            break;
            
        default:
            break;
    }
}

- (UIImage*)resizeImage:(UIImage*)image width:(float)width
{
    float w = image.size.width;
    float h = image.size.height;
    CGSize size = CGSizeMake( width, width * (h / w) );
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //写真処理
    //画像を取得する
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
//    image = [self resizeImage:image width:640];
    
    //イメージピッカーを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //イメージビューの領域を取得
    CGRect canvasRect;
    
    if (image.size.width>image.size.height) {
        //グラフィックスコンテクストを作成
        UIGraphicsBeginImageContext(CGSizeMake(image.size.height, image.size.width));
        
        CGImageRef imgRef = [image CGImage];
        CGContextRef context;
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0,0);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextRotateCTM(context, -M_PI_2);
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), imgRef);
    }else{
        //グラフィックスコンテクストを作成
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
        
        CGImageRef imgRef = [image CGImage];
        CGContextRef context;
        context = UIGraphicsGetCurrentContext();
        // 阿部めも、縦画像に２種類ある？そのままオK、縦倍率を大きくすることで横長画像を縦画像としている？（後者は回転縦拡大、をする必要ありっぽい）
        if ( image.imageOrientation == UIImageOrientationLeft || image.imageOrientation == UIImageOrientationRight ||
            image.imageOrientation == UIImageOrientationLeftMirrored || image.imageOrientation == UIImageOrientationRightMirrored ) {
            // 回転させる
            CGContextTranslateCTM(context, 0,0);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI_2);
            CGContextDrawImage(context, CGRectMake(0, 0, image.size.height, image.size.width), imgRef);
        }else {
            // 回転させない
            CGContextTranslateCTM(context, 0,image.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), imgRef);
        }
    }
    
    //写真の画像をブレンドしないで描画
    [image drawInRect:canvasRect];
    
    //グラフィックスコンテクストから画像を取得
    finImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //取得した画像をイメージビューに設定
    imageView.image = finImage;
    
    //グラフィックスコンテクストを解放
    UIGraphicsEndImageContext();
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //タップされたボタンに応じた処理
    
    //アラートが保存確認で、ボタンがはいのとき
    if (alertView == saveAlert && buttonIndex == 1) {
        //イメージビューの領域を取得
        CGRect canvasRect = imageView.bounds;
        
        //コンテクスト開始
        UIGraphicsBeginImageContext(canvasRect.size);
        
        //コンテクストからCGImageに画像を読み込む
        CGImageRef imageRef = CGBitmapContextCreateImage(glassView.m_contextRef);
        
        //UIImageに画像を読み込む
        UIImage *imgC = [UIImage imageWithCGImage:imageRef];
        
        //コンテクスト終了
        UIGraphicsEndImageContext();
        
        //解放
        CGContextRelease(glassView.m_contextRef);
        
        CGImageRef imgRef = [imgC CGImage]; // 画像データ取得
        
        UIGraphicsBeginImageContext(imgC.size); // 開始
        
        // コンテキスト取得
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //原点変更
        CGContextTranslateCTM(context, 0,0);
        
        // コンテキストの軸をXもYも等倍で反転
        CGContextScaleCTM(context, 1.0, 1.0);
        
        // コンテキストにイメージを描画
        CGContextDrawImage( context, CGRectMake( 0, 0, imgC.size.width, imgC.size.height), imgRef);
        
        // コンテキストからイメージを取得
        UIImage *retImg = UIGraphicsGetImageFromCurrentImageContext();
        
        // 終了
        UIGraphicsEndImageContext();
        
        //グラフィックスコンテクストを作成
        UIGraphicsBeginImageContext(canvasRect.size);
        
        //イメージビューの画像を描画
        [imageView.image drawInRect:canvasRect];
        
        //写真の画像をブレンドして描画
        [retImg drawInRect:canvasRect blendMode:kCGBlendModeNormal alpha:1.0];
        
        //グラフィックスコンテクストから画像を取得
        finImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //取得した画像をイメージビューに設定
        //imageView.image = newImage;
        
        //グラフィックスコンテクストを解放
        UIGraphicsEndImageContext();
        
        //イメージビューの画像を写真アルバムに保存
        UIImageWriteToSavedPhotosAlbum(finImage, nil, nil, nil);
        
        // autoreleaseされてしまわないようにUIImage再生成
        finImage = [[UIImage alloc] initWithCGImage:finImage.CGImage];
        
        //SNS投稿
        //menuViewの表示
        CGSize winSize = [[UIScreen mainScreen] bounds].size;
        SnsView *snsView = [[SnsView alloc] init];
        snsView.view.frame = CGRectMake(10, 120,winSize.width-20,220);
        snsView.view.alpha = 1.0;
        
        snsView.drawViewController = self;
        
        [self.view addSubview:snsView.view];

    }
    
    //アラートが消去確認で、ボタンがはいのとき
    if (alertView == clearAlert && buttonIndex == 1) {
        //イメージビューの画像を消去
        imageView.image = nil;
    }
    
    //アラートの表示を消す
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
