//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Gunner: SKSpriteNode {
    
    var chara: Char!
    var fire: SKSpriteNode!
    var timer = -5
    var timer2 = 1000
    var stache: SKSpriteNode!
    var state: Int = 1
    var velY: CGFloat!
    var velX: CGFloat = (difficulty * -3.7 - CGFloat(arc4random_uniform(3)))
    var index = 1000
    var shooting = false
    var shootTimer = 1000
    var planTimer = -140
    var sphere: SKSpriteNode!
    var shot: Int = 0
    var shotCount: Int!
    var dad: EnemyGenerator!
    var moveX = true
    var inside = false
    
    init (texture: SKTexture, char: Char, gen: EnemyGenerator) {
        
        super.init(texture: texture, color: nil, size: texture.size())
        
        self.position = CGPointMake(screenSize.width * 1.54, screenSize.height * 0.6364)//CGPointMake(screenSize.width/1.035, screenSize.height/2)
        self.anchorPoint = CGPointMake(0.7, 0.2)
        changeSize(0.24 * screenSize.width/667, h: 0.24 * screenSize.height/375)
        
        self.name = "gunner"
        dad = gen
        dad.on = false
        fire = SKSpriteNode(texture: bootFireTexture)
        fire.zPosition = -1
        fire.anchorPoint = self.anchorPoint
        fire.size = self.size
        fire.position = CGPointMake(0, 0)
        addChild(fire)
        
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / -28, duration: 0.0)
        fire.runAction(rotateBack)
        
        fire.runAction(Animation())
        fire.runAction(Animation2())
        
        self.runAction(Animation3())
        
        chara = char
        
        let rotate1 = SKAction.rotateByAngle(CGFloat(M_PI) / 1000, duration: 0.0)
        self.runAction(rotate1)
        
        if difficulty < 1.55 {
            shotCount = 1 + Int(arc4random_uniform(1))
        }
        else if difficulty < 1.7 {
            shotCount = 2 + Int(arc4random_uniform(1))
        }
        else if difficulty < 2 {
            shotCount = 2 + Int(arc4random_uniform(2))
        }
        else {
            shotCount = 3 + Int(arc4random_uniform(3))
        }
        setPhysicsBodyWithSize(self.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhysicsBodyWithSize(size: CGSize) {
        let size = CGSizeMake(size.width * 0.6, size.height * 0.8)
        var body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size, center: CGPointMake(0, 25))
        body.dynamic = true
        body.categoryBitMask = BodyType.coin.rawValue
        body.collisionBitMask = 0//BodyType.wall.rawValue
        body.contactTestBitMask = 0//BodyType.wall.rawValue
        body.affectedByGravity = false
        self.physicsBody = body
        physicsBody?.mass = 0.01
    }
    
    func changeTexture(imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        self.texture = imageTexture
        
    }
    
    func changeSize(w: CGFloat, h: CGFloat) {
        self.size.width = self.size.width * w
        self.size.height = self.size.height * h
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveByX(difficulty * -128, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    func stopMoving() {
        velX = 0
        velY = 0
        timer2 = 0
        if shootTimer < 65 {
            shootTimer = 65
        }
        if shot < shotCount {
            shot = shotCount
        }
        removeAllActions()
    }
    
    func addStache() {
        stache = SKSpriteNode(imageNamed: "mustache")
        stache.position = CGPointMake(-5.6, 1.8)
        stache.zPosition = 1
        stache.size.width = stache.size.width * 0.05
        if self.texture == enemyTexture3 {
            stache.size.height = stache.size.height * 1.12
        }
        else {
            stache.size.height = stache.size.height * 0.07
        }
        if texture == alienTexture2 {
            stache.position = CGPointMake(-6.5, 1.2)
        }
        velY = 0
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
    
    func shoot() {
        removeActionForKey("charging")
        runAction(beamSound, withKey: "beam")
        shooting = true
        let beam = SKSpriteNode(texture: energyTexture)
        beam.position = CGPointMake(-70 * screenSize.width/667, 48 * screenSize.height/375)
        beam.anchorPoint = CGPointMake(0.935, 0.6127)
        beam.name = "beam"
        beam.size.width *= screenSize.width/667
        beam.size.height *= 1.87 * screenSize.height/375
        beam.alpha = 0.9
        beam.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(screenSize.width * 2.5, 20 * screenSize.height/375))
        beam.physicsBody?.dynamic = true
        beam.physicsBody?.affectedByGravity = false
        beam.physicsBody?.categoryBitMask = BodyType.beam.rawValue
        beam.physicsBody?.contactTestBitMask = 0
        beam.physicsBody?.collisionBitMask = 0
        addChild(beam)
        shootTimer = 0
        
        let colorize = SKAction.colorizeWithColor(UIColor.orangeColor(), colorBlendFactor: 0.4, duration: 1.2)
        beam.runAction(colorize)
    }
    
    func Animation3() -> SKAction {
        let moveRight = SKAction.moveByX(4, y: 0, duration: 0.65)
        let moveRight2 = SKAction.moveByX(-4, y: 0, duration: 0.65)
        let animate = SKAction.sequence([moveRight, moveRight2])
        return SKAction.repeatActionForever(animate)
    }
    
    func update() {

        if moveX {
            self.position.x -= 5
            if self.position.x < screenSize.width/1.1 {
                moveX = false
            }
        }
        
        if(timer2 < 15) {
            self.position.y = self.position.y + 3/10
            timer2++
        }
        else {
            self.position.y = self.position.y - 3/10
            timer2++
            if(timer2 == 30) {
                timer2 = 0
            }
        }
        
        if planTimer < 150 {
            planTimer++
            if planTimer == 30 {
                //timer2 = 0
                sphere = SKSpriteNode(texture: eBallTexture)
                sphere.size = CGSizeMake(3, 3)
                sphere.position = CGPointMake(-73, 48)
                addChild(sphere)
                sphere.name = "sphere"
                shooting = true
                runAction(chargingSound, withKey: "charging")
            }
            if planTimer > 30 && planTimer < 70 {
                sphere.size.width *= 1.07
                sphere.size.height *= 1.07
            }
            if planTimer == 70 {
                childNodeWithName("sphere")?.removeFromParent()
                shoot()
                timer2 = 1000
                planTimer = 1000
            }
        }
        if shootTimer < 70 {
            if shootTimer == 0 {
                let rotate1 = SKAction.rotateByAngle(CGFloat(M_PI) / 70, duration: 0.2)
                let rotate2 = SKAction.rotateByAngle(CGFloat(M_PI) / -70, duration: 0.2)
                let animate = SKAction.repeatActionForever(SKAction.sequence([rotate1, rotate2]))
                let rotate3 = SKAction.rotateByAngle(CGFloat(M_PI) / -140, duration: 0.0)
                self.runAction(rotate3)
                self.runAction(animate, withKey: "taco")
            }
            shootTimer++
            if shootTimer == 65 {
                removeActionForKey("beam")
                childNodeWithName("beam")!.removeFromParent()
                shooting = false
                removeActionForKey("taco")
                shootTimer = 1000
                planTimer = -20 - Int(arc4random_uniform(50))
                if shot < shotCount {
                    shot++
                }
                
            }
        }
        
        if shot == shotCount {
            let move = SKAction.moveByX(20, y: 0, duration: 2)
            let die = SKAction.removeFromParent()
            let seq = SKAction.sequence([move, die])
            self.runAction(seq)
            death()
        }
        if !shooting {
            var speed = (chara.position.y - (self.position.y + 40))/35
            if speed > 2.5 {
                speed = 2.5
            }
            else if speed < -2.5 {
                speed = -2.5
            }
            position.y += speed
        }
        
    }
    
    func death() {
        planTimer = 1000
        shootTimer = 1000
        dad.on = true
    }
}