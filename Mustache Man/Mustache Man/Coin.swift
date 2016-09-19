//
//  ALCloud.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/7/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode {
    
    var coinValue: Int = 0
    var active = true
    
    init(texture: SKTexture) {
        super.init(texture: texture, color: nil, size: texture.size())
        self.changeSize(0.032 * screenSize.width/667, h: 0.032 * screenSize.height/375)
        
        zPosition = 100
        
        startMoving()
        //self.runAction(Animation())
        self.addPhysicsBodyWithSize(11 * screenSize.width/667)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysicsBodyWithSize(radius: CGFloat) {
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.categoryBitMask = BodyType.coin.rawValue
        physicsBody?.collisionBitMask = 0//BodyType.wall.rawValue
        physicsBody?.contactTestBitMask = 0//BodyType.wall.rawValue
        physicsBody?.dynamic = true
        physicsBody?.mass = 0
        physicsBody?.affectedByGravity = false
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveByX(difficulty * -140 * screenSize.width/667, y: 0, duration: 1)
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
    
    func getValue() -> Int {
        return coinValue
    }
    
    func Animation() -> SKAction {
        let duration = 0.4
        let up = SKAction.moveBy(CGVector(dx: 0, dy: 5), duration: 0.8)
        let down = SKAction.moveBy(CGVector(dx: 0, dy: -5), duration: 0.8)
        let animate = SKAction.sequence([up, down])
        return SKAction.repeatActionForever(animate)
    }
}

