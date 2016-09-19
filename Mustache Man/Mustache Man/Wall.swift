//
//  ALWall.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/8/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Wall: SKSpriteNode {
    
    var WALL_WIDTH: CGFloat = 40.0 * screenSize.width/568
    var WALL_HEIGHT: CGFloat = (100.0 + CGFloat(arc4random_uniform(40))) * screenSize.height/320
    let WALL_COLOR = UIColor(red: 87.0/255.0, green: 65.0/255.0, blue: 13.0/255.0, alpha: 1.0)
    var stop = 0
    var move = 0
    var velY: CGFloat = 0
    var stache: SKSpriteNode!
    var broke: SKSpriteNode!
    var state: Int = 1
    var timer = -5
    var status = 0
    var split: CGFloat!
    var relativeLocation: CGFloat!
    var direc: CGFloat!
    var speedplus: CGFloat!
    var rando = Double(arc4random_uniform(2))
    var falling = false
    
    var scale3: CGFloat!

    var inside = false
    
    init(texture: SKTexture) {
        let size = CGSizeMake(WALL_WIDTH, WALL_HEIGHT)
        super.init(texture: texture, color: nil, size: size)
        
        loadPhysicsBodyWithSize(size)
        startMoving()
        
        if rando == 0 {
            scale3 = 1
            move = 1
        }
        else {
            scale3 = -1
            move = 0
        }
        
        speedplus = scale3 * (0.5 + CGFloat(arc4random_uniform(2))) * difficulty * screenSize.width/667
        
        zPosition = 10
        
        var rand2 = Double(arc4random_uniform(2))
        
        if rand2 == 0 {
            move = 1
        }
        else {
            move = 0
        }
        
    }
    
    func loadPhysicsBodyWithSize(size: CGSize) {
        let size = CGSizeMake(size.width * 0.78, size.height * 0.9)
        physicsBody = SKPhysicsBody(rectangleOfSize: size, center: CGPointMake(-WALL_WIDTH/20, WALL_HEIGHT/24))
        physicsBody?.categoryBitMask = BodyType.wall2.rawValue
        physicsBody?.collisionBitMask = 0//BodyType.wall.rawValue
        physicsBody?.contactTestBitMask = 0//BodyType.wall.rawValue
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 0.01
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveByX(difficulty * -100 * screenSize.width/667, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    func startMoving2() {
        let moveRight = SKAction.moveByX(50 * screenSize.width/667, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveRight))
    }
    
    func startMoving3() {
        let moveDown = SKAction.moveByX(0, y: -400 * screenSize.width/667, duration: 1)
        runAction(SKAction.repeatActionForever(moveDown))
    }
    
    func stopMoving() {
        removeAllActions()
        stop = 1
    }
    
    func addPrick() {
        var rand2 = arc4random_uniform(2)
        var rand3 = arc4random_uniform(5)
        var scale: Double
        var prick: SKSpriteNode
        
        if rand2 == 0 {
            scale = 1
        }
        else {
            scale = -1
        }
        
        var denom = CGFloat(2 + scale * (Double((arc4random_uniform(3)))/10))
        
        prick = SKSpriteNode(texture: prickTexture)
        let y: CGFloat = WALL_HEIGHT/8 * CGFloat(scale) * CGFloat(rand3) - 25
        let x = (-3 * CGFloat(rand3)) - 15
        prick.position = CGPointMake(x, y)
        prick.zPosition = 15
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / (CGFloat(scale) * (12 + CGFloat(rand2))), duration: 0.0)
        prick.runAction(rotate)
        let rotate2 = SKAction.rotateByAngle(CGFloat(M_PI) / 0.2 * CGFloat(rand3 + 1) * CGFloat(scale), duration: 4.0)
        prick.runAction(rotate2)
        prick.size.width = prick.size.width * 0.85
        prick.size.height = prick.size.height * 0.5
        
        //prick.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        //prick.physicsBody?.allowsRotation = false
        prick.zRotation = -1
        addChild(prick)
        /*parent!.addChild(prick)

        let moveRight = SKAction.moveByX(50 * difficulty, y: 0, duration: 1)
        prick.runAction(SKAction.repeatActionForever(moveRight))

        let moveDown = SKAction.moveByX(0, y: -300, duration: 1)
        prick.runAction(SKAction.repeatActionForever(moveDown))*/
    }
    
    func addStache(h: CGFloat) {
        var rand2 = arc4random_uniform(2)
        var rand3 = arc4random_uniform(5)
        var scale: Double
        
        if rand2 == 0 {
            scale = 1
        }
        else {
            scale = -1
        }
        
        var denom = CGFloat(2 + scale*(Double((arc4random_uniform(3)))/10))
        
        stache = SKSpriteNode(imageNamed: "stache")
        stache.position = CGPointMake(-16, 0)
        stache.zPosition = 1
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / denom, duration: 0.0)
        stache.runAction(rotate)
        stache.size.width = stache.size.width * 0.3
        stache.size.height = stache.size.height * 0.3
        addChild(stache)
    }
    
    func addBroke(h2: CGFloat) {
        var rand2 = Double(arc4random_uniform(2))
        var rand3 = Double(arc4random_uniform(5))
        var rand4 = Double(arc4random_uniform(8))
        var scale: Double
        
        if rand2 == 0 {
            scale = 1
        }
        else {
            scale = -1
        }
        
        var denom = CGFloat(2 + scale*(Double((arc4random_uniform(3)))/10))
        
        let size = CGSizeMake(WALL_WIDTH, WALL_HEIGHT)
        broke = SKSpriteNode(texture: bottomBrokeTexture, color: nil, size: size)
        let x = CGFloat(-20 * WALL_WIDTH/40)//CGFloat(-20 + (rand4 * scale))
        let y = (1 + h2) * CGFloat(-20 * WALL_HEIGHT/100)//CGFloat(-40 + (rand4 * scale))
        broke.position = CGPointMake(x, y)
        broke.zPosition = 10
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / -4.2 , duration: 0.0)
        broke.runAction(rotate)
        let rotate2 = SKAction.rotateByAngle(CGFloat(M_PI) / -0.2 , duration: 1.5)
        //broke.runAction(rotate2)
        broke.size.width = broke.size.width * 1.4
        broke.size.height = broke.size.height * 1.1 * h2
        addChild(broke)
    }
    
    func changeTexture(imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        self.texture = imageTexture
        
    }
    
    func changeSize(w: CGFloat, h: CGFloat) {
        self.size.width = self.size.width * w
        self.size.height = self.size.height * h
    }
    
    func update() {
        
        if position.x < -30 || position.y < -30 {
            removeFromParent()
        }
        
        if stop == 0 {
            if timer < 0 {
                if self.position.y > screenSize.height - self.size.height/2 || self.position.y < (0 + self.size.height/2.3)  {
                    speedplus = speedplus * -1
                }
                self.position.y = self.position.y + CGFloat(speedplus)
            }
                
            else if timer == 0 {
                stopMoving()
                startMoving2()
                startMoving3()
                falling = true
                self.physicsBody = nil
                let dist = split - parent!.position.y - self.position.y + self.size.height/2
                var h = 1 - dist/self.size.height
                
                if h < 0.2 {
                    h = 0.2
                }
                else if h > 0.8 {
                    h = 0.8
                }
                
                var h2 = 1 - h
                
                for var i = 0; i < 4; i++ {
                    addPrick()
                }
                
                
                self.texture = topBrokeTexture
                self.anchorPoint = CGPointMake(0.5, 0.0)
                addStache(h)
                self.position.y = split - parent!.position.y + self.size.height/1.8
                changeSize(1.4, h: 1.1 * h)
                if h < 0.5 {
                    self.position.x = self.position.x + 5
                    let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / -10 , duration: 0)
                    self.runAction(rotate)
                    let rotate2 = SKAction.rotateByAngle(CGFloat(M_PI) / -0.2 , duration: 3)
                    self.runAction(rotate2)
                }
                else {
                    self.position.x = self.position.x + 7
                    let rotate2 = SKAction.rotateByAngle(CGFloat(M_PI) / 0.2 , duration: 3)
                    self.runAction(rotate2)
                }
                addBroke(h2)
                if abs(direc) > 45 {
                    let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / (direc/25) , duration: 0.0)
                    self.runAction(rotate)
                }
                stache?.removeFromParent()
                self.position.y = self.position.y  - CGFloat(20)
                self.position.x = self.position.x + CGFloat(20)
                timer++
            }
            else if timer < 15 {
                timer++
            }
            else if timer == 20 {
                self.removeFromParent()
            }
        }
    }
    
}