//
//  GameScene.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/7/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene, SKPhysicsContactDelegate {
    
    var timerb = 100, timert = 0
    
    override func didMoveToView(view: SKView) {
        
        addMenu()
        
    }
    
    func addMenu() {
        /*
        //backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        addSky()
        //addCloudGenerator()
        
        //Title
        var imageTexture = SKTexture(imageNamed: "titlenoface")
        var title = SKSpriteNode(texture: imageTexture, color: nil, size: imageTexture.size())
        title.position = CGPointMake(screenSize.width/2.2, screenSize.height/1.8)
        title.size.width = screenSize.width
        title.size.height = screenSize.height
        title.name = "title"
        addChild(title)
        
        //TitleFace
        var imageTexture2 = SKTexture(imageNamed: "titleface")
        var titleFace = SKSpriteNode(texture: imageTexture2, color: nil, size: imageTexture.size())
        titleFace.position = CGPointMake(screenSize.width/2.2, screenSize.height/1.9)
        titleFace.size.width = screenSize.width
        titleFace.size.height = screenSize.height
        titleFace.name = "titleface"
        addChild(titleFace)
        
        //Blink
        addTitleBlink()
        
        //Play
        var play = Button(imageNamed: "play1")
        play.changeSize(0.3, h: 0.3)
        play.position = CGPointMake(screenSize.width/1.4, screenSize.height/1.9)
        play.name = "play"
        self.addChild(play)
        
        //HighScore
        var highScore = Button(imageNamed: "highscore1")
        highScore.changeSize(0.3, h: 0.35)
        highScore.position = CGPointMake(screenSize.width/1.4, screenSize.height/3.3)
        highScore.name = "highscore"
        self.addChild(highScore)
    }
    
    func addTitleBlink() {
        let titleFace = childNodeWithName("titleface") as! SKSpriteNode
        var blink = SKSpriteNode(imageNamed: "invisible")
        blink.position = CGPointMake(titleFace.position.x, titleFace.position.y)
        blink.size.width = screenSize.width
        blink.size.height = screenSize.height
        blink.name = "titleblink"
        addChild(blink)
    }
    
    func changeBlinkTexture(imageNamed: String) {
        let blink = childNodeWithName("titleblink") as! SKSpriteNode
        blink.texture = SKTexture(imageNamed: imageNamed)
    }
    
    func removeTitleBlink() {
        let blink = childNodeWithName("titleblink") as? SKSpriteNode
        if blink != nil {
            blink!.removeFromParent()
        }
    }
    
    func addSky() {
        let sky = SKSpriteNode(texture: SKTexture(imageNamed: "sky3"))
        sky.size = CGSizeMake(screenSize.width, screenSize.height)
        sky.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        sky.zPosition = -100
        sky.name = "sky"
        
        addChild(sky)
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let char = childNodeWithName("char") as? Char
        let slider = childNodeWithName("slider") as? Slider
        let block = childNodeWithName("block") as? SKSpriteNode
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
        
            let play = childNodeWithName("play") as! Button
            if play.frame.contains(location) {
                play.changeTexture("play2")
                play.isPressed = true
            }
            
            let highScore = childNodeWithName("highscore") as! Button
            if highScore.frame.contains(location) {
                highScore.changeTexture("highscore2")
                highScore.isPressed = true
            }
        }
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let char = childNodeWithName("char") as? Char
        let slider = childNodeWithName("slider") as? Slider
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let play = childNodeWithName("play") as! Button
            if play.frame.contains(location) && play.isPressed {
                play.changeTexture("play2")
            }
            if !play.frame.contains(location) && play.isPressed  {
            play.changeTexture("play1")
            }
            let highScore = childNodeWithName("highscore") as! Button
            if highScore.frame.contains(location) && highScore.isPressed  {
                highScore.changeTexture("highscore2")
            }
            if !highScore.frame.contains(location) && highScore.isPressed  {
                highScore.changeTexture("highscore1")
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let char = childNodeWithName("char") as? Char
        let slider = childNodeWithName("slider") as? Slider
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let play = childNodeWithName("play") as! Button
            let highScore = childNodeWithName("highscore") as! Button
            if play.frame.contains(location) && play.isPressed  {
                let newScene = GameScene(size: view!.bounds.size)
                newScene.scaleMode = .AspectFill
                
                view!.presentScene(newScene)
            }
            else if highScore.frame.contains(location) && highScore.isPressed  {
                //highScoreMenu()
            }
            else {
                play.isPressed = false
                highScore.isPressed = false
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {

        let titleFace = childNodeWithName("titleface") as! SKSpriteNode
        let blink = childNodeWithName("titleblink") as? SKSpriteNode
        
        
        if timert < 30 {
            titleFace.position.y = titleFace.position.y + 0.14
            //titleFace.position.x = title.position.x - 0.07
            if blink != nil {
                blink!.position.y = blink!.position.y + 0.14
                //blink!.position.x = blink!.position.x - 0.07
            }
            timert++
        }
        else {
            titleFace.position.y = titleFace.position.y - 0.1
            //titleFace.position.x = title.position.x + 0.05
            if blink != nil {
                blink!.position.y = blink!.position.y - 0.1
                //blink!.position.x = blink!.position.x + 0.05
            }
            timert++
            if timert == 60 {
                timert = 0
            }
        }
        
        if timerb < 170 {
            changeBlinkTexture("invisible")
            timerb++
        }
        else if timerb == 170 {
            timerb++
        }
        else if timerb < 171 {
            timerb++
        }
        else if timerb == 171 {
            changeBlinkTexture("titleblink2")
            timerb++
        }
        else if timerb < 172 {
            timerb++
        }
        else if timerb == 172 {
            changeBlinkTexture("titleblink3")
            timerb++
        }
        else if timerb < 173 {
            timerb++
        }
        else if timerb == 173 {
            changeBlinkTexture("titleblink4")
            timerb++
        }
        else if timerb < 178 {
            timerb++
        }
        else if timerb == 178 {
            changeBlinkTexture("titleblink3")
            timerb++
        }
        else if timerb < 179 {
            timerb++
        }
        else if timerb == 179 {
            changeBlinkTexture("titleblink2")
            timerb++
        }
        else if timerb < 180 {
            timerb++
        }
        else if timerb == 180 {
            changeBlinkTexture("titleblink1")
            timerb++
        }
        else if timerb < 181 {
            timerb++
        }
        else {
            if timerb ==  181 {
                timerb = 50
            }
            timerb++
        }*/
    }
}