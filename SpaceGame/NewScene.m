//
//  NewScene.m
//  SpaceGame
//
//  Created by An Qi on 7/1/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//

#import "NewScene.h"

@implementation NewScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        //self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        screenRect = [[UIScreen mainScreen] bounds];
        screenHeight = screenRect.size.width;
        screenWidth = screenRect.size.height;
        NSLog(@"screen Height: %f", screenHeight);
        NSLog(@"screen Width: %f", screenWidth);
        
        count = 0;
        
        SKTextureAtlas *explosionAtlas = [SKTextureAtlas atlasNamed:@"EXPLOSION"];
        NSArray *textureNames = [explosionAtlas textureNames];
        _explosionTextures = [NSMutableArray new];
        for (NSString *name in textureNames) {
            SKTexture *texture = [explosionAtlas textureNamed:name];
            [_explosionTextures addObject:texture];
        }
        
        _bg1 = [SKSpriteNode spriteNodeWithImageNamed:@"farback.gif"];
        _bg1.anchorPoint = CGPointZero;
        _bg1.position = CGPointMake(0, 0);
        _bg1.name = @"background";
        [self addChild:_bg1];
        
        _bg2 = [SKSpriteNode spriteNodeWithImageNamed:@"farback.gif"];
        _bg2.anchorPoint = CGPointZero;
        _bg2.position = CGPointMake(_bg1.size.width-1, 0);
        _bg2.name = @"background";
        [self addChild:_bg2];
        
        //adding the airplane
        _ship = [SKSpriteNode spriteNodeWithImageNamed:@"player_ship.png"];
        _ship.scale = 1;
        _ship.zPosition = 2;
        _ship.position = CGPointMake(screenWidth/10, screenHeight/2);
        [self addChild:_ship];
        
        /*
        SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.1],
                                               [SKAction fadeInWithDuration:0.1]]];
        SKAction *blinkForTime = [SKAction repeatAction:blink count:4];
        [_ship runAction:blinkForTime];
        */
        
        //[self BarProgress];
        //[self sayBoss];
        //[self makeBoss];
        //[self makeEnemies];
        [self enemy1AtPoint:screenHeight/2];
        //[self scheduleBattle];
    }
    return self;
}

-(void)scheduleBattle {
    //schedule enemies
    SKAction *wait = [SKAction waitForDuration:10];
    SKAction *makeProgressBar = [SKAction runBlock:^{
        [self BarProgress];
    }];
    SKAction *callEnemies = [SKAction runBlock:^{
        [self makeEnemies];
    }];
    SKAction *makeBoss = [SKAction runBlock:^{
        [self makeBoss];
    }];
    SKAction *sayBossBattle = [SKAction runBlock:^{
        [self sayBoss];
    }];
    SKAction *wait3sec = [SKAction waitForDuration:3];
    // CHANGE IT TO CALL ENEMIES, WAIT FOR 1 MIN (WITH 1 MIN PROGRESS BAR), CALL BOSS, AFTER BOSS BATTLE WAIT 1 MIN
    SKAction *updateEnemies = [SKAction sequence:@[callEnemies,wait]];
    
    // Oh, and add in another wait btn the 6 enemies and boss battle thing
    // ADD SKAction FOR MAKING 1MIN PROGRESS BAR INTO THE SEQUENCE
    SKAction *updateCycle = [SKAction sequence:@[makeProgressBar, [SKAction repeatAction:updateEnemies count:6],sayBossBattle, wait3sec, makeBoss]];
    
    // call this method when boss is defeated
    [self runAction:updateCycle];
    // note, if need to switch to endless, just move this code back up without the boss stuff
}

