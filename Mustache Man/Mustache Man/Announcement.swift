//
//  ALPointsLabel.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/8/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Announcement: SKLabelNode {
    
    init(words: String, color: UIColor) {
        super.init()
        
        fontColor = color
        fontName = "ChalkboardSE-Bold"
        fontSize = 28 * screenSize.width/667
        zPosition = 200

        text = words
        position = CGPointMake(screenSize.width/2, screenSize.height/1.23)
        self.runAction(SKAction.sequence([SKAction.waitForDuration(2.5), SKAction.fadeAlphaTo(0.0, duration: 0.5), SKAction.removeFromParent()]))
        
        if screenSize.height > 550 {
            position.y = screenSize.height/1.12
        }
        
        if color == UIColor.blackColor() {
            position = CGPointMake(screenSize.width/3.5, screenSize.height/7.5)
            fontSize = 35 * screenSize.width/667
            alpha = 0.0
            self.runAction(SKAction.sequence([SKAction.waitForDuration(0.3), SKAction.fadeAlphaTo(1.0, duration: 0.5), SKAction.waitForDuration(1.7), SKAction.fadeAlphaTo(0.0, duration: 0.5), SKAction.removeFromParent()]))
        }
        else {
            self.runAction(SKAction.sequence([SKAction.waitForDuration(2.5), SKAction.fadeAlphaTo(0.0, duration: 0.5), SKAction.removeFromParent()]))
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}