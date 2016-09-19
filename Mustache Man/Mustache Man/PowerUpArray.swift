//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class PowerUpArray: SKSpriteNode {
    
    var amount: Int = 0
    var powerUps = [PowerUpToken]()
    var i: Int!
    var count: Int = 0
    
    init () {
        
        super.init(texture: barTexture, color: UIColor.clearColor(), size: CGSizeMake(0,0))
        size = CGSizeMake(221.0 * screenSize.width/568, 110.5 * screenSize.height/320)
        //size = CGSizeMake(barTexture.size().width * 0.13 * screenSize.width/568, barTexture.size().height * 0.13 * screenSize.height/320)
        position = CGPointMake(screenSize.width/1.05 - size.width/2, self.size.height/4.3)
        self.zPosition = 290
        setPhysicsBodyWithSize(size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhysicsBodyWithSize(size: CGSize) {
        let size = CGSizeMake(size.width, size.height * 0.45)
        var body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        body.dynamic = false
        body.categoryBitMask = BodyType.array.rawValue
        body.collisionBitMask = BodyType.char.rawValue | BodyType.powerup.rawValue | BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.bullet.rawValue | BodyType.heart.rawValue | BodyType.stacheBag.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue | BodyType.beam.rawValue 
        body.contactTestBitMask = BodyType.char.rawValue | BodyType.powerup.rawValue | BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.bullet.rawValue | BodyType.heart.rawValue | BodyType.stacheBag.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue | BodyType.beam.rawValue
        body.affectedByGravity = false
        self.physicsBody = body
        physicsBody?.mass = 0.01
    }
    
    func addPowerUp(texture: SKTexture) {
        let token = PowerUpToken(texture: texture)
        token.slot = 0
        token.alpha = self.alpha
        parent!.addChild(token)
        powerUps.insert(token, atIndex: 0)
        i = 0
        for token in powerUps {
            token.change(i)
            i = i + 1
        }
        while powerUps.count >= 4 {
            powerUps.removeAtIndex(3)
        }
    }

    func removePowerUp(powerUp: PowerUpToken) {
        let local = powerUp.slot
        powerUps.removeAtIndex(local)
        powerUp.removeFromParent()
        i = 0
        for token in powerUps {
            token.change(i)
            i = i + 1
        }
    }
    
}