-(void)makeEnemies {
    // ADD IF STATEMENT FOR IF 1 MIN PASSED DO A BOSS BATTLE, ALSO ADD 1 MIN PROGRESS BAR
    
    //randomize from 1 to 3 for a different formation each time
    int waveType = [self getRandomNumberBetween:0 to:2];
    
    if (waveType == 0)
    {
        // SKActions for setting spawn info
        SKAction *wait = [SKAction waitForDuration:1];
        SKAction *spawnEnemyAtTopAndBottom = [SKAction runBlock:^{
            [self enemy1AtPoint:screenHeight*9/10];
            [self enemy1AtPoint:screenHeight/10];
        }];
        SKAction *spawnEnemyAtMiddle = [SKAction runBlock:^{
            [self enemy1AtPoint:screenHeight/2];
        }];
        
        // SKActions for setting the order of spawning
        SKAction *spawnSequence = [SKAction repeatAction:[SKAction sequence:@[spawnEnemyAtTopAndBottom, wait]] count:5];
        SKAction *otherSpawnSequence = [SKAction repeatAction:[SKAction sequence:@[spawnEnemyAtMiddle,wait]] count:5];
        
        // Run the spawning of the 5 top & bottom then 5 in the middle enemy formation
        [self runAction:[SKAction sequence:@[spawnSequence,otherSpawnSequence]]];
        
    }
    else if (waveType == 1)
    {
        SKAction *wait = [SKAction waitForDuration:1];
        SKAction *spawnEnemyAtTopAndBottom = [SKAction runBlock:^{
            [self enemy3AtPoint:screenHeight*9/10];
            [self enemy3AtPoint:screenHeight/10];
        }];
        
        // This is the spawn sequence for this enemy type
        SKAction *spawnSequence = [SKAction repeatAction:[SKAction sequence:@[spawnEnemyAtTopAndBottom, wait]] count:5];
        [self runAction:spawnSequence];
        
    }
    else if (waveType == 2)
    {
        SKAction *wait = [SKAction waitForDuration:1];
        SKAction *spawnEnemy = [SKAction runBlock:^{
            [self enemy2];
        }];
        
        // This is the spawn sequence for this enemy type
        SKAction *spawnSequence = [SKAction repeatAction:[SKAction sequence:@[spawnEnemy,wait]] count:10];
        [self runAction:spawnSequence];
    }
    /*
     else if (waveType == 3)
     {
     // MIGHT ADD A 3RD WAVE TYPE, MUST THINK OF A WAVE TYPE
     }
     */
    
    // this will be the first type of wave (should i put larget text saying wave 1 or whatever?
    // and have the wave number as a part of the high score?
    
}

-(void)enemy1AtPoint:(float)modifiedHeight {
    SKSpriteNode *enemy;
    
    enemy = [SKSpriteNode spriteNodeWithImageNamed:@"enemyShip1.png"];
    enemy.scale = 0.8;
    enemy.position = CGPointMake(screenWidth+enemy.size.width, modifiedHeight);
    enemy.zPosition = 1;
    
    
     enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemy.size];
     enemy.physicsBody.dynamic = YES;                        // means can be moved by the physics
     enemy.physicsBody.categoryBitMask = enemyCategory;
     enemy.physicsBody.contactTestBitMask = bulletCategory;
     enemy.physicsBody.collisionBitMask = 0;
    
    
    double distance = screenWidth;
    float moveDuration = 0.025*distance;
    
    SKAction *action = [SKAction moveToX:0-enemy.size.width duration:moveDuration];
    SKAction *remove = [SKAction removeFromParent];
    
    [enemy runAction:[SKAction sequence:@[action,remove]]];
    
    [self addChild:enemy];
}

