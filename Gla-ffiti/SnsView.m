//
//  SnsView.m
//  Gla-ffiti
//
//  Created by Tomo Kobayashi on 13/01/06.
//  Copyright (c) 2013年 GrnBoy. All rights reserved.
//

#import "SnsView.h"

@implementation SnsView

@synthesize view;
@synthesize drawViewController;

-(id)init{
    self = [super init];
    if (self != nil) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [[NSBundle mainBundle] loadNibNamed:@"SnsView" owner:self options:nil];
        }else{
            [[NSBundle mainBundle] loadNibNamed:@"SnsView_ipad" owner:self options:nil];
        }
    }
    return self;
}

- (IBAction)ShareTwitter:(id)sender {
    SLComposeViewController* controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    //Twitterへ投稿
    [controller setInitialText:@"Gla-ffitiより投稿"];
    [controller addImage:(drawViewController.finImage)];
    [drawViewController.self presentViewController:controller
                       animated:YES
                     completion:NULL];
    [drawViewController.self performSegueWithIdentifier:@"backMenu" sender:self];
}

- (IBAction)ShareFacebook:(id)sender {
    SLComposeViewController* controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    //Facebookへ投稿
    [controller setInitialText:@"Gla-ffitiより投稿"];
    [controller addImage:drawViewController.finImage];
    
    [drawViewController.self presentViewController:controller
                                          animated:YES
                                        completion:NULL];
    [drawViewController.self performSegueWithIdentifier:@"backMenu" sender:self];
}

- (IBAction)ShareCancel:(id)sender {
    [drawViewController.self performSegueWithIdentifier:@"backMenu" sender:self];
}
- (void)dealloc {
    [view release];
    [super dealloc];
}
@end
