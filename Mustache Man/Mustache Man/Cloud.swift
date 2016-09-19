//
//  ALCloud.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/7/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Cloud: SKSpriteNode {
    
    init(texture: SKTexture, size: CGSize, orient: Int) {
        super.init(texture: texture, color: nil, size: size)
        
        if orient == 1 {
            self.xScale = -1.0
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveByX(difficulty * -10 * screenSize.width/667, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    func startMovingFast() {
        self.removeAllActions()
        let moveLeft = SKAction.moveByX(difficulty * -200 * screenSize.width/667, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    func startMovingSlow() {
        self.removeAllActions()
        let moveLeft = SKAction.moveByX(-10 * screenSize.width/667, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    
}