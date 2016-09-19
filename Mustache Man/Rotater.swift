//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Rotater: SKSpriteNode {
    
    var timer = 1000
    var stache: SKSpriteNode!
    var state: Int = 1
    var velX: CGFloat = (difficulty * -1.5) * screenSize.width/667
    var index = 1000
    var arms: SKSpriteNode!
    var inside = false
    
    init (texture: SKTexture) {
        
        super.init(texture: texture, color: nil, size: texture.size())
        
        self.position = CGPointMake(450, 160)
        self.anchorPoint = CGPointMake(0.497, 0.54566)
        changeSize(0.24 * screenSize.width/667, h: 0.24 * screenSize.height/375)
        let size = CGSizeMake(rotaterTexture.size().width * 0.07, rotaterTexture.size().height * 0.03)
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.dynamic = true
        physicsBody?.categoryBitMask = BodyType.rotater.rawValue
        physicsBody?.contactTestBitMask = 0
        physicsBody?.collisionBitMask = 0
        physicsBody?.affectedByGravity = false
        
        arms = SKSpriteNode(texture: rotateArmsTexture)
        arms.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 3, duration: 0))
        arms.zPosition = -1
        arms.anchorPoint = self.anchorPoint
        arms.size = self.size
        arms.position = CGPointMake(0, 0)
        addChild(arms)
        arms.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(rotateArmsTexture.size().width * 0.03, rotateArmsTexture.size().width * 0.3))
        arms.physicsBody?.dynamic = true
        arms.physicsBody?.categoryBitMask = BodyType.rotateArms.rawValue
        arms.physicsBody?.contactTestBitMask = 0
        arms.physicsBody?.collisionBitMask = 0
        arms.physicsBody?.affectedByGravity = false
        arms.name = "arms"
        
        let duration = Double(arc4random_uniform(4)) + 0.51
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / 2, duration: 1.5/duration)
        arms.runAction(SKAction.repeatActionForever(rotateBack))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        removeAllActions()
    }
    
    func hit1() {
        arms?.physicsBody?.affectedByGravity = true
        arms?.physicsBody?.collisionBitMask = 0
        arms?.physicsBody?.categoryBitMask = 0
    }
    
    func addStache() {
        childNodeWithName("arms")?.removeAllActions()
        self.physicsBody?.categoryBitMask = BodyType.nothing.rawValue
        timer = 0
        stache = SKSpriteNode(imageNamed: "mustache")
        stache.position = CGPointMake(3, -5.7)
        stache.zPosition = 10
        stache.size.width = stache.size.width * 0.06
        stache.size.height = stache.size.height * 0.09
        stache.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 7, duration: 0))
        addChild(stache)
    }
    
    func Animation() -> SKAction {
        let duration = 0.04
        let fadeOut = SKAction.fadeAlphaTo(0.25, duration: 0.05)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatActionForever(blink)
    }
    
    func Animation2() -> SKAction {
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / 16, duration: 0.1)
        let rotateBack2 = SKAction.rotateByAngle(CGFloat(M_PI) / -16, duration: 0.1)
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
        
        if arms.position.y < -(self.position.y + 20) {
            arms.removeFromParent()
        }
        position.x += velX
        
        if position.x < -150 {
            removeFromParent()
        }
        
        if timer < 20 {
            self.physicsBody?.collisionBitMask = BodyType.nothing.rawValue
            state = 0
            timer++
        }
        else if timer == 20 {
            let pointAddition = PointAddition(num: 200, color: UIColor(red: 130/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1.0))
            parent!.addChild(pointAddition)
            pointAddition.zPosition = 199
            let pointsLabel = parent!.parent!.childNodeWithName("pointsLabel") as! PointsLabel
            pointsLabel.add(200)
            runAction(explosion)
            changeSize(0.6, h: 0.6)
            self.alpha = 0.8
            changeTexture(explosionTexture)
            stache.removeFromParent()
            timer++
        }
        else if timer < 24 {
            changeSize(1.2, h: 1.2)
            timer++
        }
        else if timer == 24 {
            self.position.x = 1200
            self.removeFromParent()
        }
        
    }
}