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
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
            
        case 1:
            //フォトライブラリ起動
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [image drawInRect:canvasRect];
    finImage = UIGraphicsGetImageFromCurrentImageContext();
    imageView.image = finImage;
    UIGraphicsEndImageContext();
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //タップされたボタンに応じた処理
    
    //アラートが保存確認で、ボタンがはいのとき
    if (alertView == saveAlert && buttonIndex == 1) {
        CGRect canvasRect = imageView.bounds;
        UIGraphicsBeginImageContext(canvasRect.size);
        CGImageRef imageRef = CGBitmapContextCreateImage(glassView.m_contextRef);
        UIImage *imgC = [UIImage imageWithCGImage:imageRef];
        UIGraphicsEndImageContext();
        CGContextRelease(glassView.m_contextRef);
        
        CGImageRef imgRef = [imgC CGImage]; 
        
        UIGraphicsBeginImageContext(imgC.size); 
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context, 0,0);
        CGContextScaleCTM(context, 1.0, 1.0);
        CGContextDrawImage( context, CGRectMake( 0, 0, imgC.size.width, imgC.size.height), imgRef);
        
        UIImage *retImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContext(canvasRect.size);
        [imageView.image drawInRect:canvasRect];
        [retImg drawInRect:canvasRect blendMode:kCGBlendModeNormal alpha:1.0];
        finImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(finImage, nil, nil, nil);
        
        // autoreleaseされてしまわないようにUIImage再生成
        finImage = [[UIImage alloc] initWithCGImage:finImage.CGImage];
        
        //SNS投稿
        CGSize winSize = [[UIScreen mainScreen] bounds].size;
        SnsView *snsView = [[SnsView alloc] init];
        snsView.view.frame = CGRectMake(10, 120,winSize.width-20,220);
        snsView.view.alpha = 1.0;
        snsView.drawViewController = self;
        
        [self.view addSubview:snsView.view];
    }
    
    if (alertView == clearAlert && buttonIndex == 1) {
        imageView.image = nil;
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
