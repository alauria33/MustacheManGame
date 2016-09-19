//
//  ALWallGenerator.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/8/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyGenerator: SKSpriteNode {
    
    var generationTimer: NSTimer?
    var enemys = [Enemy]()
    var rotaters = [Rotater]()
    var enemyTrackers = [Enemy]()
    var timerSeconds: Double!
    var gunner: Gunner!
    var on = true
    var rCount: Int = 4
    var gCount: Int = 6
    var difference: NSTimeInterval!
    
    func startGeneratingEnemysEvery(seconds: Double) {
        timerSeconds = seconds
        let myDouble = NSNumber(double: timerSeconds/Double(difficulty))
        let time = NSTimeInterval(myDouble.doubleValue)
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generateEnemy", userInfo: nil, repeats: false)
        
    }
    
    func stopGenerating() {
        generationTimer?.invalidate()
    }
    
    func pauseGenerating() {
        difference = generationTimer?.fireDate.timeIntervalSinceNow
        generationTimer?.invalidate()
    }
    
    func resumeGenerating() {
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(difference, target: self, selector: "generateEnemy", userInfo: nil, repeats: false)

    }
    
    func findEnemy(x: CGFloat, y: CGFloat) -> Enemy {
        var tempEnemy: Enemy!
        var dist: CGFloat
        var dist2: CGFloat
        var dist3: CGFloat
        var enemyx: CGFloat
        var enemyy: CGFloat
        var check: Int = 0
        var minDist: CGFloat = 1000
        var counter = 0
        var index = 0
        for enemy in enemys {
            check++
            enemyx = enemy.position.x
            enemyy = enemy.position.y
            dist = abs(enemyx - x)
            dist2 = abs(enemyy - y)
            dist3 = sqrt(dist * dist + dist2 * dist2)
            if dist3 < minDist {
                tempEnemy = enemy
                minDist = dist3
                index = counter
            }
            counter++
        }
        tempEnemy.timer = 0
        tempEnemy.physicsBody?.categoryBitMask = 0
        tempEnemy.index = index
        return tempEnemy
    }
    
    func addRotater() {
        var rotater = Rotater(texture: rotaterTexture)
        rotater.name = "rotater"
        rotater.zPosition = 102
        rotater.position.x = screenSize.width + rotater.size.width
        rotater.position.y = CGFloat(arc4random_uniform(UInt32(screenSize.height - screenSize.height/5))) + screenSize.height/8
        rotaters.append(rotater)
        addChild(rotater)
    }
    
    func addGunner() {
        gunner = Gunner(texture: gunnerTexture, char: parent!.childNodeWithName("char") as! Char, gen: self)
        gunner.name = "gunner"
        gunner.zPosition = 102
        addChild(gunner)
    }
    
    func moveFaster() {
        let moveLeft = SKAction.moveByX(difficulty * -140, y: 0, duration: 1)
        for child in children {
            child.runAction(SKAction.repeatActionForever(moveLeft))
        }
    }
    
    func addEnemy() {
        let en = Enemy(texture: alienTexture2)
        en.position.x = screenSize.width/1.5
        en.position.y = screenSize.height/2
        en.velX = 0
        en.velY = 0
        en.timer2 = 0
        enemys.append(en)
        addChild(en)
    }
    
    func generateEnemy() {
        var scale: Int
        var rand = Int(arc4random_uniform(5))
        var rand2 = arc4random_uniform(2)
        var rand3 = CGFloat(arc4random_uniform(5)) * 0.85
        var rand4 = CGFloat(arc4random_uniform(26))
        var two = CGFloat(arc4random_uniform(6))
        var chance = arc4random_uniform(3)
        var textureRand = arc4random_uniform(4)
        var texture: SKTexture!
        
        if difficulty > 1.57 && difficulty < 2.3 && rand4 < 4 && gCount >= 7 {
        //if difficulty > -1.7 && rand4 > 2 && gCount >= 0 {
            rand4 = 100
            if chance != 1 && on {
                gCount = 0
                addGunner()
            }
        }
        
        else if difficulty > 1.45 && rand4 < 9 && rCount >= 5 {
            rand4 = 100
            if chance != 1 && on {
                rCount = 0
                addRotater()
            }
        }
        else {
        if gCount < 8 {
            gCount++
        }
        if rCount < 7 {
            rCount++
        }
        if textureRand == 0 {
            texture = alienTexture1
        }
        else if textureRand == 1 {
            texture = alienTexture2
        }
        else {
            texture = alienTexture3
        }

        if rand2 == 0 {
            scale = 1
        }
            
        else {
            scale = -1
        }
        
        let enemy = Enemy(texture: texture)
        enemy.position.x = screenSize.width + enemy.size.width
        enemy.position.y = CGFloat(arc4random_uniform(UInt32(screenSize.height - enemy.size.height * 2.03))) + enemy.size.height * 1.02
        //enemy.position.y = 20
        if enemy.position.y > screenSize.height/2 {
            enemy.velY = -(rand3/3.2) * screenSize.height/320
        }
        else {
            enemy.velY = (rand3/3.2)  * screenSize.height/320
        }
        enemy.zPosition = 10
        
        if on && chance != 1 {
            enemys.append(enemy)
            enemyTrackers.append(enemy)
            if two > 3 && difficulty > 1.62 {
                textureRand = arc4random_uniform(4)
                if textureRand == 0 {
                    texture = alienTexture1
                }
                else if textureRand == 1 {
                    texture = alienTexture2
                }
                else {
                    texture = alienTexture3
                }
                
                if rand2 == 0 {
                    scale = 1
                }
                    
                else {
                    scale = -1
                }
                let enemy2 = Enemy(texture: texture)
                enemy2.position.x = screenSize.width + enemy.size.width
                enemy2.position.y = screenSize.height - enemy.position.y
                if enemy2.position.y > screenSize.height/2 {
                    enemy2.velY = -(rand3/3.2) * screenSize.width/568
                }
                else {
                    enemy2.velY = (rand3/3.2)  * screenSize.height/320
                }
                enemy2.zPosition = 10
                enemys.append(enemy2)
                enemyTrackers.append(enemy2)
                addChild(enemy2)
                
                if enemy.position.y < (3 * screenSize.height)/4 && enemy.position.y > screenSize.height/4 {
                    enemy.velY = enemy.velY * -1
                    enemy2.velY = enemy2.velY * -1
                }
                
                if (enemy2.position.y - enemy2.position.y) < 10 && (enemy2.position.y - enemy2.position.y) > 0 {
                    enemy2.position.y = enemy2.position.y + 15
                }
                
               else if (enemy2.position.y - enemy2.position.y) > -10 && (enemy2.position.y - enemy2.position.y) < 0 {
                    enemy2.position.y = enemy2.position.y - 15
                }

                enemy.velX = enemy2.velX

                addChild(enemy)
            }
            else if difficulty > 1.124 {
                addChild(enemy)
            }
        }
        }
        let myDouble = NSNumber(double: timerSeconds/Double(difficulty))
        let time = NSTimeInterval(myDouble.doubleValue)
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generateEnemy", userInfo: nil, repeats: false)
    }
    
    func stopEnemys() {
        stopGenerating()
        for enemy in enemys {
            enemy.stopMoving()
        }
        for rotater in rotaters {
            rotater.stopMoving()
        }
        if gunner != nil {
            gunner.stopMoving()
        }
    }
    
    func stopEnemys2() {
        for enemy in enemys {
            enemy.stopMoving()
        }
    }
    
    func pauseEnemies() {
        if gunner != nil {
            gunner.paused = true
        }
        
        for rotater in rotaters {
            rotater.paused = true
        }
        for enemy in enemys {
            enemy.paused = true
        }
    }
    
    func unPauseEnemies() {
        if gunner != nil {
            gunner.paused = false
        }
        
        for rotater in rotaters {
            rotater.paused = false
        }
        for enemy in enemys {
            enemy.paused = false
        }
    }
    
    func update() {
        if gunner != nil {
            gunner.update()
        }
        
        for rotater in rotaters {
            rotater.update()
        }
        for enemy in enemys {
            enemy.update()
        }
    }
    
}