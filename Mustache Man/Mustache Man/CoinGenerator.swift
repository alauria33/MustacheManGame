//
//  CloudGenerator2.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/7/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class CoinGenerator: SKSpriteNode {
    
    var COIN_WIDTH: CGFloat = 125.0
    var COIN_HEIGHT: CGFloat = 55.0
    
    var generationTimer: NSTimer!
    var counter: Int = 0
    var check: Int = 0
    
    var coins = [Coin]()
    var coinTrackers = [Coin]()
    
    var on = true
    var difference: NSTimeInterval!
    
    var timerSeconds: Double!
    
    func moveSlower() {
        check = 0
        for var i = 0; i < counter; i++ {
            var coin = childNodeWithName(String(i)) as! Coin
            coin.startMovingSlow()
        }
    }
    
    func startGeneratingWithSpawnTime(seconds: NSTimeInterval) {
        timerSeconds = seconds
        let myDouble = NSNumber(double: timerSeconds/Double(difficulty))
        let time = NSTimeInterval(myDouble.doubleValue)
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generateCoin", userInfo: nil, repeats: false)
    }
    
    func stopGenerating() {
        generationTimer.invalidate()
    }
    
    func pauseGenerating() {
        difference = generationTimer?.fireDate.timeIntervalSinceNow
        generationTimer?.invalidate()
    }
    
    func resumeGenerating() {
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(difference, target: self, selector: "generateCoin", userInfo: nil, repeats: false)
        
    }
    
    func generateCoin() {
        let type = arc4random_uniform(30)
        let chance = arc4random_uniform(3)
        let r = arc4random_uniform(2)
        var texture = coin1Texture
        var num: Int = 0
        if type > 8 {
            num = 100
        }
        else if type > 1 {
            texture = coin2Texture
            num = 300
        }
        else {
            texture = coin3Texture
            num = 1000
        }
        let coin = Coin(texture: texture)
        let x = screenSize.width + coin.size.width
        let y = CGFloat(arc4random_uniform(UInt32(screenSize.height - coin.size.height * 2.04))) + coin.size.height * 1.02
        coin.position = CGPointMake(x, y)
        coin.zPosition = 100
        coin.name = String(counter)
        coin.coinValue = num
        counter++
        
        if on {
            coins.append(coin)
            coinTrackers.append(coin)
            if chance == 1 {
                addChild(coin)
            }
        }
        
        let myDouble = NSNumber(double: timerSeconds/Double(difficulty))
        let time = NSTimeInterval(myDouble.doubleValue)
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "generateCoin", userInfo: nil, repeats: false)
    }
    
    func moveFaster() {
        let moveLeft = SKAction.moveByX(difficulty * -135, y: 0, duration: 1)
        for child in children {
            child.runAction(SKAction.repeatActionForever(moveLeft))
        }
    }
    
    func removeCoin(x: CGFloat, y: CGFloat) -> Int {
        var tempCoin: Coin!
        var dist: CGFloat
        var dist2: CGFloat
        var dist3: CGFloat
        var coinx: CGFloat
        var coiny: CGFloat
        var minDist: CGFloat = 1000
        var index = 0
        var counter = 0
        var val = 0
        for coin in coins {
            coinx = coin.position.x - 30
            coiny = coin.position.y - 30
            dist = abs(coinx - x)
            dist2 = abs(coiny - y + 30)
            dist3 = sqrt(dist * dist + dist2 * dist2)
            if dist3 < minDist {
                tempCoin = coin
                minDist = dist3
                index = counter
            }
            counter++
        }
        val = tempCoin.getValue()
        tempCoin.position.x = 1200
        tempCoin.physicsBody?.categoryBitMask = 0
        tempCoin.removeFromParent()
        coins.removeAtIndex(index)
        return val
    }

    func moveCoin(x: CGFloat) {
        var tempCoin: Coin!
        var dist: CGFloat
        var coinx: CGFloat
        var coiny: CGFloat
        var minDist: CGFloat = 1000
        var index = 0
        var counter = 0
        var val = 0
        for coin in coins {
            coinx = coin.position.x - 30
            coiny = coin.position.y - 30
            dist = abs(coinx - x)
            if dist < minDist {
                tempCoin = coin
                minDist = dist
                index = counter
            }
            counter++
        }
        tempCoin.removeFromParent()
    }
    
    func stopCoins() {
        stopGenerating()
        for coin in coins {
            coin.stopMoving()
        }
    }
    
    func update() {
        var index = 0
        for coin in coins {
            if coin.position.x < 120 {
                physicsBody?.collisionBitMask = 0
                physicsBody?.contactTestBitMask = 0
            }
            if coin.position.x < 0 {
                coin.position.x = 1200
                coin.removeFromParent()
                coins.removeAtIndex(index)
            }
            index++
        }
    }
    
}

