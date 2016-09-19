//
//  OpenWall.swift
//  Jumper
//
//  Created by Andrew on 7/2/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class OpenWall: SKSpriteNode {
    
    let WALL_WIDTH: CGFloat = 60.0 * screenSize.width/667
    let WALL_HEIGHT: CGFloat = 250.0 * screenSize.height/375
    let WALL_COLOR = UIColor(red: 87.0/255.0, green: 65.0/255.0, blue: 13.0/255.0, alpha: 1.0)
    var topWall: TopWall!
    var inside = false
    
    init(texture: SKTexture) {
        let size = CGSizeMake(WALL_WIDTH, WALL_HEIGHT)
        let sizep = CGSizeMake(WALL_WIDTH * 0.5, WALL_HEIGHT * 0.95)
        super.init(texture: texture, color: nil, size: size)
        
        //setPhysicsBody(texture, size: size)
        loadPhysicsBody(sizep)
        startMoving()
    }
    
    func loadPhysicsBody(size: CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.categoryBitMask = BodyType.wall.rawValue
        physicsBody?.collisionBitMask = 0//BodyType.wall.rawValue
        physicsBody?.contactTestBitMask = 0//BodyType.wall.rawValue
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 0.01
    }
    
    func setPhysicsBody(texture: SKTexture, size: CGSize) {
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.9, size: size)
        self.physicsBody?.categoryBitMask = BodyType.wall.rawValue
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
        let moveLeft = SKAction.moveByX(difficulty * -120 * screenSize.width/667, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    func stopMoving() {
        removeAllActions()
    }
    
}