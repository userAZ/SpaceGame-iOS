//
//  ViewController.m
//  SpaceGame
//
//  Created by An Qi on 7/1/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@interface ViewController () <ADBannerViewDelegate>
@property (nonatomic, strong) ADBannerView *BannerAd;
@end

@implementation ViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
            
#ifdef FREE
    self.BannerAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
    self.BannerAd.delegate = self;
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if ([version floatValue] >= 8) {
        [_BannerAd setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]; // set to your screen dimensions
    } else {
        [_BannerAd setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)]; // set to your screen dimensions
    }
    
    [self.view addSubview:_BannerAd];
#endif
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    //set the view only once, if the device orientation is
    //rotating viewWillLayoutSubviews will be called again
    if ( !skView.scene ) {
        //skView.showsFPS = YES;
        //skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (banner.isBannerLoaded) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!banner.isBannerLoaded) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
