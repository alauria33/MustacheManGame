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

class PointsLabel: SKLabelNode {
    
    var number = 0
    var on = true
    
    init(num: Int) {
        super.init()
        
        fontColor = UIColor.blackColor()
        fontName = "ChalkboardSE-Regular"
        fontSize = 20.0 * screenSize.width/667
        zPosition = -10
        
        number = num
        text = "\(num)"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func colon(num: Int) {
        text = ": \(num)"
    }
    
    func halfIncrement() {
        if on {
            number++
        }
        on = !on
        text = "\(number)"
    }
    
    func doubleIncrement() {
        number = number + 2
        text = "\(number)"
    }
    
    func increment() {
        if difficulty < 1.5 {
            number = number + 1
        }
        else if difficulty < 1.9 {
            number = number + 2
        }
        else if difficulty < 2.3 {
            number = number + 3
        }
        else if difficulty < 3 {
            number = number + 4
        }
        else {
            number = number + 1
        }
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
    
}
