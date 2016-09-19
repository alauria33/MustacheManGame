//
//  ALCloud.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/7/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class PowerUp: SKSpriteNode {
    
    var type: Int!
    var moneyTimer = 100, muscleTimer = 100, miniTimer = 100, shooterTimer = 100, superTimer = 100
    var live = true
    
    init(texture: SKTexture) {
        
        super.init(texture: texture, color: nil, size: texture.size())
        self.changeSize(0.14 * screenSize.width/667, h: 0.14 * screenSize.height/375)
        
        self.addPhysicsBodyWithSize(20)
        
        if texture == moneyTokenTexture1 {
            type = 1
            moneyTimer = 0
        }
        else if texture == muscleTokenTexture1 {
            type = 2
            muscleTimer = 0
        }
        else if texture == miniTokenTexture1 {
            type = 3
            miniTimer = 0
        }
        else if texture == shooterTokenTexture1 {
            type = 4
            shooterTimer = 0
        }
        else if texture == superTokenTexture1 {
            type = 5
            superTimer = 0
        }
        
        zPosition = 100
        
        startMoving()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysicsBodyWithSize(radius: CGFloat) {
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.categoryBitMask = BodyType.powerup.rawValue
        physicsBody?.collisionBitMask = 0//BodyType.wall.rawValue
        physicsBody?.contactTestBitMask = 0//BodyType.wall.rawValue
        physicsBody?.dynamic = true
        physicsBody?.mass = 0
        physicsBody?.affectedByGravity = false
    }
    
    func getType() -> Int {
        return type
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveByX(-(difficulty * 150 + CGFloat(arc4random_uniform(40))) * screenSize.width/667, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    func changeTexture(texture: SKTexture) {
        
        self.texture = texture
        
    }
    
    func changeSize(w: CGFloat, h: CGFloat) {
        self.size.width = self.size.width * w
        self.size.height = self.size.height * h
    }
    
    func remove() {
        self.position.x = 1000
        self.removeFromParent()
    }
    func startMovingFast() {
        self.removeAllActions()
        let moveLeft = SKAction.moveByX(-300 * screenSize.width/667, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    func startMovingSlow() {
        self.removeAllActions()
        let moveLeft = SKAction.moveByX(-10 * screenSize.width/667, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    func stopMoving() {
        removeAllActions()
        self.runAction(Animation())
    }
    
    func Animation() -> SKAction {
        let duration = 0.4
        let up = SKAction.moveBy(CGVector(dx: 0, dy: 5), duration: 0.8)
        let down = SKAction.moveBy(CGVector(dx: 0, dy: -5), duration: 0.8)
        let animate = SKAction.sequence([up, down])
        return SKAction.repeatActionForever(animate)
    }
    
    func update() {
        if moneyTimer < 6 {
            moneyTimer++
            self.texture = moneyTokenTexture1
        }
        else if moneyTimer < 12 {
            moneyTimer++
            self.texture = moneyTokenTexture2
        }
        else if moneyTimer < 18 {
            moneyTimer++
            self.texture = moneyTokenTexture3
        }
        else if moneyTimer < 24 {
            moneyTimer++
            self.texture = moneyTokenTexture4
            if moneyTimer == 24 {
                moneyTimer = 0
            }
        }
        
        
        if muscleTimer < 6 {
            muscleTimer++
            self.texture = muscleTokenTexture1
        }
        else if muscleTimer < 12 {
            muscleTimer++
            self.texture = muscleTokenTexture2
        }
        else if muscleTimer < 18 {
            muscleTimer++
            self.texture = muscleTokenTexture3
        }
        else if muscleTimer < 24 {
            muscleTimer++
            self.texture = muscleTokenTexture4
            if muscleTimer == 24 {
                muscleTimer = 0
            }
        }
        
        if miniTimer < 6 {
            miniTimer++
            self.texture = miniTokenTexture1
        }
        else if miniTimer < 12 {
            miniTimer++
            self.texture = miniTokenTexture2
        }
        else if miniTimer < 18 {
            miniTimer++
            self.texture = miniTokenTexture3
        }
        else if miniTimer < 24 {
            miniTimer++
            self.texture = miniTokenTexture4
            if miniTimer == 24 {
                miniTimer = 0
            }
        }
        
        if shooterTimer < 6 {
            shooterTimer++
            self.texture = shooterTokenTexture1
        }
        else if shooterTimer < 12 {
            shooterTimer++
            self.texture = shooterTokenTexture2
        }
        else if shooterTimer < 18 {
            shooterTimer++
            self.texture = shooterTokenTexture3
        }
        else if shooterTimer < 24 {
            shooterTimer++
            self.texture = shooterTokenTexture4
            if shooterTimer == 24 {
                shooterTimer = 0
            }
        }
        
        if superTimer < 6 {
            superTimer++
            self.texture = superTokenTexture1
        }
        else if superTimer < 12 {
            superTimer++
            self.texture = superTokenTexture2
        }
        else if superTimer < 18 {
            superTimer++
            self.texture = superTokenTexture3
        }
        else if superTimer < 24 {
            superTimer++
            self.texture = superTokenTexture4
            if superTimer == 24 {
                superTimer = 0
            }
        }
        
    }
}
