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

class PointAddition: SKLabelNode {
    
    var number = 0
    var on = true
    
    init(num: Int, color: UIColor) {
        super.init()
        
        fontColor = color
        fontSize = 19 * screenSize.width/667
        fontName = "ChalkboardSE-Regular"
        zPosition = -10
        position = CGPointMake(screenSize.width/7, screenSize.height - 63 * screenSize.height/375)
        if num > 999 {
            position = CGPointMake(screenSize.width/6.5, screenSize.height - 63 * screenSize.height/375)
        }
        number = num
        text = "+\(num)"
        
        runAction(moveUp())
        runAction(fadeOut())
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func halfIncrement() {
        if on {
            number++
        }
        on = !on
        text = "\(number)"
    }
    
    func increment() {
        number++
        text = "\(number)"
    }
    
    func add(x: Int) {
        number = number + x
        text = "\(number)"
    }
    
    func setTo(num: Int) {
        self.number = num
        text = "\(self.number)"
    }
    
    func getNum() -> Int {
        return self.number
    }
    
    func moveUp() -> SKAction {
        let moveUp = SKAction.moveByX(0, y: 14, duration: 1)
        return moveUp
    }
    
    func fadeOut() -> SKAction {
        let wait = SKAction.fadeAlphaTo(1.0, duration: 0.8)
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        let die = SKAction.removeFromParent()
        return SKAction.sequence([wait, fadeOut, die])
    }
}


