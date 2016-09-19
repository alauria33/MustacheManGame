//
//  ALWallGenerator.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/8/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class WallGenerator: SKSpriteNode {
    
    var generationTimer: NSTimer?
    var walls = [Wall]()
    var wallTrackers = [Wall]()
    var openWalls = [OpenWall]()
    var openWallTrackers = [OpenWall]()
    var on = true
    var body = SKPhysicsBody(texture: openWallTexture, alphaThreshold: 0.9, size: CGSizeMake(60, 250))
    var timerSeconds: Double!
    let bodyNode = SKSpriteNode()
    var difference: NSTimeInterval!
    
    init () {
        super.init(texture: invisble, color: nil, size: invisble.size())
        
    }
    
 
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
   func startGeneratingWallsEvery(seconds: Double) {
        timerSeconds = seconds
        let myDouble = NSNumber(double: timerSeconds/Double(difficulty))
        let time = NSTimeInterval(myDouble.doubleValue)
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generateWall", userInfo: nil, repeats: false)
        
    }
    
    func stopGenerating() {
        generationTimer?.invalidate()
    }
    
    func pauseGenerating() {
        difference = generationTimer?.fireDate.timeIntervalSinceNow
        generationTimer?.invalidate()
    }
    
    func resumeGenerating() {
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(difference, target: self, selector: "generateWall", userInfo: nil, repeats: false)
        
    }
    
    func generateWall() {
        var scale: Int
        var rand = Int(arc4random_uniform(7))
        var rand2 = arc4random_uniform(2)
        var rand3 = arc4random_uniform(7)
        var rand4 = Int(arc4random_uniform(218))
        var rand5 = CGFloat(arc4random_uniform(30))

        if rand2 == 0 {
            scale = 8/10
        }
            
        else {
            scale = -1
        }
        
        if rand3 > 2 {
            let wall = Wall(texture: spikeWallTexture)
            wall.position.x = screenSize.width + wall.size.width/1.8
            wall.position.y = CGFloat(arc4random_uniform(UInt32(screenSize.height - 1.8 * wall.size.height))) + wall.size.height - 10
            wall.velY = CGFloat(rand3 + 5)
            if on {
                walls.append(wall)
                wallTrackers.append(wall)
                addChild(wall)
            }
        }
            
        else {
            let openWall = OpenWall(texture: openWallTexture)
            openWall.position.x = screenSize.width + openWall.size.width/1.8
            openWall.position.y = -100 + CGFloat(arc4random_uniform(1 + UInt32(screenSize.height/1.9)))
            let topWall = TopWall(texture: topWallTexture)
            topWall.position.y = openWall.position.y + (352 + rand5 + 14/(0.5 + (difficulty * difficulty))) * screenSize.height/375
            topWall.position.x = screenSize.width + topWall.size.width/1.8
            //openWall.zPosition = 51
            if on {
                openWalls.append(openWall)
                openWallTrackers.append(openWall)
                addChild(openWall)
                addChild(topWall)
            }
        }
        
        let myDouble = NSNumber(double: timerSeconds/Double(difficulty))
        let time = NSTimeInterval(myDouble.doubleValue)
        
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generateWall", userInfo: nil, repeats: false)
    }
    
    func findWall(x: CGFloat) -> Wall {
        var tempWall: Wall!
        var dist: CGFloat
        var wallx: CGFloat
        var check: Int = 0
        var minDist: CGFloat = 1000
        var counter = 0
        var index = 0
        for wall in walls {
            check++
            wallx = wall.position.x + self.position.x
            dist = abs(wallx - x - 5)
            if dist < minDist && wall.state == 1 {
                tempWall = wall
                minDist = dist
                index = counter
            }
            counter++
        }
        //walls.removeAtIndex(index)
        tempWall.status = 1
        return tempWall
    }
    
    func stopWalls2() {
        for wall in walls {
            if wall.status == 0 && !wall.falling {
                wall.stopMoving()
            }
        }
        for child in children {//openWall in openWalls {
            let wall = child as? Wall
            var ok = true
            if wall != nil {
                if wall!.falling {
                    ok = false
                }
            }
            if ok {
                child.stopMoving()
            }
        }
    }
    
    func stopWalls() {
        stopGenerating()
        for wall in walls {
            if wall.status == 0 && !wall.falling {
                wall.stopMoving()
            }
        }
        for child in children {//openWall in openWalls {
            let wall = child as? Wall
            var ok = true
            if wall != nil {
                if wall!.falling {
                    ok = false
                }
            }
            if ok {
                child.stopMoving()
            }
        }
    }
    
    func moveFaster() {
        let moveLeft = SKAction.moveByX(difficulty * -100, y: 0, duration: 1)
        for child in children {
            child.runAction(SKAction.repeatActionForever(moveLeft))
        }
    }
    
    func update() {
        for wall in walls {
            wall.update()
        }
        
        for openWall in openWalls {
            if openWall.position.x < -10 {
                openWall.removeFromParent()
            }
        }
    }
    
}