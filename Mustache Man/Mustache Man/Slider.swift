////  Slider.swift
//  Jumper
//
//  Created by Andrew on 6/21/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Slider: SKSpriteNode {
    
    var isGrabbed = false
    var moveDown = false
    var moveUp = true
    
    init () {

        super.init(texture: sliderTexture, color: nil, size: sliderTexture.size())
        
        self.zPosition = 52
        
        setPhysicsBody(sliderTexture.size().width, height: sliderTexture.size().height)
        
    }
    
    func setPhysicsBody(width: CGFloat, height: CGFloat) {
        let size = CGSize(width: width, height: height)
        var body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        
        body.dynamic = false
        body.categoryBitMask = BodyType.slider.rawValue
        body.affectedByGravity = false
        self.physicsBody = body
    }
    
    func changeTexture(imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        self.texture = imageTexture
        
    }
    
    func update() {
        // update when told to by the GameScene class
        //do things for certain states
        
        if (isGrabbed == false && self.position.y >= screenSize.height/2 + 12) {
            
            self.position.y -= 20
        }
        else if (isGrabbed == false && self.position.y < screenSize.height/2 - 12) {
            self.position.y += 20
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}