//
//  Bullet.swift
//  Jumper
//
//  Created by Andrew on 6/20/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet2: SKSpriteNode {
    
    var timer = 0
    var velX: CGFloat = 0
    var velY: CGFloat = 0
    var gravity: CGFloat = -0.04 * screenSize.height/375
    var active = true
    
    init (texture: SKTexture) {
        
        super.init(texture: texture, color: nil, size: texture.size())
        
        changeSize(0.1 * screenSize.width/667, h: 0.13 * screenSize.height/375)
        
        setPhysicsBody(size.width * 0.72, height: size.height * 0.32)
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / -3, duration: 0.05)
        self.runAction(SKAction.repeatActionForever(rotate))
        
    }
    
    func setPhysicsBody(width: CGFloat, height: CGFloat) {
        let size = CGSize(width: width, height: height)
        var body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        body.dynamic = true
        body.categoryBitMask = BodyType.bullet.rawValue
        body.affectedByGravity = false
        body.collisionBitMask = BodyType.enemy.rawValue | BodyType.rotater.rawValue | BodyType.rotateArms.rawValue | BodyType.wall2.rawValue | BodyType.nothing.rawValue
        body.contactTestBitMask = BodyType.enemy.rawValue | BodyType.rotater.rawValue | BodyType.rotateArms.rawValue | BodyType.wall2.rawValue | BodyType.nothing.rawValue
        self.physicsBody = body
    }
    
    func changeSize(w: CGFloat, h: CGFloat) {
        self.size.width = self.size.width * w
        self.size.height = self.size.height * h
    }
    
    func changeSpeed(x: CGFloat, y: CGFloat) {
        velX = (16*x/sqrt(x*x+y*y)) * screenSize.width/667
        velY = (16*y/sqrt(x*x+y*y)) * screenSize.height/375
        
        if velX < 0 {
            velX = -velX
        }
    }
    
    func update() {
        velY = velY + gravity
        
        self.position.x = self.position.x + velX
        self.position.y = self.position.y + velY
        
        if position.x > screenSize.width + 200 || position.y < -400 {
            position.x = 0
            position.y = 0
            removeFromParent()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}