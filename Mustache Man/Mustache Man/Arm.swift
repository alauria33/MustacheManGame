//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Arm: SKSpriteNode {
    
    var timer = 0
    var degree: CGFloat = 0
    
    init (texture: SKTexture) {
        
        super.init(texture: texture, color: nil, size: texture.size())
        
        changeSize(0.5 * screenSize.width/667, h: 0.5 * screenSize.height/375)
        
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
    
    func rotate(a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat) {
        let x = a - self.position.x - c
        var y = b - self.position.y - d
        
        var angle = atan(x/y)
        if angle <= 0 {
            angle = angle + CGFloat(M_PI)
        }
        let diffangle = degree - angle
        
        degree = angle
        
        let rotate = SKAction.rotateByAngle(diffangle, duration: 0.0)
        runAction(rotate)
    }
    
}