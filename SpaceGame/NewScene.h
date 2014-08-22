//
//  NewScene.h
//  SpaceGame
//
//  Created by An Qi on 7/1/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const uint8_t bulletCategory = 1;
static const uint8_t enemyCategory = 2;
static const uint8_t shipCategory = 3;
static const uint8_t bossCategory = 4;
static const uint8_t bossbulletCategory = 5;
static const uint8_t bossbeamCategory = 6;

@interface NewScene : SKScene <SKPhysicsContactDelegate> {
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    int count;
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // stuff to add in
    bool invincibleWhenDamaged;
    int lives;
    int score;
    SKLabelNode *livesLabel, *scoreLabel;
    int bossHealth;
}
@property SKSpriteNode *upbutton, *downbutton, *rightbutton, *leftbutton;
@property NSMutableArray *explosionTextures;
@property SKSpriteNode *ship;
@property SKSpriteNode *bg1, *bg2;
//@property SKSpriteNode *movePad;
//@property SKSpriteNode *boss;
@end
