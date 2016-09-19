//
//  ALWallGenerator.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/8/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class BirdGenerator: SKSpriteNode {
    
    var generationTimer: NSTimer?
    var birds = [Bird]()
    var birdTrackers = [Bird]()
    var timerSeconds: Double!
    var on = true
    var difference: NSTimeInterval!
    
    func startGeneratingBirdsEvery(seconds: Double) {
        timerSeconds = seconds
        let myDouble = NSNumber(double: timerSeconds)
        let time = NSTimeInterval(myDouble.doubleValue)
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generateBird", userInfo: nil, repeats: false)
        
    }
    
    func stopGenerating() {
        generationTimer?.invalidate()
    }

    func pauseGenerating() {
        difference = generationTimer?.fireDate.timeIntervalSinceNow
        generationTimer?.invalidate()
    }
    
    func resumeGenerating() {
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(difference, target: self, selector: "generateBird", userInfo: nil, repeats: false)
        
    }
    
    func generateBird() {
        var scale: Int
        var rand = Int(arc4random_uniform(5))
        var rand2 = arc4random_uniform(2)
        var rand3 = CGFloat(arc4random_uniform(5)) + 0.01
        var two = CGFloat(arc4random_uniform(6))
        var chance = arc4random_uniform(3)
 
        if rand2 == 0 {
            scale = 1
        }
            
        else {
            scale = -1
        }
        
        let bird = Bird()
        bird.position.x = screenSize.width + bird.size.width
        bird.position.y = CGFloat(arc4random_uniform(UInt32(screenSize.height - bird.size.height/2))) + bird.size.height/3.5
        if bird.position.y > screenSize.height/2 {
            bird.velY = -(rand3/7) * screenSize.height/320
            if bird.velY > 0 {
                bird.velY = 0
            }
        }
        else if bird.position.y > screenSize.height/4 {
            bird.velY = (rand3/7) * screenSize.height/320
            if bird.velY < 0 {
                bird.velY = 0
            }
        }
        else {
            bird.velY = 0.7 * screenSize.height/320
        }
        bird.zPosition = 50
        
        if on && chance == 1 && difficulty > 1.4 {
            birds.append(bird)
            birdTrackers.append(bird)
            addChild(bird)
        }
        
        let myDouble = NSNumber(double: timerSeconds/Double(difficulty))
        let time = NSTimeInterval(myDouble.doubleValue)
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generateBird", userInfo: nil, repeats: false)
    }
    
    func moveFaster() {
        let moveLeft = SKAction.moveByX(difficulty * -128 * screenSize.width/667, y: 0, duration: 1)
        for child in children {
            child.runAction(SKAction.repeatActionForever(moveLeft))
        }
    }
    
    func stopBirds() {
        stopGenerating()
        for bird in birds {
            bird.stopMoving()
        }
    }
    
    func update() {
        for bird in birds {
            bird.update()
        }
    }
    
}