//
//  CloudGenerator2.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/7/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class PowerUpGenerator: SKSpriteNode {
    
    var generationTimer: NSTimer!
    var counter: Int = 0
    var check: Int = 0
    
    var on = true
    
    var timerSeconds: Double!
    
    var powerUps = [PowerUp]()
    
    var difference: NSTimeInterval!
    
    func startGeneratingWithSpawnTime(seconds: NSTimeInterval) {
        timerSeconds = seconds
        let myDouble = NSNumber(double: timerSeconds/Double(difficulty))
        let time = NSTimeInterval(myDouble.doubleValue)
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generatePowerUp", userInfo: nil, repeats: false)
    }
    
    func stopGenerating() {
        generationTimer.invalidate()
    }
    
    func pauseGenerating() {
        difference = generationTimer?.fireDate.timeIntervalSinceNow
        generationTimer?.invalidate()
    }
    
    func resumeGenerating() {
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(difference, target: self, selector: "generatePowerUp", userInfo: nil, repeats: false)
        
    }
    
    func moveFaster() {
        let moveLeft = SKAction.moveByX(difficulty * -115, y: 0, duration: 1)
        for child in children {
            child.runAction(SKAction.repeatActionForever(moveLeft))
        }
    }
    
    func generatePowerUp() {
        var texture: SKTexture!
        var type: Int = 0
        let chance = arc4random_uniform(5)
        let chance2 = arc4random_uniform(3)
        let r = arc4random_uniform(2)
        
        let char = parent!.childNodeWithName("char") as! Char
        if char.normal {
        if chance == 0 {
            texture = moneyTokenTexture1
        }
        else if chance == 1 {
            texture = miniTokenTexture1
        }
        else if chance == 2 {
            texture = muscleTokenTexture1
        }
        else if chance == 3 {
            texture = shooterTokenTexture1
        }
        else if chance == 4 {
            texture = superTokenTexture1
        }

        let powerUp = PowerUp(texture: texture)
        let x = screenSize.width + powerUp.size.width
        let y = CGFloat(arc4random_uniform(UInt32(screenSize.height - powerUp.size.height * 2.04))) + powerUp.size.height * 1.02
        powerUp.position = CGPointMake(x, y)
        powerUp.zPosition = 100
        powerUp.name = String(counter)
        counter++
        
        if on && difficulty > 1.36 {
            powerUps.append(powerUp)
            if chance2 != 1 {
                addChild(powerUp)
            }
        }
        }
        let myDouble = NSNumber(double: timerSeconds/Double(difficulty))
        let time = NSTimeInterval(myDouble.doubleValue)
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generatePowerUp", userInfo: nil, repeats: false)
    }
    
    func stopPowerUps() {
        stopGenerating()
        for powerUp in powerUps {
            powerUp.stopMoving()
        }
    }
    
    func update() {
        var index = 0
        for powerUp in powerUps {
            powerUp.update()
            if powerUp.position.x < 120 {
                physicsBody?.collisionBitMask = 0
                physicsBody?.contactTestBitMask = 0
            }
            if powerUp.position.x < -20 {
                powerUp.position.x = 1200
                powerUp.removeFromParent()
                //powerUps.removeAtIndex(index)
            }
            index++
        }
    }
    
}