//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Bird: SKSpriteNode {
    
    var timer = 0
    var timer2 = 100
    var stache: SKSpriteNode!
    var state: Int = 1
    var velX: CGFloat = (difficulty * -2.3 - CGFloat(arc4random_uniform(3))/1.6) * screenSize.width/667
    var velY: CGFloat = 0
    var index = 1000
    var inside = false
    
    init () {
        
        super.init(texture: birdTexture1, color: nil, size: birdTexture1.size())
        
        self.anchorPoint = CGPointMake(0.4306, 0.6)
        changeSize(0.3 * screenSize.width/667, h: 0.3 * screenSize.height/375)
        var rand = arc4random_uniform(8)
        let animate = SKAction.repeatActionForever(SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.13))
        self.runAction(animate)
        
        if difficulty < 1.4 {
            rand = 5
        }
        
        if rand < 1 {
            let heart = Heart()
            heart.zPosition = -1
            heart.anchorPoint = CGPointMake(0.25, 0.7166)
            heart.position = CGPointMake(0, -7)
            addChild(heart)
            
            heart.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -8, duration: 0.0))
            heart.runAction(Animation2())
            
            heart.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(heart.size.width * 0.8, heart.size.height * 0.7), center: CGPointMake(heart.size.height/5, -heart.size.height/4))
            heart.physicsBody?.dynamic = true
            heart.physicsBody?.categoryBitMask = BodyType.heart.rawValue
            heart.physicsBody?.contactTestBitMask = BodyType.char.rawValue
            heart.physicsBody?.collisionBitMask = BodyType.char.rawValue
            heart.physicsBody?.affectedByGravity = false
        }
            
        else if rand < 2 {
            let birdBomb = BirdBomb()
            birdBomb.zPosition = -1
            birdBomb.anchorPoint = self.anchorPoint
            birdBomb.position = CGPointMake(0, 0)
            addChild(birdBomb)
            
            birdBomb.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -40, duration: 0.0))
            birdBomb.runAction(Animation2())
            
            birdBomb.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(birdBomb.size.width * 0.8, birdBomb.size.height * 0.7), center: CGPointMake(birdBomb.size.height/5, -birdBomb.size.height/4))
            birdBomb.physicsBody?.dynamic = true
            birdBomb.physicsBody?.categoryBitMask = BodyType.heart.rawValue
            birdBomb.physicsBody?.contactTestBitMask = BodyType.char.rawValue
            birdBomb.physicsBody?.collisionBitMask = BodyType.char.rawValue
            birdBomb.physicsBody?.affectedByGravity = false
        }
            
        else {
        let stacheBag = StacheBag()
        stacheBag.zPosition = -1
        stacheBag.anchorPoint = self.anchorPoint
        stacheBag.position = CGPointMake(0, 0)
        addChild(stacheBag)
        
        stacheBag.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -40, duration: 0.0))
        stacheBag.runAction(Animation2())
        
        stacheBag.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(stacheBag.size.width * 0.35, stacheBag.size.height * 0.4), center: CGPointMake(stacheBag.position.x, stacheBag.position.y - stacheBag.size.height/5))
        stacheBag.physicsBody?.dynamic = true
        stacheBag.physicsBody?.categoryBitMask = BodyType.stacheBag.rawValue
        stacheBag.physicsBody?.contactTestBitMask = BodyType.char.rawValue
        stacheBag.physicsBody?.collisionBitMask = BodyType.char.rawValue
        stacheBag.physicsBody?.affectedByGravity = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeSize(w: CGFloat, h: CGFloat) {
        self.size.width = self.size.width * w
        self.size.height = self.size.height * h
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveByX(difficulty * -128 * screenSize.width/667, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    func stopMoving() {
        velX = 0
        velY = 0
        timer2 = 0
        removeAllActions()
        let animate = SKAction.repeatActionForever(SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.13))
        self.runAction(animate)
    }
    
    func Animation() -> SKAction {
        let duration = 0.04
        let fadeOut = SKAction.fadeAlphaTo(0.25, duration: 0.05)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatActionForever(blink)
    }
    
    func Animation2() -> SKAction {
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / 20, duration: 0.3)
        let rotateBack2 = SKAction.rotateByAngle(CGFloat(M_PI) / -20, duration: 0.3)
        let animate = SKAction.sequence([rotateBack, rotateBack2])
        return SKAction.repeatActionForever(animate)
    }
    
    func Animation3() -> SKAction {
        let moveRight = SKAction.moveByX(2, y: 0, duration: 0.5)
        let moveRight2 = SKAction.moveByX(-2, y: 0, duration: 0.5)
        let animate = SKAction.sequence([moveRight, moveRight2])
        return SKAction.repeatActionForever(animate)
    }
    
    func update() {
        
        if(timer2 < 35) {
            self.position.y = self.position.y + 3/10
            timer2++
        }
        else {
            self.position.y = self.position.y - 3/10
            timer2++
            if(timer2 == 70) {
                timer2 = 0
            }
        }
        
        if position.x < -50 {
            removeFromParent()
        }
        
        position.x += velX
        position.y += velY
        
    }
}