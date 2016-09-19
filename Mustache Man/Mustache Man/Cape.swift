//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Cape: SKSpriteNode {
    
    var timer = 0
    
    init () {
        
        super.init(texture: capeTexture, color: nil, size: capeTexture.size())
        self.zPosition = 31
        
        changeSize(0.5 * 2.264 * screenSize.width/667, h: 0.5 * 2.264 * screenSize.height/375)
        
        self.runAction(Animation())
        //setPhysicsBody(imageTexture.size().width, height: imageTexture.size().height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhysicsBody(width: CGFloat, height: CGFloat) {
        let size = CGSize(width: 50, height: 30)
        var body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody = body
    }
    
    func changeTexture(texture: SKTexture) {
        
        self.texture = texture
        
    }
    
    func changeSize(w: CGFloat, h: CGFloat) {
        self.size.width = self.size.width * w
        self.size.height = self.size.height * h
    }
    
    func Animation() -> SKAction {
        let duration = 0.4
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / 22, duration: 0.3)
        let rotateBack2 = SKAction.rotateByAngle(CGFloat(M_PI) / -22, duration: 0.3)
        let animate = SKAction.sequence([rotateBack, rotateBack2])
        return SKAction.repeatActionForever(animate)
    }
}