-(void)enemy2 {
    SKSpriteNode *enemy;
    
    enemy = [SKSpriteNode spriteNodeWithImageNamed:@"enemyShip4.png"];
    enemy.scale = 1;
    enemy.position = CGPointMake(screenWidth+enemy.size.width, [self getRandomNumberBetween:0 to:screenHeight]);
    enemy.zPosition = 1;
    
    
    enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemy.size];
    enemy.physicsBody.dynamic = NO;                        // means can be moved by the physics
    enemy.physicsBody.categoryBitMask = enemyCategory;
    enemy.physicsBody.contactTestBitMask = bulletCategory;
    enemy.physicsBody.collisionBitMask = 0;
    
    
    CGMutablePathRef cgpath = CGPathCreateMutable();
    
    //random values
    //float yStart = [self getRandomNumberBetween:0+enemy.size.width to:screenRect.size.width-enemy.size.width ];
    float yEnd = [self getRandomNumberBetween:0+enemy.size.height to:screenHeight-enemy.size.height ];
    
    //ControlPoint1
    float cp1X = [self getRandomNumberBetween:0+enemy.size.width to:screenWidth-enemy.size.width ];
    float cp1Y = [self getRandomNumberBetween:0+enemy.size.height to:screenHeight-enemy.size.height ];
    
    //ControlPoint2
    float cp2X = [self getRandomNumberBetween:0+enemy.size.width to:screenWidth-enemy.size.width ];
    float cp2Y = [self getRandomNumberBetween:0+enemy.size.height to:cp1Y];
    
    CGPoint s = CGPointMake(enemy.position.x, enemy.position.y);
    CGPoint e = CGPointMake(0-enemy.size.width, yEnd);
    CGPoint cp1 = CGPointMake(cp1X, cp1Y);
    CGPoint cp2 = CGPointMake(cp2X, cp2Y);
    CGPathMoveToPoint(cgpath,NULL, s.x, s.y);
    CGPathAddCurveToPoint(cgpath, NULL, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
    
    double distance = screenWidth;
    float moveDuration = 0.025*distance;
    
    SKAction *enemyDestroy = [SKAction followPath:cgpath asOffset:NO orientToPath:YES duration:moveDuration];
    
    //SKAction *action = [SKAction moveToX:0-enemy.size.width duration:moveDuration];
    SKAction *remove = [SKAction removeFromParent];
    
    [enemy runAction:[SKAction sequence:@[enemyDestroy,remove]]];
    
    [self addChild:enemy];
}

-(void)enemy3AtPoint:(float)modifiedHeight {
    SKSpriteNode *enemy;
    
    enemy = [SKSpriteNode spriteNodeWithImageNamed:@"enemyShip4.png"];
    enemy.scale = 1;
    enemy.position = CGPointMake(screenWidth+enemy.size.width, modifiedHeight);
    enemy.zPosition = 1;
    
    
    enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemy.size];
    enemy.physicsBody.dynamic = NO;                        // means can be moved by the physics
    enemy.physicsBody.categoryBitMask = enemyCategory;
    enemy.physicsBody.contactTestBitMask = bulletCategory;
    enemy.physicsBody.collisionBitMask = 0;
    
    
    CGMutablePathRef cgpath = CGPathCreateMutable();
    
    CGPoint start = CGPointMake(screenWidth+enemy.size.width, modifiedHeight);
    CGPoint end = CGPointMake(0-enemy.size.width, /*screenHeight - */modifiedHeight);
    CGPoint controlPoint1 = CGPointMake(screenWidth/2 /* *2/3 */, screenHeight-modifiedHeight);
    CGPoint controlPoint2 = CGPointMake(screenWidth/2 /*3*/, screenHeight - modifiedHeight/*modifiedHeight*/);
    CGPathMoveToPoint(cgpath, NULL, start.x, start.y);
    CGPathAddCurveToPoint(cgpath, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, end.x, end.y);
    
    double distance = screenWidth;
    float moveDuration = 0.025*distance;
    
    SKAction *enemyDestroy = [SKAction followPath:cgpath asOffset:NO orientToPath:YES duration:moveDuration];
    
    
    //SKAction *action = [SKAction moveToX:0-enemy.size.width duration:moveDuration];
    SKAction *remove = [SKAction removeFromParent];
    
    [enemy runAction:[SKAction sequence:@[enemyDestroy,remove]]];
    
    [self addChild:enemy];
    
    CGPathRelease(cgpath);
}

-(void)sayBoss {
    SKLabelNode *BossLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    BossLabel.text = @"Boss Battle";
    BossLabel.fontSize = 42;
    BossLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    BossLabel.name = @"BossLabel";
    [self addChild:BossLabel];
    
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *moveUp = [SKAction moveToY:screenHeight + 50 duration:0.01*(screenHeight+50-screenHeight/2)];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *moveSequence = [SKAction sequence:@[wait, moveUp, remove]];
    
    [BossLabel runAction:moveSequence];
}

