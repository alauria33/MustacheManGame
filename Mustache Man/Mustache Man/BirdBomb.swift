//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class BirdBomb: SKSpriteNode {
    
    var on = true
    
    init () {
        
        super.init(texture: bombTexture2, color: nil, size: CGSizeMake(bombTexture2.size().width * 0.035 * screenSize.width/667, bombTexture2.size().height * 0.035 * screenSize.height/375))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeSize(w: CGFloat, h: CGFloat) {
        self.size.width = self.size.width * w
        self.size.height = self.size.height * h
    }
    
    func update() {
        
    }
}