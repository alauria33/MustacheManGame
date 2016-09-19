//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class PowerUpToken: SKSpriteNode {
    
    var slot: Int = 1
    var isPressed = false
    
    init (texture: SKTexture) {

        super.init(texture: texture, color: nil, size: CGSizeMake(texture.size().width * screenSize.width/568 * 0.14, texture.size().height * screenSize.height/320 * 0.14))
        
        if texture == moneyTokenTexture1G {
            size.width *= 4.918 * screenSize.width/667
            size.height *= 4.918 * screenSize.height/375
        }
        
        position.y = (110.5 * screenSize.height/320)/3.6 - self.size.height/2 + 14 * screenSize.height/320
        self.zPosition = 291
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func change(i: Int) {
        slot = i
        if i == 3 {
            removeFromParent()
        }
        else if i == 0 {
            position.x = (screenSize.width/1.005 - (221.0 * screenSize.width/568)/2) + -97 * screenSize.width/568
        }
        else if i == 1 {
            position.x = (screenSize.width/1.005 - (221.0 * screenSize.width/568)/2) - 26 * screenSize.width/568
        }
        else if i == 2 {
            position.x = (screenSize.width/1.005 - (221.0 * screenSize.width/568)/2) + 44 * screenSize.width/568
        }
    }
    
    func getType() -> Int {
        var val = 0
        if self.texture == moneyTokenTexture1G {
            val = 1
        }
        else if self.texture == muscleTokenTexture1 {
            val = 2
        }
        else if self.texture == miniTokenTexture1 {
            val = 3
        }
        else if self.texture == shooterTokenTexture1 {
            val = 4
        }
        else if self.texture == superTokenTexture1 {
            val = 5
        }
        return val
    }
    
    func moveBackSlot() {
        slot--
        if slot == 1 {
            
        }
        if slot == 2 {
            
        }
        if slot == 3 {
            
        }
        if slot == 4 {
            self.removeFromParent()
        }
    }
    
    func moveForwardSlot() {
        slot--
        if slot == 0 {
            self.removeFromParent()
        }
        if slot == 1 {
            
        }
        if slot == 2 {
            
        }
        if slot == 3 {
        }
    }
    
    func changeTexture(texture: SKTexture) {
        
        self.texture = texture
        
    }
    
    func changeSize(w: CGFloat, h: CGFloat) {
        self.size.width = self.size.width * w
        self.size.height = self.size.height * h
    }
    
    func remove() {
        
    }
    
}