-(void)BarProgress {
    SKSpriteNode *progressBar = [SKSpriteNode spriteNodeWithImageNamed:@"BarOutline.png"];
    progressBar.zPosition = 2;
    progressBar.position = CGPointMake(screenWidth/2, screenHeight*0.90);
    progressBar.name = @"progressBar";
    progressBar.alpha *= 0.5;
    progressBar.yScale *= 0.75;
    [self addChild:progressBar];
    
    SKAction *progress = [SKAction runBlock:^{
        SKSpriteNode *Bar = [SKSpriteNode spriteNodeWithImageNamed:@"Bar.png"];
        Bar.zPosition = 3;
        Bar.alpha *= 0.5;
        Bar.yScale *= 0.75;
        Bar.position = progressBar.position;
        Bar.name = @"Bar";
        Bar.xScale = count * 0.05;
        count ++;
        [self addChild:Bar];
        
    }];
    
    SKAction *wait = [SKAction waitForDuration:3];
    SKAction *removeBarOutline = [SKAction runBlock:^{
        [progressBar removeFromParent];
        count = 0;
    }];
    SKAction *removeBar = [SKAction runBlock:^{
        [[self childNodeWithName:@"Bar"] removeFromParent];
    }];
    SKAction *BarAction = [SKAction repeatAction:[SKAction sequence:@[progress, wait, removeBar]] count:20];
    SKAction *BarSequence = [SKAction sequence:@[BarAction, [SKAction removeFromParent], removeBarOutline]];
    [self runAction:BarSequence];
}

-(void)makeBoss {
    SKSpriteNode *boss;
    
    int bossType = [self getRandomNumberBetween:1 to:2];
    
    if (bossType == 2) {
        
        boss = [SKSpriteNode spriteNodeWithImageNamed:@"boss2.png"];
        
        boss.name = @"shipboss";
        boss.scale = 1;
        boss.position = CGPointMake(screenWidth + boss.size.width, screenHeight/2);
        boss.zPosition = 1;
        
        [boss runAction:[self Boss2Actions:boss]];
        [self addChild:boss];
        
    } else if (bossType == 1) {
        
        boss = [SKSpriteNode spriteNodeWithImageNamed:@"boss1.png"];
        
        boss.name = @"headboss";
        boss.scale = 1;
        boss.position = CGPointMake(screenWidth + boss.size.width, screenHeight/2);
        boss.zPosition = 1;
        
        // start of animation
        SKTexture *boss1 = [SKTexture textureWithImageNamed:@"boss1.png"];
        SKTexture *boss2 = [SKTexture textureWithImageNamed:@"f2.png"];
        SKTexture *boss3 = [SKTexture textureWithImageNamed:@"f3.png"];
        SKTexture *boss4 = [SKTexture textureWithImageNamed:@"f4.png"];
        SKTexture *boss5 = [SKTexture textureWithImageNamed:@"f5.png"];
        SKTexture *boss6 = [SKTexture textureWithImageNamed:@"f6.png"];
        
        SKAction *animate = [SKAction animateWithTextures:@[boss1,boss2,boss3,boss4,boss5,boss6] timePerFrame:0.1];
        SKAction *animateForever = [SKAction repeatActionForever:animate];
        // end for animation
        
        SKAction *moveToView = [SKAction moveToX:screenWidth-boss.size.width/2 duration:(screenHeight-boss.position.y-boss.size.height)*0.1];
        
        SKAction *moveUp = [SKAction moveToY:screenHeight - boss.size.height/2 duration:0.025*(screenHeight-boss.position.y-boss.size.height/2)];
        SKAction *moveDown = [SKAction moveToY:0+boss.size.height/2 duration:(boss.position.y-boss.size.height/2)*0.025];
        SKAction *moveUpAndDown = [SKAction repeatActionForever:[SKAction sequence:@[moveDown,moveUp]]];
        
        SKAction *wait = [SKAction waitForDuration:3];
        SKAction *firebullet = [SKAction runBlock:^{
            [self fireBossBulletAtPosition:CGPointMake(boss.position.x,boss.position.y - 25) withBullet:@"bossBullet2.png"];
        }];
        SKAction *shootstuff = [SKAction repeatActionForever:[SKAction sequence:@[firebullet,wait]]];
        
        SKAction *shootAndMove = [SKAction runBlock:^{
            // this one will be the animation
            [boss runAction:animateForever];
            [boss runAction:moveUpAndDown];
            [boss runAction:shootstuff];
        }];
        
        // add move boss up and down repeatedly
        [boss runAction:[SKAction sequence:@[moveToView,shootAndMove]]];
        [self addChild:boss];
        
    }
}

