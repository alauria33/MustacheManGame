//
//  CloudGenerator2.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/7/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class CloudGenerator: SKSpriteNode {
    
    var CLOUD_WIDTH: CGFloat = 125.0
    var CLOUD_HEIGHT: CGFloat = 55.0
    
    var generationTimer: NSTimer!
    var counter: Int = 0
    var check: Int = 0
    var timerSeconds: Double!
    var on = true
    var difference: NSTimeInterval!
    
    func populate(num: Int) {
        for var i = 0; i < num; i++ {
            CLOUD_WIDTH = CGFloat(100 + arc4random_uniform(50)) * screenSize.width/677
            CLOUD_HEIGHT = CGFloat(55 + arc4random_uniform(25)) * screenSize.height/375
            let r = arc4random_uniform(2)
            let cloud = Cloud(texture: cloudTexture, size: CGSizeMake(CLOUD_WIDTH, CLOUD_HEIGHT), orient: Int(r))
            let x = CGFloat(arc4random_uniform(UInt32(screenSize.width)))
            let y = CGFloat(arc4random_uniform(UInt32(screenSize.height)))
            cloud.position = CGPointMake(x, y)
            cloud.zPosition = -2
            cloud.name = String(i)
            cloud.startMoving()
            addChild(cloud)
            counter++
        }
    }
    
    func moveFaster() {
        check = 1
        for var i = 0; i < counter; i++ {
            var cloud = childNodeWithName(String(i)) as! Cloud
            cloud.startMovingFast()
        }
    }
    
    func moveSlower() {
        check = 0
        for var i = 0; i < counter; i++ {
            var cloud = childNodeWithName(String(i)) as! Cloud
            cloud.startMovingSlow()
        }
    }
    
    func startGeneratingWithSpawnTime(seconds: Double) {
        timerSeconds = seconds
        let myDouble = NSNumber(double: timerSeconds/Double(difficulty))
        let time = NSTimeInterval(myDouble.doubleValue)
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generateCloud", userInfo: nil, repeats: false)
    }
    
    func stopGenerating() {
        generationTimer.invalidate()
    }
    
    func pauseGenerating() {
        difference = generationTimer?.fireDate.timeIntervalSinceNow
        generationTimer?.invalidate()
    }
    
    func resumeGenerating() {
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(difference, target: self, selector: "generateCloud", userInfo: nil, repeats: false)
        
    }
    
    func generateFirstCloud() {
        let r = arc4random_uniform(2)
        CLOUD_WIDTH = CGFloat(80 + arc4random_uniform(100)) * screenSize.width/667
        CLOUD_HEIGHT = CGFloat(55 + arc4random_uniform(50)) * screenSize.height/375
        let cloud = Cloud(texture: cloudTexture, size: CGSizeMake(CLOUD_WIDTH, CLOUD_HEIGHT), orient: Int(r))
        let x = screenSize.width + cloud.size.width + 100 * screenSize.width/677
        let y = CGFloat(arc4random_uniform(UInt32(screenSize.height)))
        cloud.position = CGPointMake(x, y)
        cloud.zPosition = -3
        cloud.name = String(counter)
        if(check == 0) {
            cloud.startMoving()
        }
        else{
            cloud.startMovingFast()
        }
        
        counter++
        addChild(cloud)
    }
    
    func generateCloud() {
        let x = screenSize.width + CLOUD_WIDTH/2
        let y = CGFloat(arc4random_uniform(UInt32(screenSize.height)))
        let r = arc4random_uniform(2)
        CLOUD_WIDTH = CGFloat(80 + arc4random_uniform(80)) * screenSize.width/568
        CLOUD_HEIGHT = CGFloat(55 + arc4random_uniform(50)) * screenSize.height/320
        let cloud = Cloud(texture: cloudTexture, size: CGSizeMake(CLOUD_WIDTH, CLOUD_HEIGHT), orient: Int(r))
        cloud.position = CGPointMake(x, y)
        cloud.zPosition = -3
        cloud.name = String(counter)
        if(check == 0) {
            cloud.startMoving()
        }
        else{
            cloud.startMovingFast()
        }
        
        if r == 1 {
            let imageTexture = invisble
            cloud.texture = imageTexture
        }
        if on {
            counter++
            addChild(cloud)
        }
        
        let myDouble = NSNumber(double: timerSeconds/Double(difficulty))
        let time = NSTimeInterval(myDouble.doubleValue)
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generateCloud", userInfo: nil, repeats: false)
    }
    
    func update() {
        for var i = 0; i < counter; i++ {
            var cloud = childNodeWithName(String(i)) as! Cloud
            if cloud.position.x < 100 {
                cloud.removeFromParent()
            }
        }
    }
    
}