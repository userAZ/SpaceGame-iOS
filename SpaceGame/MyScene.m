//
//  MyScene.m
//  SpaceGame
//
//  Created by An Qi on 7/1/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//

#import "MyScene.h"
#import "NewScene.h"
@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"farback.gif"];
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:background];
        
        SKLabelNode *TitleNode = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
        TitleNode.text = @"Space Fighter";
        TitleNode.fontSize = 42;
        TitleNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        TitleNode.name = @"TitleNode";
        [self addChild:TitleNode];
        
        SKLabelNode *playNode = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
        playNode.text = @"[PRESS ANYWHERE TO START]";
        playNode.fontSize = 20;
        playNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-30);
        playNode.name = @"playNode";
        [self addChild:playNode];
        
        SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:1],
                                               [SKAction fadeInWithDuration:1]]];
        [playNode runAction:[SKAction repeatActionForever:blink]];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    [self runAction:[SKAction playSoundFileNamed:@"startSound.mp3" waitForCompletion:NO]];
    
    SKNode *playNode = [self childNodeWithName:@"playNode"];
    if (playNode != nil)
    {
        [playNode removeAllActions];
        [playNode runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.2],[SKAction removeFromParent]]]];
    }
    
    SKNode *TitleNode = [self childNodeWithName:@"TitleNode"];
    if (TitleNode != nil)
    {
        TitleNode.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        
        //SKView * skView = (SKView *)self.view;
        //NSLog(@"skview:")
        
        [TitleNode runAction: moveSequence completion:^{
            SKScene *myScene  = [[NewScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:myScene transition:doors];
        }];
    }

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