-(SKAction *)Boss2Actions:(SKSpriteNode *)boss {
    SKAction *moveToView = [SKAction moveToX:screenWidth-boss.size.width/2 duration:(screenHeight-boss.position.y-boss.size.height)*0.1];
    
    SKAction *moveUp = [SKAction moveToY:screenHeight - boss.size.height/2 duration:0.025*(screenHeight-boss.position.y-boss.size.height/2)];
    SKAction *moveDown = [SKAction moveToY:0+boss.size.height/2 duration:(boss.position.y-boss.size.height/2)*0.025];
    SKAction *moveUpAndDown = [SKAction repeatActionForever:[SKAction sequence:@[moveDown,moveUp]]];
    
    SKAction *wait = [SKAction waitForDuration:3];
    SKAction *firebullet = [SKAction runBlock:^{
        [self fireBossBulletAtPosition:CGPointMake(boss.position.x-boss.size.width/2, boss.position.y + 42) withBullet:@"redbossbullet.png"];
        [self fireBossBulletAtPosition:CGPointMake(boss.position.x-boss.size.width/2, boss.position.y - 42) withBullet:@"redbossbullet.png"];
    }];
    SKAction *shootstuff = [SKAction repeatActionForever:[SKAction sequence:@[firebullet,wait]]];
    
    SKAction *shootAndMove = [SKAction runBlock:^{
        // this one will be the animation
        [boss runAction:moveUpAndDown];
        [boss runAction:shootstuff];
    }];
    
    // add move boss up and down repeatedly
    return [SKAction sequence:@[moveToView,shootAndMove]];
}

