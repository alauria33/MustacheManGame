//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Super: SKSpriteNode {
    
    var timer = 1000
    
    init () {
        
        super.init(texture: superStacheTexture1, color: nil, size: superStacheTexture1.size())
        self.zPosition = 31
        changeSize(4.7, h: 4.7)
        size = CGSizeMake(size.width * 0.18 * screenSize.width/667, size.height * 0.17 * screenSize.height/375)
        zPosition = 1
        position = CGPointMake(-7 * screenSize.width/667, 0.5 * screenSize.width/667)
        setPhysicsBody(size.width, height: size.height)
        //self.runAction(Animation())
        //setPhysicsBody(imageTexture.size().width, height: imageTexture.size().height)
        animateStache()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhysicsBody(width: CGFloat, height: CGFloat) {
        let size = CGSize(width: width, height: height)
        var body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        body.dynamic = false
        body.categoryBitMask = BodyType.sup.rawValue
        body.affectedByGravity = false
        body.collisionBitMask = BodyType.ground.rawValue | BodyType.wall.rawValue |
            BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.beam.rawValue | BodyType.rotater.rawValue | BodyType.rotateArms.rawValue
        body.contactTestBitMask = BodyType.ground.rawValue | BodyType.wall.rawValue |
            BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.beam.rawValue | BodyType.rotater.rawValue | BodyType.rotateArms.rawValue
        body.mass = 1000000
        self.physicsBody = body
    }
    
    func changeTexture(imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        self.texture = imageTexture
        
    }
    
    func changeSize(w: CGFloat, h: CGFloat) {
        self.size.width = self.size.width * w
        self.size.height = self.size.height * h
    }
    
    func Animation() -> SKAction {
        let duration = 0.4
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / 20, duration: 0.1)
        let rotateBack2 = SKAction.rotateByAngle(CGFloat(M_PI) / -20, duration: 0.1)
        let animate = SKAction.sequence([rotateBack, rotateBack2])
        return SKAction.repeatActionForever(animate)
    }
    
    func animateStache() {
        //self.runAction(SKAction.animateWithTextures([superStacheTexture1, superStacheTexture2, superStacheTexture3, superStacheTexture4, superStacheTexture5, superStacheTexture6, superStacheTexture7], timePerFrame: 0.2))
        self.runAction(SKAction.sequence([SKAction.animateWithTextures([superStacheTexture1, superStacheTexture2, superStacheTexture3, superStacheTexture4, superStacheTexture5, superStacheTexture6], timePerFrame: 0.07), SKAction.repeatActionForever(SKAction.animateWithTextures([superStacheTexture7, superStacheTexture7a, superStacheTexture7b, superStacheTexture7a], timePerFrame: 0.08))]))
       // self.runAction(SKAction.sequence([SKAction.animateWithTextures([blink1, blink2], timePerFrame: 0.12), SKAction.repeatActionForever(SKAction.animateWithTextures([blink1, blink2, blink3, blink4], timePerFrame: 0.08))]))
    }
    
    func unAnimateStache() {
        self.removeAllActions()
        self.runAction(SKAction.sequence([SKAction.animateWithTextures([superStacheTexture6, superStacheTexture5, superStacheTexture4, superStacheTexture3, superStacheTexture2, superStacheTexture1, invisble], timePerFrame: 0.07)]))
    }
    
    func update() {
        
        if timer < 100 {
            if timer == 0 {
                unAnimateStache()
            }
            
            if timer == 20 {
                let char = parent as! Char
                let GS = char.parent as! GameScene
                GS.childNodeWithName("blue")!.removeFromParent()
                
                if GS.stacheCount > 0 {
                    char.texture = mainCharTexture
                }
                else {
                    char.texture = stachelessTexture
                }
                char.canHold = true
                char.physicsBody = char.tempPhysics
                char.physicsBody?.contactTestBitMask = BodyType.beam.rawValue | BodyType.powerup.rawValue | BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue
                char.physicsBody?.collisionBitMask = BodyType.beam.rawValue | BodyType.powerup.rawValue | BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue
                char.physicsBody?.dynamic = true
                char.physicsBody?.categoryBitMask = BodyType.char.rawValue
                char.physicsBody?.affectedByGravity = false
                char.zPosition = 200
                self.removeFromParent()
                timer = 30
            }
            timer++
        }
    }
    
}