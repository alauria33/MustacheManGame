//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    
    var timer = -15
    var timer2 = 100
    var fire: SKSpriteNode!
    var stache: SKSpriteNode!
    var state: Int = 1
    var velY: CGFloat!
    var velX: CGFloat = ((difficulty - 0.15) * -2.5 - (CGFloat(arc4random_uniform(10)))/6) * screenSize.width/667
    var index = 1000
    var inside = false
    var GS: GameScene!
    
    
    init (texture: SKTexture) {
        
        super.init(texture: texture, color: nil, size: texture.size())
        changeSize(0.12 * screenSize.width/667, h: 0.12 * screenSize.height/375)
        let rotate = SKAction.rotateByAngle( CGFloat(M_PI) / 6, duration: 0.0)
        runAction(rotate)
        setPhysicsBodyWithSize(size)
        fire = SKSpriteNode(texture: fireTexture)
        fire.zPosition = -1
        fire.anchorPoint = CGPointMake(0.5, 1.0)
        fire.size.width = fire.size.width * 0.4 * screenSize.width/667
        fire.size.height = fire.size.height * 0.3 * screenSize.height/375
        fire.position = CGPointMake(8.5 * screenSize.width/667, -15.7 * screenSize.height/375)
        let rotate2 = SKAction.rotateByAngle( CGFloat(M_PI) / -7, duration: 0.0)
        fire.runAction(rotate2)
        addChild(fire)
        
        fire.runAction(Animation())
        fire.runAction(Animation2())
        
        if texture == alienTexture2 {
            fire.position = CGPointMake(8.1 * screenSize.width/667, -16 * screenSize.height/375)
        }
        
        let rot1 = SKAction.rotateByAngle( CGFloat(M_PI) / 44, duration: 0.0)
        let rot2 = SKAction.rotateByAngle( CGFloat(M_PI) / -55, duration: 0.3)
        let rot3 = SKAction.rotateByAngle( CGFloat(M_PI) / 55, duration: 0.3)
        self.runAction(rot1)
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([rot2, rot3])))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhysicsBodyWithSize(size: CGSize) {
        let size = CGSizeMake(size.width * 0.45, size.height * 0.7)
        var body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size, center: CGPointMake(-size.width/10, 0))
        body.dynamic = true
        body.categoryBitMask = BodyType.enemy.rawValue
        body.collisionBitMask = 0//BodyType.wall.rawValue
        body.contactTestBitMask = 0//BodyType.wall.rawValue
        body.affectedByGravity = false
        body.mass = 0.01
        self.physicsBody = body
    }
    
    func changeTexture(texture: SKTexture) {

        self.texture = texture
        
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
    }
    
    func addStache() {
        timer = -5
        self.physicsBody?.categoryBitMask = BodyType.nothing.rawValue
        stache = SKSpriteNode(texture: mustacheTexture)
        stache.position = CGPointMake(-2.8 * screenSize.width/667, 2.9 * screenSize.height/375)
        stache.zPosition = 1
        stache.size.width = stache.size.width * 0.055 * screenSize.width/667
        stache.size.height = stache.size.height * 0.077 * screenSize.height/375
        let rotate = SKAction.rotateByAngle( CGFloat(M_PI) / -6, duration: 0.0)
        stache.runAction(rotate)
        if self.texture == alienTexture3 {
            stache.position = CGPointMake(-3.4, 4)
        }
        if texture == alienTexture2 {
            stache.position = CGPointMake(-5.8, 2.5)
        }
        velY = 0
        addChild(stache)
    }
    
    func Animation() -> SKAction {
        let duration = 0.04
        let fadeOut = SKAction.fadeAlphaTo(0.5, duration: duration)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatActionForever(blink)
    }
    
    func Animation2() -> SKAction {
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / 6, duration: 0.1)
        let rotateBack2 = SKAction.rotateByAngle(CGFloat(M_PI) / -6, duration: 0.1)
        let animate = SKAction.sequence([rotateBack, rotateBack2])
        return SKAction.repeatActionForever(animate)
    }
    
    func update() {
        
        if self.position.x < -270 {
            self.removeFromParent()
        }
        
        if(timer2 < 25) {
            self.position.y = self.position.y + 2/10
            timer2++
        }
        else {
            self.position.y = self.position.y - 2/10
            timer2++
            if(timer2 == 50) {
                timer2 = 0
            }
        }
        
        if timer < -10 {
            self.position.x = self.position.x + velX
            self.position.y = self.position.y + velY
        }
        else if timer < 24 {
            self.physicsBody?.collisionBitMask = BodyType.nothing.rawValue
            state = 0
            timer++
        }
        else if timer == 24 {
            let pointAddition = PointAddition(num: 300, color: UIColor(red: 130/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1.0))
            parent!.addChild(pointAddition)
            pointAddition.zPosition = 199
            let pointsLabel = parent!.parent!.childNodeWithName("pointsLabel") as! PointsLabel
            pointsLabel.add(300)
            runAction(explosion)
            changeSize(1.2, h: 1.2)
            self.alpha = 0.8
            changeTexture(explosionTexture)
            fire.removeFromParent()
            stache.removeFromParent()
            timer++
        }
        else if timer < 29 {
            changeSize(1.18, h: 1.18)
            timer++
        }
        else if timer == 29 {
            self.position.x = 1200
            self.removeFromParent()
        }
    }
}
