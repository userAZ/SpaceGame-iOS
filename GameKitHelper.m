//
//  GameKitHelper.m
//  SpaceGame
//
//  Created by An Qi on 8/30/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//

#import "GameKitHelper.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";
NSString *const LocalPlayerIsAuthenticated = @"local_player_authenticated";

@implementation GameKitHelper {
    BOOL _enableGameCenter;
}

+ (instancetype)sharedGameKitHelper
{
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

+ (void) reportScore: (Float64) score forIdentifier: (NSString*) identifier
{
    GKScore* highScore = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
    highScore.value = score;
    [GKScore reportScores:@[highScore] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Error in reporting scores: %@", error);
        }
    }];
}

- (id)init
{
    self = [super init];
    if (self) {
        _enableGameCenter = YES;
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    //1
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.isAuthenticated) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LocalPlayerIsAuthenticated object:nil];
        return;
    }
    //2
    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        //3
        [self setLastError:error];
        
        if(viewController != nil) {
            //4
            [self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            //5
            _enableGameCenter = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:LocalPlayerIsAuthenticated object:nil];
        } else {
            //6
            _enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController
{
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:PresentAuthenticationViewController
         object:self];
    }
}

- (void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@",
              [[_lastError userInfo] description]);
    }
    
}
@end
