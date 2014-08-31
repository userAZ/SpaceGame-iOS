//
//  GameKitHelper.h
//  SpaceGame
//
//  Created by An Qi on 8/30/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//

@import GameKit;
extern NSString *const PresentAuthenticationViewController;
extern NSString *const LocalPlayerIsAuthenticated;

@interface GameKitHelper : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

+ (void) reportScore: (Float64) score forIdentifier: (NSString*) identifier;
+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;

@end
