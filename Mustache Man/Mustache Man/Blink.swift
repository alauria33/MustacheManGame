////  Slider.swift
//  Jumper
//
//  Created by Andrew on 6/21/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Blink: SKSpriteNode {

    var timerb = 140
    
    init () {
        
        super.init(texture: invisble, color: nil, size: invisble.size())
        
    }
    
    func changeTexture(imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        self.texture = imageTexture
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        if timerb < 170 {
            self.texture = invisble
            timerb++
        }
        else if timerb == 170 {
            self.texture = blink1
            timerb++
        }
        else if timerb < 172 {
            timerb++
        }
        else if timerb == 172 {
            self.texture = blink2
            timerb++
        }
        else if timerb < 174 {
            timerb++
        }
        else if timerb == 174 {
            self.texture = blink3
            timerb++
        }
        else if timerb < 176 {
            timerb++
        }
        else if timerb == 176 {
            self.texture = blink4
            timerb++
        }
        else if timerb < 182 {
            timerb++
        }
        else if timerb == 182 {
            self.texture = blink3
            timerb++
        }
        else if timerb < 184 {
            timerb++
        }
        else if timerb == 184 {
            self.texture = blink2
            timerb++
        }
        else if timerb < 186 {
            timerb++
        }
        else if timerb == 186 {
            self.texture = blink1
            timerb++
        }
        else if timerb < 188 {
            timerb++
        }
        else {
            if timerb ==  188 {
                timerb = -30
            }
            timerb++
        }
    }
    
}