-(void)fireBossBulletAtPosition:(CGPoint)location withBullet:(NSString *)bulletType {
    
    
    /*
     bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.size];
     bullet.physicsBody.dynamic = NO;
     bullet.physicsBody.categoryBitMask = bulletCategory;
     bullet.physicsBody.contactTestBitMask = enemyCategory;
     bullet.physicsBody.collisionBitMask = 0;
     */
    
    // ADD in a if boss.name = head then RNG from 1 to ~ else if boss.name = ship then RNG form 1 to ~
    int attackChoice;
    if ([self childNodeWithName:@"shipboss"]) {
        attackChoice = [self getRandomNumberBetween:1 to:5];
    } else {
        attackChoice = [self getRandomNumberBetween:1 to:6];
    }
    
    // this will be from 0 to 2, rest are just one
    if (attackChoice > 0 && attackChoice < 4)
    {
        SKSpriteNode *bossbullet = [SKSpriteNode spriteNodeWithImageNamed:bulletType];
        bossbullet.zPosition = 1;
        bossbullet.scale = 1;
        
        bossbullet.position = location;
        
        // Do some if statement stuff with shooting straight 5 times from head thing, shooting randomly and rapidly from mouth for 5 sec, beam from mouth for 5 sec, or aimed shot at player
        
        // get distance bullet must travel
        double distance = location.x;
        /* sqrt(pow(screenWidth-boss.position.x, 2.0) + pow(screenHeight - boss.position.y, 2.0)); */
        
        // get the duration of bullet travel
        float moveDuration = 0.01*distance;
        
        SKAction *move = [SKAction moveToX:0-bossbullet.size.width duration:moveDuration];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *wait = [SKAction waitForDuration:3];
        
        SKAction *shoot = [SKAction sequence:@[move,remove]];
        SKAction *fireSequence = [SKAction sequence:@[shoot, wait]];
        //[bossbullet runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction sequence:@[action,remove]], wait]]]];
        [bossbullet runAction:fireSequence];
        [self addChild:bossbullet];
    }
    else if (attackChoice == 4)
    {
        for (int i = 0; i < 10; i++) {
            SKSpriteNode *bossbullet = [SKSpriteNode spriteNodeWithImageNamed:bulletType];
            bossbullet.zPosition = 1;
            bossbullet.scale = 1;
            bossbullet.position = location;
            
            CGPoint endPoint = CGPointMake(0, [self getRandomNumberBetween:0 to:screenHeight]);
            
            
            float duration = 0.01*[self distBetween2Points:bossbullet.position and:endPoint];
            
            SKAction *move = [SKAction moveTo:CGPointMake(0, [self getRandomNumberBetween:0 to:screenHeight]) duration:duration];
            SKAction *remove = [SKAction removeFromParent];
            //SKAction *wait = [SKAction waitForDuration:0.1];
            
            SKAction *shoot = [SKAction sequence:@[move, remove]];
            
            [bossbullet runAction:shoot];
            [self addChild:bossbullet];
        }
    }
    else if (attackChoice == 5)
    {
        // use the // if location is greater than boss location then shoot above
        BOOL shootTop;
        if (location.y > [self childNodeWithName:@"shipboss"].position.y) {
            shootTop = true;
        } else {
            shootTop = false;
        }
        SKAction *barrage = [SKAction runBlock:^{
            SKSpriteNode *bossbullet = [SKSpriteNode spriteNodeWithImageNamed:bulletType];
            bossbullet.zPosition = 1;
            bossbullet.scale = 1;
            
            if ([self childNodeWithName:@"shipboss"]) { // if the boss is the ship
                if (shootTop == true) {
                    bossbullet.position = CGPointMake([self childNodeWithName:@"shipboss"].position.x - 55,[self childNodeWithName:@"shipboss"].position.y + 42);
                } else {
                    bossbullet.position = CGPointMake([self childNodeWithName:@"shipboss"].position.x - 55,[self childNodeWithName:@"shipboss"].position.y - 42);
                }
            } else {    // if the boss is the head
                bossbullet.position = CGPointMake([self childNodeWithName:@"headboss"].position.x,[self childNodeWithName:@"headboss"].position.y - 25);
            }
            
            CGPoint endPoint = CGPointMake(0, [self getRandomNumberBetween:0 to:screenHeight]);
            
            float duration = 0.01*[self distBetween2Points:bossbullet.position and:endPoint];
            
            SKAction *move = [SKAction moveTo:CGPointMake(0, [self getRandomNumberBetween:0 to:screenHeight]) duration:duration];
            SKAction *remove = [SKAction removeFromParent];
            
            SKAction *shoot = [SKAction sequence:@[move, remove]];
            
            [bossbullet runAction:shoot];
            [self addChild:bossbullet];
        }];
        
        SKAction *wait = [SKAction waitForDuration:0.25];
        SKAction *timedBarrage = [SKAction repeatAction:[SKAction sequence:@[barrage,wait]] count:10];
        [self runAction:timedBarrage];
    }
    else if (attackChoice == 6)
    {
        SKAction *beamStuff = [SKAction runBlock:^{
            SKSpriteNode *beam = [SKSpriteNode spriteNodeWithImageNamed:@"beam7.png"];
            beam.zPosition = 1;
            beam.yScale = 0.5;
            beam.position = CGPointMake([self childNodeWithName:@"headboss"].position.x-40, [self childNodeWithName:@"headboss"].position.y+25);
            
            SKTexture *beam1 = [SKTexture textureWithImageNamed:@"beam7.png"];
            SKTexture *beam2 = [SKTexture textureWithImageNamed:@"beam8.png"];
            
            SKAction *animate = [SKAction animateWithTextures:@[beam1,beam2] timePerFrame:0.005];
            SKAction *remove = [SKAction removeFromParent];
            
            [beam runAction:[SKAction sequence:@[animate, remove]]];
            [self addChild:beam];
        }];
        
        /*
        SKAction *flash = [SKAction runBlock:^{
            SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.1],
                                                   [SKAction fadeInWithDuration:0.1]]];
            SKAction *blinkForTime = [SKAction repeatAction:blink count:2];
        }];
        [[self childNodeWithName:@"boss" ] runAction:flash];
        */
        
        SKAction *wait = [SKAction waitForDuration:0.04];
        SKAction *repeatBeam = [SKAction repeatAction:[SKAction sequence:@[beamStuff,wait]] count:50];
        [self runAction:repeatBeam];
    }
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random_uniform(to-from+1);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:touchLocation];
    
    
    
    if ([node.name isEqual:@"movement"]) {
        /*
        CGPoint diff = [self CGPointSubtract:_movePad.position from:touchLocation];
        
        float angle = atan2f(diff.x, diff.y);
        
        float newXmoveUsingHeight = (screenHeight-_ship.position.y)/tan(angle) + _ship.position.x;
        float newYmoveUsingWidth = (screenWidth-_ship.position.x)*tan(angle) + _ship.position.y;
        
        if (newXmoveUsingHeight < screenWidth) {
            float duration = sqrtf(powf(screenHeight - _ship.position.y,2.0) + pow(newXmoveUsingHeight-_ship.position.x,2.0))*0.01;
            SKAction *move = [SKAction moveTo:CGPointMake(newXmoveUsingHeight, screenHeight) duration:duration];
            
            [_ship runAction:move];
        } else if (newYmoveUsingWidth < screenHeight) {
            float duration = sqrtf(powf(newYmoveUsingWidth-_ship.position.y,2.0) + pow(screenWidth-_ship.position.x,2.0))*0.01;
            SKAction *move = [SKAction moveTo:CGPointMake(screenWidth, newYmoveUsingWidth) duration:duration];
            
            [_ship runAction:move];
        }
        */
        
        /*
        float Xtouch = touchLocation.x;
        float Ytouch = touchLocation.y;
         
        float angle = atan(Ytouch-_movePad.position.y)/(Xtouch-_movePad.position.x);
        NSLog(@"angle %f",angle);
        float opp = screenHeight-_ship.position.y;
        float adj = screenWidth-_ship.position.x;
        
        // check if new width part is greater than the screen width
        if ((opp)/tan(angle)+_ship.position.x>screenWidth) {
            SKAction *movement = [SKAction moveTo:CGPointMake(screenWidth, tan(angle)*(adj)+_ship.position.y) duration:(adj)*tan(angle)*0.01];
            //SKAction *remove = [SKAction removeFromParent];
            
            [_ship runAction:movement];
            // check if new height is greater than curr height
        } else if ((adj)*tan(angle)+_ship.position.y > screenHeight) {
            SKAction *movement = [SKAction moveTo:CGPointMake((opp)*tan(angle)+_ship.position.x, screenHeight) duration:(opp)/tan(angle)*0.01];
            //SKAction *remove = [SKAction removeFromParent];
            
            [_ship runAction:movement];
        }
        */
    } else if ([node.name isEqual:@"background"]) {
        CGPoint location = [_ship position];
        
        SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"one_bullet.png"];
        bullet.position = CGPointMake(location.x,location.y);
        bullet.zPosition = 1;
        bullet.scale = 0.8;
        
        bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.size];
        bullet.physicsBody.dynamic = NO;
        bullet.physicsBody.categoryBitMask = bulletCategory;
        bullet.physicsBody.contactTestBitMask = enemyCategory;
        bullet.physicsBody.collisionBitMask = 0;
        
        // get distance bullet must travel
        double distance = sqrt(pow(screenWidth-location.x, 2.0) + pow(screenHeight - location.y, 2.0));
        
        // get the duration of bullet travel
        float moveDuration = 0.001*distance;
        
        SKAction *action = [SKAction moveToX:self.frame.size.width+bullet.size.width duration:moveDuration];
        SKAction *remove = [SKAction removeFromParent];
        
        [bullet runAction:[SKAction sequence:@[action,remove]]];
        
        [self addChild:bullet];
    }
    
    /*
     for (UITouch *touch in touches) {
     CGPoint location = [touch locationInNode:self];
     
     SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
     
     sprite.position = location;
     
     SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
     
     [sprite runAction:[SKAction repeatActionForever:action]];
     
     [self addChild:sprite];
     }
     */
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if ((firstBody.categoryBitMask & bulletCategory) != 0 && (secondBody.categoryBitMask & enemyCategory) != 0) {
        SKNode *projectile = (SKNode *)[firstBody node];
        SKNode *enemy = (SKNode *)[secondBody node];
        
        [projectile runAction:[SKAction removeFromParent]];
        [enemy runAction:[SKAction removeFromParent]];
        
        //add explosion
        SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:[_explosionTextures objectAtIndex:0]];
        explosion.zPosition = 1;
        explosion.scale = 0.6;
        explosion.position = contact.bodyA.node.position;
        
        [self addChild:explosion];
        
        SKAction *explosionAction = [SKAction animateWithTextures:_explosionTextures timePerFrame:0.07];
        SKAction *remove = [SKAction removeFromParent];
        [explosion runAction:[SKAction sequence:@[explosionAction,remove]]];
        
    } else if ((secondBody.categoryBitMask & bulletCategory) != 0 && (firstBody.categoryBitMask & enemyCategory) != 0) {
        SKNode *projectile = (SKNode *)[secondBody node];
        SKNode *enemy = (SKNode *)[firstBody node];
        
        [projectile runAction:[SKAction removeFromParent]];
        [enemy runAction:[SKAction removeFromParent]];
        
        //add explosion
        SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:[_explosionTextures objectAtIndex:0]];
        explosion.zPosition = 1;
        explosion.scale = 0.6;
        explosion.position = contact.bodyA.node.position;
        
        [self addChild:explosion];
        
        SKAction *explosionAction = [SKAction animateWithTextures:_explosionTextures timePerFrame:0.07];
        SKAction *remove = [SKAction removeFromParent];
        [explosion runAction:[SKAction sequence:@[explosionAction,remove]]];
        
    }
        
    
    /*
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & bulletCategory) != 0)
    {
        
        SKNode *projectile = (contact.bodyA.categoryBitMask & bulletCategory) ? contact.bodyA.node : contact.bodyB.node;
        SKNode *enemy = (contact.bodyA.categoryBitMask & bulletCategory) ? contact.bodyB.node : contact.bodyA.node;
        [projectile runAction:[SKAction removeFromParent]];
        [enemy runAction:[SKAction removeFromParent]];
        
        //add explosion
        SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:[_explosionTextures objectAtIndex:0]];
        explosion.zPosition = 1;
        explosion.scale = 0.6;
        explosion.position = contact.bodyA.node.position;
        
        [self addChild:explosion];
        
        SKAction *explosionAction = [SKAction animateWithTextures:_explosionTextures timePerFrame:0.07];
        SKAction *remove = [SKAction removeFromParent];
        [explosion runAction:[SKAction sequence:@[explosionAction,remove]]];
    }
    */
}

-(float)distBetween2Points:(CGPoint)point1 and: (CGPoint)point2 {
    float distance = sqrtf(pow(point2.x - point1.x, 2.0) + pow(point2.y- point1.y, 2.0));
    return distance;
}

-(CGPoint)CGPointSubtract:(CGPoint)point1 from:(CGPoint)point2 {
    return CGPointMake(point2.x - point1.x, point2.y-point1.y);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.ship removeAllActions];
}

-(void)update:(CFTimeInterval)currentTime {
    // This stuff is for making a scrolling background, modify the blue #s to set faster or slower
    _bg1.position = CGPointMake(_bg1.position.x-1, _bg1.position.y);
    _bg2.position = CGPointMake(_bg2.position.x-1, _bg2.position.y);
    
    if (_bg1.position.x < -_bg1.size.width){
        _bg1.position = CGPointMake(_bg2.position.x + _bg2.size.width, _bg1.position.y);
    }
    
    if (_bg2.position.x < -_bg2.size.width) {
        _bg2.position = CGPointMake(_bg1.position.x + _bg1.size.width, _bg2.position.y);
    }
}

@end
