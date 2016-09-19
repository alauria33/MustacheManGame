//
//  SetUpScene.swift
//  Mustache Man
//
//  Created by Andrew on 8/27/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit

class SetUpScene: SKScene, SKPhysicsContactDelegate {
    
    var mainSong = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ThemeSongF", ofType: "mp3")!), error: nil)
    
    var inMenu = true
    var inGame = false
    var isStarted = false
    var inGameOver = false
    var inHighScore = false
    var inHowTo = false
    var inPause = false
    var firstStart = true
    var firstOpen = true
    var movingUp = true
    var charAccel: CGFloat = 0.23 * screenSize.height/375
    
    var mustacheIcon: SKSpriteNode!
    var powerUp1: PowerUpToken!
    var powerUp2: PowerUpToken!
    var powerUp3: PowerUpToken!
    var powerUp1Pressed = false
    var powerUp2Pressed = false
    var powerUp3Pressed = false
    
    var highScores = [Int]()
    
    var bombSwipe = false
    var didSwipeDown = false
    
    var shootLoc = CGPointMake(screenSize.width/1.3, screenSize.height/2)
    
    var stacheCount: Int = 5
    var heartCount: Int = 1
    var bombCount: Int = 1
    var max: Int = 30
    
    var GSScore: Int = 0
    var howToCount = 0
    var ind: Int!
    
    var on = true
    
    var timer = 0, timer2 = 100, timer3 = 55, pauseTimer = 100, timerb = 100, timert = 0, songTimer = 100, moneyTimer = 1000, bombTimer = 1000, setUpTimer = 1000, arrayTimer = 1000
    
    var genCount = 0
    
    override func didMoveToView(view: SKView) {
        
        inMenu = false
        addSetup()

        /*
        if type == 0 {
        print("here")
        inMenu = false
        addSetup()
        }*/
        //if type == 1 {
        //addSetup()
        //}
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        swipeRight.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        swipeLeft.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        swipeUp.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedDown:"))
        swipeDown.direction = .Down
        swipeDown.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeDown)
        
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        println("swiped right")
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        println("swiped left")
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        println("swiped up")
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        println("swiped down")
        didSwipeDown = true
    }
    
    func addSetup() {
        
        //type = 1
        powerUp1 = PowerUpToken(texture: invisble)
        powerUp1.isPressed = false
        powerUp2 = PowerUpToken(texture: invisble)
        powerUp2.isPressed = false
        powerUp3 = PowerUpToken(texture: invisble)
        powerUp3.isPressed = false
        
        setUpTimer = 0
        
        loadTextures()
        
        addCharacter()
        addWallGenerator()
        addEnemyGenerator()
        addBirdGenerator()
        addCoinGenerator()
        addMoneyGenerator()
        addPowerUpGenerator()
        addPointsLabels()
        addPowerUpArray()
        addPhysicsWorld()
        let char = childNodeWithName("char") as! Char
        char.addSuper()
        char.superTimer = -12
        addCloudGenerator()
        addTapToStartLabel()
        
        //Pause
        addPauseButton()
        
        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
        let cloudGenerator = childNodeWithName("cloudGenerator") as! CloudGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        
        addCeiling()
        char.addCape2()
        char.timer = 0
        
        difficulty = 2
        cloudGenerator.moveFaster()
        cloudGenerator.generateFirstCloud()
        cloudGenerator.startGeneratingWithSpawnTime(0.5)
        wallGenerator.startGeneratingWallsEvery(0.5)
        enemyGenerator.startGeneratingEnemysEvery(0.5)
        birdGenerator.startGeneratingBirdsEvery(0.5)
        coinGenerator.startGeneratingWithSpawnTime(0.5)
        powerUpGenerator.startGeneratingWithSpawnTime(0.5)
        char.changeTexture(mainCharTexture)
        char.addLeftArm()
        char.addRightArm()
        
        let screen = SKSpriteNode(texture: launchTexture)
        screen.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        screen.size = CGSizeMake(screenSize.width, screenSize.height)
        screen.zPosition = 10000
        addChild(screen)
        
        /*
        let white = SKShapeNode(rect: CGRectMake(0, 0, screenSize.width, screenSize.height))
        white.zPosition = 2000
        white.alpha = 1.0
        white.name = "white"
        white.fillColor = UIColor.blackColor()
        white.zPosition = 10000
        addChild(white)
        
        let label = SKLabelNode(text: "One Sec...")
        label.fontColor = UIColor(red: 94/255, green: 116/255, blue: 195/255, alpha: 1.0)
        label.fontName = "ChalkboardSE-Regular"
        label.fontSize = 60.0
        label.position = CGPointMake(screenSize.width/2, screenSize.height/2.5)
        label.zPosition = 10001
        addChild(label)*/
        
    }
    
    func dropBomb() {
        let bomb = SKSpriteNode(texture: bombTexture)
        bomb.name = "bomb"
        bomb.position = CGPointMake(screenSize.width/2, screenSize.height + 10)
        bomb.size = CGSizeMake(bombTexture.size().width * 0.2, bombTexture.size().height * 0.2)
        addChild(bomb)
        bombTimer = 0
        
        let char = childNodeWithName("char") as! Char
        if char.isHolding {
            char.resetArm()
        }
        
        bombCount = bombCount - 1
        
        addPointAdditionBomb(-1)
        let bombLabel = mustacheIcon.childNodeWithName("bombLabel") as! PointsLabel
        bombLabel.colon(bombCount)
        
        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        
        //wallGenerator.stopWalls2()
        //enemyGenerator.stopEnemys2()
        
        wallGenerator.on = false
        coinGenerator.on = false
        enemyGenerator.on = false
        birdGenerator.on = false
        moneyGenerator?.on = false
        powerUpGenerator.on = false
        
        
        removeActionForKey("grab")
    }
    
    func explosion() {
        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        
        wallGenerator.removeAllChildren()
        coinGenerator.removeAllChildren()
        enemyGenerator.removeAllChildren()
        birdGenerator.removeAllChildren()
        moneyGenerator?.removeAllChildren()
        powerUpGenerator.removeAllChildren()
        
        let array = childNodeWithName("powerUpArray") as! PowerUpArray
        array.count = 0
        array.alpha = 1.0
        
    }
    
    func loadTextures() {
        let loader = SKSpriteNode(texture: charIdleTexture)
        loader.size = CGSizeMake(30, 60)
        loader.position = CGPointMake(100, 100)
        loader.zPosition = -101
        loader.runAction(SKAction.sequence([SKAction.animateWithTextures([gameOverTexture, playAgainTexture1, playAgainTexture2, scoreTexture, titleFaceTexture, titleTexture, spikeWallTexture, openWallTexture, topBrokeTexture, bottomBrokeTexture, topWallTexture, alienTexture1, alienTexture2, alienTexture3, explosionTexture, gunnerTexture, rotateArmsTexture, rotaterTexture, superTexture, stachelessTexture, jumpTexture, mainCharTexture, blueButtonTexture, blueTexture, yellowTexture, blinki1, blinki2,blinki3,blinki4,blinks1,blinks2,blinks3,blinks4, arm2Texure, armTexture, capeTexture, leftArmTexture, rightArmTexture, leftBigArmTexture, rightBigArmTexture, moneyManTexture, glassesTexture, sadTexture, pointerTexture, coin1Texture, coin2Texture, coin3Texture, moneyTokenTexture1, moneyTokenTexture2, moneyTokenTexture3, moneyTokenTexture4, muscleTokenTexture1, muscleTokenTexture2, muscleTokenTexture3, muscleTokenTexture4, miniTokenTexture1, miniTokenTexture2, miniTokenTexture3, miniTokenTexture4, shooterTokenTexture1, shooterTokenTexture2, shooterTokenTexture3, shooterTokenTexture4, whiteButtonTexture, pauseTexture, pause2Texture, invisble, blink1, blink2, blink3, blink4, birdTexture1, birdTexture2, stacheBagTexture, heartTexture, heartTexture2, redTimerTexture, grayTimerTexture, timerTexture, mustacheTexture2, barTexture, superStacheTexture1, superStacheTexture2, superStacheTexture3, superStacheTexture4, superStacheTexture5, superStacheTexture6, superStacheTexture7, superStacheTexture7a, superStacheTexture7b], timePerFrame: 0.003), SKAction.removeFromParent()]))
        addChild(loader)
    }
    
    func playSound(name: AVAudioPlayer) {
        name.play()
        name.numberOfLoops = -1
    }
    
    func stopSound(name: AVAudioPlayer) {
        name.stop()
        name.currentTime = 0
    }
    
    func restartSound(name: AVAudioPlayer) {
        name.stop()
        name.currentTime = 0
        name.play()
        
    }
    
    func pauseSound(name: AVAudioPlayer) {
        name.stop()
    }
    
    func addMenu() {
        
        inMenu = true
        inGame = false
        isStarted = false
        inGameOver = false
        inHighScore = false
        inHowTo = false
        inPause = false
        firstStart = true
        
        if firstOpen {
            loadHighscores()
            firstOpen = false
            removeAllChildren()
            addSky()
            addCloudGenerator()
        }
        
        //Title
        var title = SKSpriteNode(texture: titleTexture, color: nil, size: titleTexture.size())
        title.position = CGPointMake(screenSize.width/2.2, screenSize.height/1.75)
        title.size.width = screenSize.width
        title.size.height = screenSize.height
        title.name = "title"
        addChild(title)
        
        //TitleFace
        var titleFace = SKSpriteNode(texture: titleFaceTexture, color: nil, size: titleFaceTexture.size())
        titleFace.position = CGPointMake(screenSize.width/5, screenSize.height/2.38)
        titleFace.size.width = screenSize.width * 0.28
        titleFace.size.height = screenSize.height * 0.48
        titleFace.name = "titleface"
        addChild(titleFace)
        
        //Blink
        addTitleBlink()
        
        //Play
        var play = Button(texture: whiteButtonTexture)
        play.changeSize(0.5 * screenSize.width/568, h: 0.5 * screenSize.height/320)
        play.position = CGPointMake(screenSize.width/1.32, screenSize.height/2.26)
        play.name = "play"
        self.addChild(play)
        //play Text
        var pText = SKSpriteNode(texture: p1Texture, color: nil, size: p1Texture.size())
        pText.position = CGPointMake(screenSize.width/1.088, screenSize.height/2.8)
        pText.size.width = screenSize.height * 0.9
        pText.size.height = screenSize.width * 0.35
        pText.zPosition = 303
        pText.name = "ptext"
        addChild(pText)
        
        //HTP
        var htp = Button(texture: htpTexture1)
        htp.changeSize(0.2 * screenSize.width/568, h: 0.2 * screenSize.height/320)
        htp.position = CGPointMake(screenSize.width/1.32 - screenSize.width/8, screenSize.height/4.1)
        htp.name = "htp"
        htp.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -14, duration: 0.0))
        self.addChild(htp)
        
        //HS
        var highScore = Button(texture: trophyTexture1)
        highScore.changeSize(0.2 * screenSize.width/568, h: 0.2 * screenSize.height/320)
        highScore.position = CGPointMake(screenSize.width/1.32, screenSize.height/5.4)
        highScore.name = "highscore"
        //highScore.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -16, duration: 0.0))
        self.addChild(highScore)
        
        //Settings
        var settings = Button(texture: settingsTexture1)
        settings.changeSize(0.2 * screenSize.width/568, h: 0.2 * screenSize.height/320)
        settings.position = CGPointMake(screenSize.width/1.32 + screenSize.width/8, screenSize.height/4.1)
        settings.name = "settings"
        settings.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 14, duration: 0.0))
        self.addChild(settings)
        
    }
    
    func addTitleBlink() {
        let titleFace = childNodeWithName("titleface") as! SKSpriteNode
        var blink = Blink()
        blink.position = CGPointMake(0, 0)
        blink.size = titleFace.size
        blink.name = "titleblink"
        titleFace.addChild(blink)
    }
    
    func addGameOverMenu() {
        
        childNodeWithName("pause")!.zPosition = 100
        
        let duration = 0
        let fadeOut = SKAction.fadeAlphaTo(0.8, duration: 1.5)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 1)
        let wait = SKAction.fadeAlphaTo(0.0, duration: 0.5)
        
        let col = UIColor(red: 224/255.0, green: 223/255.0, blue: 231/255.0, alpha: 1.0)
        
        let block = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(screenSize.width, screenSize.height))
        block.anchorPoint = CGPointMake(0.0, 0.0)
        block.position = CGPointMake(0, 0)
        block.zPosition = 301
        block.alpha = 0
        
        block.runAction(SKAction.sequence([wait, fadeOut]))
        
        addChild(block)
        
        //Title
        var title = SKSpriteNode(texture: gameOverTexture, color: nil, size: gameOverTexture.size())
        title.position = CGPointMake(screenSize.width/2.1, screenSize.height/1.22)
        title.size.width = screenSize.width * 1.02
        title.size.height = screenSize.height * 1.02
        title.zPosition = 502
        title.alpha = 0
        title.runAction(SKAction.sequence([wait, fadeIn]))
        title.name = "title2"
        addChild(title)
        
        //Play Again
        var play = Button(texture: playAgainTexture1)
        play.size.width = screenSize.width * 0.32
        play.size.height = screenSize.height * 0.26
        play.position = CGPointMake(screenSize.width/2, screenSize.height/5)
        play.zPosition = 503
        play.alpha = 0
        play.runAction(SKAction.sequence([wait, fadeIn]))
        play.name = "playagain"
        self.addChild(play)
        
        //Score
        let cloud = SKSpriteNode(texture: cloudTexture, color: nil, size: cloudTexture.size())
        cloud.position = CGPointMake(screenSize.width/2, screenSize.height/1.97)
        cloud.size.width = screenSize.width * 0.6
        cloud.size.height = screenSize.height * 0.62
        cloud.zPosition = 302
        cloud.alpha = 0.0
        cloud.runAction(SKAction.sequence([wait, fadeIn]))
        cloud.name = "cloud"
        addChild(cloud)
        let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
        let score = SKLabelNode(text: "Score: \(pointsLabel.getNum())")
        score.fontColor = UIColor(red: 94/255, green: 116/255, blue: 195/255, alpha: 1.0)
        score.fontName = "ChalkboardSE-Bold"
        score.fontSize = 38.0
        score.zPosition = 303
        score.alpha = 0.0
        score.name = "pausescore"
        score.runAction(SKAction.sequence([wait, fadeIn, blinkAnimation2()]))
        score.position = CGPointMake(screenSize.width/2, screenSize.height/1.8)
        addChild(score)
        
        if highScores[0] > pointsLabel.getNum() {
            let score2 = SKLabelNode(text: "High Score: \(highScores[0])")
            score2.fontColor = UIColor(red: 59/255, green: 57/255, blue: 57/255, alpha: 1.0)
            score2.fontName = "ChalkboardSE-Bold"
            score2.fontSize = 23.0
            score2.zPosition = 303
            score2.alpha = 0.0
            score2.runAction(SKAction.sequence([wait, fadeIn]))
            score2.name = "highscore"
            score2.position = CGPointMake(screenSize.width/2, screenSize.height/2.4)
            addChild(score2)
        }
        else {
            
            let score2 = SKLabelNode(text: "New High Score!!!")
            score2.fontColor = UIColor.redColor()
            score2.fontName = "ChalkboardSE-Bold"
            score2.fontSize = 23.0
            score2.zPosition = 303
            score2.alpha = 0.0
            let wait2 = SKAction.waitForDuration(1)
            let rotate1 = SKAction.rotateByAngle(CGFloat(M_PI)/30, duration: 0.0)
            let rotate2 = SKAction.rotateByAngle( CGFloat(-M_PI)/15, duration: 1.0)
            let rotate3 = SKAction.rotateByAngle(CGFloat(M_PI)/15, duration: 1.0)
            score2.runAction(SKAction.sequence([wait, fadeIn, rotate1]))
            score2.runAction(SKAction.repeatActionForever(SKAction.sequence([rotate2, rotate3])))
            score2.name = "highscore"
            score2.position = CGPointMake(screenSize.width/2, screenSize.height/2.4)
            addChild(score2)
        }
        
        /*
        //Score
        var score = SKSpriteNode(texture: scoreTexture, color: nil, size: scoreTexture.size())
        score.position = CGPointMake(screenSize.width/2.3, screenSize.height/1.7)
        score.size.width = screenSize.height * 0.7
        score.size.height = screenSize.width * 0.28
        score.zPosition = 302
        score.alpha = 0
        score.runAction(SKAction.sequence([wait, fadeIn]))
        score.name = "name"
        addChild(score)
        
        
        //Value
        let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
        let num = pointsLabel.getNum()
        var val = SKLabelNode(text: String(num))
        val.fontColor = col
        val.fontName = "ChalkboardSE-Regular"
        val.fontSize = 60.0
        var x: CGFloat = 0
        if num < 10 {
        x = 37 * screenSize.width/568
        }
        else if num < 100 {
        x = 49 * screenSize.width/568
        }
        else if num < 1000 {
        x = 62 * screenSize.width/568
        }
        else if num < 10000 {
        x = 78 * screenSize.width/568
        }
        else if num < 100000 {
        x = 92 * screenSize.width/568
        }
        val.position = CGPointMake((view!.frame.width/2) + x, screenSize.height/2.3)
        val.zPosition = 302
        val.alpha = 0
        val.runAction(SKAction.sequence([wait, fadeIn, blinkAnimation()]))
        addChild(val)
        */
        
        //back
        var back = Button(texture: menuTexture1)
        back.changeSize(0.26 * screenSize.width/568, h: 0.26 * screenSize.height/320)
        back.position = CGPointMake(screenSize.width/8.4, screenSize.height/6)
        back.name = "back"
        back.zPosition = 303
        back.alpha = 0
        back.runAction(SKAction.sequence([wait, fadeIn]))
        self.addChild(back)
        
        //Game Center
        var gCenter = Button(texture: gcTexture1)
        gCenter.changeSize(0.26 * screenSize.width/568, h: 0.26 * screenSize.height/320)
        gCenter.position = CGPointMake(screenSize.width - screenSize.width/8.4, screenSize.height/6)
        gCenter.name = "gCenter"
        gCenter.zPosition = 303
        gCenter.alpha = 0
        gCenter.runAction(SKAction.sequence([wait, fadeIn]))
        //self.addChild(gCenter)
        
        //Score
        let cloud2 = SKSpriteNode(texture: cloudTexture, color: nil, size: cloudTexture.size())
        cloud2.position = CGPointMake(screenSize.width/1.1, screenSize.height/10)
        cloud2.size.width = screenSize.width * 0.5
        cloud2.size.height = screenSize.height * 0.5
        cloud2.zPosition = 302
        cloud2.alpha = 0.0
        cloud2.runAction(SKAction.sequence([wait, fadeIn]))
        cloud2.name = "cloud2"
        //addChild(cloud2)
        
        //Share
        let share = SKLabelNode(text: "Share!")
        share.fontColor = UIColor(red: 198/255, green: 212/255, blue: 248/255, alpha: 1.0)
        share.fontName = "ChalkboardSE-Regular"
        share.fontSize = 45.0
        share.position = CGPointMake(screenSize.width/1.15, screenSize.height/4.1)
        share.zPosition = 2010
        share.name = "share"
        share.alpha = 0.0
        share.runAction(SKAction.rotateByAngle( CGFloat(M_PI) / -30, duration: 0.0))
        share.runAction(SKAction.sequence([wait, fadeIn]))
        addChild(share)
        
        //FB
        var faceBook = Button(texture: faceBookTexture)
        faceBook.changeSize(0.35 * screenSize.width/568, h: 0.35 * screenSize.width/568)
        faceBook.position = CGPointMake(28 * screenSize.width/568, -29 * screenSize.height/320)
        faceBook.name = "faceBook"
        faceBook.zPosition = 303
        faceBook.alpha = 0
        faceBook.runAction(SKAction.sequence([wait, fadeIn]))
        share.addChild(faceBook)
        
        //Twitter
        var twitter = Button(texture: twitterTexture)
        twitter.changeSize(0.35 * screenSize.width/568, h: 0.35 * screenSize.width/568)
        twitter.position = CGPointMake(-28 * screenSize.width/568, -29 * screenSize.height/320)
        twitter.name = "twitter"
        twitter.zPosition = 303
        twitter.alpha = 0
        twitter.runAction(SKAction.sequence([wait, fadeIn]))
        share.addChild(twitter)
        
    }
    
    func addPauseMenu() {
        
        if inGameOver {
            removeAllChildren()
            addMenu()
        }
            
        else {
            let char = childNodeWithName("char") as! Char
            let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
            let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
            let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
            let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
            let cloudGenerator = childNodeWithName("cloudGenerator") as! CloudGenerator
            let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
            let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
            wallGenerator.on = false
            coinGenerator.on = false
            enemyGenerator.on = false
            birdGenerator.on = false
            cloudGenerator.on = false
            moneyGenerator?.on = false
            powerUpGenerator.on = false
            on = false
            
            let bullet = childNodeWithName("stache") as? Bullet
            if bullet != nil {
                bullet!.paused = true
            }
            if !inPause {
                let pause = childNodeWithName("pause") as! Button
                pause.changeTexture(pause2Texture)
                
                let duration = 0
                let fadeOut = SKAction.fadeAlphaTo(0.8, duration: 1.5)
                let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 1)
                let wait = SKAction.fadeAlphaTo(0.0, duration: 0.5)
                
                let col = UIColor(red: 224/255.0, green: 223/255.0, blue: 231/255.0, alpha: 1.0)
                
                let block = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(screenSize.width, screenSize.height))
                block.anchorPoint = CGPointMake(0.0, 0.0)
                block.position = CGPointMake(0, 0)
                block.zPosition = 301
                block.alpha = 0.8
                block.name = "pauseblock"
                
                addChild(block)
                
                //Menu Title
                var menu = SKSpriteNode(texture: title2Texture, color: nil, size: title2Texture.size())
                menu.position = CGPointMake(screenSize.width/7.7, screenSize.height/1.3)
                menu.size.width = screenSize.width/3.8
                menu.size.height = screenSize.width/3.8
                menu.name = "pausemenu"
                menu.zPosition = 502
                let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / 5, duration: 0.0)
                //menu.runAction(rotate)
                addChild(menu)
                
                //Title
                var title = SKSpriteNode(texture: pausedTexture, color: nil, size: pausedTexture.size())
                title.position = CGPointMake(screenSize.width/2, screenSize.height/1.16)
                title.size.width = screenSize.width * 0.43
                title.size.height = screenSize.height * 0.43
                title.zPosition = 502
                title.name = "paused"
                addChild(title)
                
                //Score
                let cloud = SKSpriteNode(texture: cloudTexture, color: nil, size: cloudTexture.size())
                cloud.position = CGPointMake(screenSize.width/2, screenSize.height/2.01)
                cloud.size.width = screenSize.width * 0.6
                cloud.size.height = screenSize.height * 0.66
                cloud.zPosition = 302
                cloud.name = "cloud"
                addChild(cloud)
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                let score = SKLabelNode(text: "Score: \(pointsLabel.getNum())")
                score.fontColor = UIColor(red: 94/255, green: 116/255, blue: 195/255, alpha: 1.0)
                score.fontName = "ChalkboardSE-Bold"
                score.fontSize = 38.0
                score.zPosition = 303
                score.name = "pausescore"
                score.position = CGPointMake(screenSize.width/2, screenSize.height/1.8)
                addChild(score)
                let score2 = SKLabelNode(text: "High Score: \(highScores[0])")
                score2.fontColor = UIColor(red: 59/255, green: 57/255, blue: 57/255, alpha: 1.0)
                score2.fontName = "ChalkboardSE-Bold"
                score2.fontSize = 23.0
                score2.zPosition = 303
                score2.name = "highscore"
                score2.position = CGPointMake(screenSize.width/2, screenSize.height/2.3)
                addChild(score2)
                
                /*
                var score = SKSpriteNode(texture: scoreTexture, color: nil, size: scoreTexture.size())
                score.position = CGPointMake(screenSize.width/2.3, screenSize.height/1.7)
                score.size.width = screenSize.height * 0.6
                score.size.height = screenSize.width * 0.28
                score.zPosition = 302
                score.name = "pausescore"
                addChild(score)*/
                
                
                //Value
                /*
                let num = pointsLabel.getNum()
                var val = SKLabelNode(text: String(num))
                val.fontColor = col
                val.fontName = "ChalkboardSE-Regular"
                val.fontSize = 60.0
                var x: CGFloat = 0
                if num < 10 {
                x = 37
                }
                else if num < 100 {
                x = 49
                }
                else if num < 1000 {
                x = 62
                }
                else if num < 10000 {
                x = 78
                }
                else if num < 100000 {
                x = 91
                }
                val.name = "pausevalue"
                val.position = CGPointMake((view!.frame.width/2) + x, screenSize.height/2.3)
                val.zPosition = 302
                //addChild(val)
                */
                
                var resume = Button(texture: resumeTexture1)
                resume.size.width = screenSize.width * 0.43
                resume.size.height = screenSize.height * 0.31
                resume.position = CGPointMake(screenSize.width/2, screenSize.height/5.2)
                resume.zPosition = 503
                resume.alpha = 1.0
                resume.name = "resume"
                self.addChild(resume)
                
                /*
                //Resume button
                var resume = Button(texture: whiteButtonTexture)
                resume.changeSize(0.625, h: 0.57)
                resume.zPosition = 302
                resume.position = CGPointMake(screenSize.width/2, screenSize.height/6.1)
                resume.name = "resume"
                self.addChild(resume)
                //Resume Text
                var imageTexture5 = SKTexture(imageNamed: "resume1")
                var resText = SKSpriteNode(texture: imageTexture5, color: nil, size: imageTexture5.size())
                resText.position = CGPointMake(screenSize.width/2, screenSize.height/6.5)
                resText.size.width = screenSize.width * 0.22
                resText.size.height = screenSize.height * 0.24
                resText.zPosition = 303
                resText.name = "restext"
                addChild(resText)
                */
                //back
                var back = Button(texture: menuTexture1)
                back.changeSize(0.26 * screenSize.width/568, h: 0.26 * screenSize.height/320)
                back.position = CGPointMake(screenSize.width/8.4, screenSize.height/6)
                back.name = "back"
                back.zPosition = 303
                self.addChild(back)
                
                //Game Center
                var gCenter = Button(texture: gcTexture1)
                gCenter.changeSize(0.26 * screenSize.width/568, h: 0.26 * screenSize.height/320)
                gCenter.position = CGPointMake(screenSize.width - screenSize.width/8.4, screenSize.height/6)
                gCenter.name = "gCenter"
                gCenter.zPosition = 303
                self.addChild(gCenter)
                
                pauseGenerators()
                
            }
            
            inMenu = false
            inGame = false
            inGameOver = false
            inHighScore = false
            inPause = true
            inHowTo = false
            
            self.runAction(SKAction.runBlock(self.pauseGame))
        }
    }
    
    func addSky() {
        let sky = SKSpriteNode(texture: skyTexture)
        sky.size = CGSizeMake(screenSize.width, screenSize.height)
        sky.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        sky.zPosition = -100
        sky.name = "sky"
        
        addChild(sky)
        
        let colorBlock = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(screenSize.width, screenSize.height))
        colorBlock.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        colorBlock.zPosition = -99
        colorBlock.name = "colorBlock"
        colorBlock.alpha = 0.0
        
        addChild(colorBlock)
        
    }
    
    func animateSky() {
        let fade1 = SKAction.fadeAlphaTo(0.08, duration: 10)
        let fade3 = SKAction.fadeAlphaTo(0.2, duration: 10)
        let fade4 = SKAction.fadeAlphaTo(0.3, duration: 10)
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 10)
        let wait = SKAction.waitForDuration(2)
        let wait1 = SKAction.waitForDuration(8)
        let changeToRed = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0)
        let changeToGreen = SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 1.0, duration: 0)
        let changeToOrange = SKAction.colorizeWithColor(UIColor.orangeColor(), colorBlendFactor: 1.0, duration: 0)
        let changeToPurple = SKAction.colorizeWithColor(UIColor.purpleColor(), colorBlendFactor: 1.0, duration: 0)
        let action = SKAction.sequence([wait1, fade3, fadeOut, wait, changeToGreen, fade1, fadeOut, wait, changeToOrange, fade4, fadeOut, wait,  changeToPurple, fade3, fadeOut, changeToRed])
        childNodeWithName("colorBlock")!.runAction(SKAction.repeatActionForever(action))
    }
    
    func addImage(imageNamed: String) {
        inMenu = false
        inHowTo = true
        let image = SKSpriteNode(texture: SKTexture(imageNamed: imageNamed))
        image.size = CGSizeMake(screenSize.width, screenSize.height)
        image.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        image.zPosition = 10
        image.name = "image"
        image.alpha = 0.8
        
        addChild(image)
    }
    
    func removeImage() {
        let image = childNodeWithName("image") as? SKSpriteNode
        if image != nil {
            image!.removeFromParent()
        }
    }
    
    func addPowerUpArray() {
        var powerUpArray = PowerUpArray()
        powerUpArray.name = "powerUpArray"
        addChild(powerUpArray)
        if firstStart {
            powerUpArray.runAction(fadeIn())
        }
    }
    
    func addSlider() {
        var slider = Slider()
        slider.position = CGPointMake(36, view!.frame.height/2)
        slider.zPosition = 202
        slider.name = "slider"
        if firstStart {
            slider.runAction(fadeIn())
        }
        addChild(slider)
    }
    
    func addCeiling() {
        let size = CGSizeMake(screenSize.width, 5)
        let ceiling = SKSpriteNode(color: SKColor.blackColor(), size: size)
        ceiling.anchorPoint = CGPointMake(0.0, 0.0)
        ceiling.position = CGPointMake(0, screenSize.height + 5)
        ceiling.zPosition = 201
        ceiling.name = "ceiling"
        ceiling.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        ceiling.physicsBody?.categoryBitMask = BodyType.ceiling.rawValue
        ceiling.physicsBody?.collisionBitMask = BodyType.char.rawValue
        ceiling.physicsBody?.contactTestBitMask = BodyType.char.rawValue
        ceiling.physicsBody?.dynamic = false
        ceiling.physicsBody?.affectedByGravity = false
        addChild(ceiling)
    }
    
    func addSlidePanel() {
        let block = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(70, 500))
        block.anchorPoint = CGPointMake(0.0, 0.0)
        block.position = CGPointMake(0, 0)
        block.zPosition = 201
        block.name = "block"
        
        let blue = UIColor(red: 95/255.0, green: 117/255.0, blue: 197/255.0, alpha: 1.0)
        
        if firstStart {
            block.runAction(fadeIn())
        }
        block.zPosition = 201
        addChild(block)
        
        let block2 = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(4, 500))
        block2.anchorPoint = CGPointMake(0.0, 0.0)
        block2.position = CGPointMake(0, 0)
        block2.zPosition = 51
        if firstStart {
            block2.runAction(fadeIn())
        }
        block2.zPosition = 201
        addChild(block2)
        
        let block3 = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(4, 500))
        block3.anchorPoint = CGPointMake(0.0, 0.0)
        block3.position = CGPointMake(68, 0)
        block3.zPosition = 51
        if firstStart {
            block3.runAction(fadeIn())
        }
        block3.zPosition = 201
        addChild(block3)
        
        let block4 = SKSpriteNode(color: blue, size: CGSizeMake(2, 500))
        block4.anchorPoint = CGPointMake(0.0, 0.0)
        block4.position = CGPointMake(0, 0)
        block4.zPosition = 51
        if firstStart {
            block4.runAction(fadeIn())
        }
        block4.zPosition = 201
        addChild(block4)
        
        let block5 = SKSpriteNode(color: blue, size: CGSizeMake(3, 500))
        block5.anchorPoint = CGPointMake(0.0, 0.0)
        block5.position = CGPointMake(70, 0)
        block5.zPosition = 51
        if firstStart {
            block5.runAction(fadeIn())
        }
        block5.zPosition = 201
        addChild(block5)
    }
    
    func addTouchPanel() {
        let block = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(70, 500))
        block.anchorPoint = CGPointMake(0.0, 0.0)
        block.position = CGPointMake(0, 0)
        block.zPosition = 201
        block.name = "touchblock"
        
        let blue = UIColor(red: 95/255.0, green: 117/255.0, blue: 197/255.0, alpha: 1.0)
        
        if firstStart {
            block.runAction(fadeIn())
        }
        block.zPosition = 201
        addChild(block)
        
        let block2 = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(4, 500))
        block2.anchorPoint = CGPointMake(0.0, 0.0)
        block2.position = CGPointMake(0, 0)
        block2.zPosition = 51
        if firstStart {
            block2.runAction(fadeIn())
        }
        block2.zPosition = 201
        addChild(block2)
        
        let block3 = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(4, 500))
        block3.anchorPoint = CGPointMake(0.0, 0.0)
        block3.position = CGPointMake(68, 0)
        block3.zPosition = 51
        if firstStart {
            block3.runAction(fadeIn())
        }
        block3.zPosition = 201
        addChild(block3)
        
        let block4 = SKSpriteNode(color: blue, size: CGSizeMake(2, 500))
        block4.anchorPoint = CGPointMake(0.0, 0.0)
        block4.position = CGPointMake(0, 0)
        block4.zPosition = 51
        if firstStart {
            block4.runAction(fadeIn())
        }
        block4.zPosition = 201
        addChild(block4)
        
        let block5 = SKSpriteNode(color: blue, size: CGSizeMake(3, 500))
        block5.anchorPoint = CGPointMake(0.0, 0.0)
        block5.position = CGPointMake(70, 0)
        block5.zPosition = 51
        if firstStart {
            block5.runAction(fadeIn())
        }
        block5.zPosition = 201
        addChild(block5)
    }
    
    
    func addCharacter() {
        var char = Char()
        char.name = "char"
        if firstStart {
            char.timer3 = 0
            char.position = CGPointMake(screenSize.width/5, view!.frame.height + 10)
        }
        else {
            char.position = CGPointMake(screenSize.width/5, screenSize.height/2 + 8 * screenSize.height/320)
        }
        char.zPosition = 200
        addChild(char)
    }
    
    func addDivider() {
        let block = SKSpriteNode(color: SKColor.grayColor(), size: CGSizeMake(2, 500))
        block.position = CGPointMake(view!.frame.size.width/2, view!.frame.size.height/2)
        
        addChild(block)
    }
    
    func addWallGenerator() {
        var wallGenerator = WallGenerator()
        wallGenerator.position = CGPointMake(0, 0)
        wallGenerator.zPosition = 51
        wallGenerator.name = "wallGenerator"
        addChild(wallGenerator)
    }
    
    func addEnemyGenerator() {
        var enemyGenerator = EnemyGenerator(color: UIColor.clearColor(), size: CGSizeMake(1, 1))
        enemyGenerator.position = CGPointMake(0, 0)
        enemyGenerator.name = "enemyGenerator"
        enemyGenerator.zPosition = 102
        addChild(enemyGenerator)
    }
    
    func addBirdGenerator() {
        var birdGenerator = BirdGenerator(color: UIColor.clearColor(), size: CGSizeMake(1, 1))
        birdGenerator.position = CGPointMake(0, 0)
        birdGenerator.name = "birdGenerator"
        birdGenerator.zPosition = 102
        addChild(birdGenerator)
    }
    
    func addBird() {
        var bird = Bird()
        bird.name = "bird"
        bird.zPosition = 102
        addChild(bird)
    }
    
    func addRotater() {
        let EnGen = childNodeWithName("enemyGenerator") as! EnemyGenerator
        EnGen.addRotater()
    }
    
    func addCloudGenerator() {
        var cloudGenerator = CloudGenerator(color: UIColor.clearColor(), size: CGSizeMake(1, 1))
        cloudGenerator.position = CGPointMake(0, 0)
        addChild(cloudGenerator)
        cloudGenerator.populate(5)
        cloudGenerator.startGeneratingWithSpawnTime(8)
        cloudGenerator.name = "cloudGenerator"
    }
    
    func addCoinGenerator() {
        var coinGenerator = CoinGenerator(color: UIColor.clearColor(), size: CGSizeMake(1, 1))
        zPosition = 105
        coinGenerator.name = "coinGenerator"
        addChild(coinGenerator)
    }
    
    func addPowerUpGenerator() {
        var powerUpGenerator = PowerUpGenerator(color: UIColor.clearColor(), size: CGSizeMake(1, 1))
        zPosition = 105
        powerUpGenerator.name = "powerUpGenerator"
        addChild(powerUpGenerator)
        let dad = powerUpGenerator.parent!
    }
    
    func addTapToStartLabel() {
        let tapToStartLabel = SKLabelNode(text: "Tap to start!")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position.x = view!.center.x + 30
        tapToStartLabel.position.y = view!.center.y + 10
        tapToStartLabel.fontName = "ChalkboardSE-Regular"
        tapToStartLabel.fontColor = UIColor.blackColor()
        tapToStartLabel.fontSize = (screenSize.width/568) * 50.0
        tapToStartLabel.zPosition = 205
        addChild(tapToStartLabel)
        tapToStartLabel.runAction(blinkAnimation())
    }
    
    func addPointsLabels() {
        
        
        let difficultyLabel = PointsLabel(num: 0)
        difficultyLabel.position = CGPointMake(screenSize.width/4, 10)
        difficultyLabel.name = "difficultyLabel"
        difficultyLabel.zPosition = 199
        
        if firstStart {
            difficultyLabel.runAction(fadeIn())
        }
        //addChild(difficultyLabel)
        
        
        /*let line = SKShapeNode(rect: CGRectMake(screenSize.width/2, screenSize.height/2, 1, screenSize.height))
        addChild(line)
        let line2 = SKShapeNode(rect: CGRectMake(-15, screenSize.height/2, 1, screenSize.height))
        line.addChild(line2)
        let line3 = SKShapeNode(rect: CGRectMake(12, screenSize.height/2, 1, screenSize.height))
        line.addChild(line3)*/
        
        mustacheIcon = SKSpriteNode(texture: mustacheTexture2)
        mustacheIcon.position = CGPointMake(screenSize.width/2.55, view!.frame.size.height - 27)
        mustacheIcon.name = "mustacheIcon"
        mustacheIcon.size = CGSizeMake(mustacheTexture2.size().width/12, mustacheTexture2.size().height/9)
        mustacheIcon.zPosition = 100
        if firstStart {
            mustacheIcon.runAction(fadeIn())
        }
        addChild(mustacheIcon)
        
        let mustacheLabel = PointsLabel(num: 0)
        mustacheLabel.position = CGPointMake(0, -7)
        mustacheLabel.name = "mustacheLabel"
        mustacheLabel.zPosition = 100
        if firstStart {
            mustacheLabel.runAction(fadeIn())
        }
        mustacheLabel.colon(stacheCount)
        mustacheIcon.addChild(mustacheLabel)
        
        
        let heartIcon = SKSpriteNode(texture: heartTexture2)
        heartIcon.position = CGPointMake(screenSize.width/9.5, 0)
        heartIcon.name = "heartIcon"
        heartIcon.size = CGSizeMake(heartTexture.size().width/12, heartTexture.size().height/12.8)
        heartIcon.zPosition = 100
        if firstStart {
            heartIcon.runAction(fadeIn())
        }
        mustacheIcon.addChild(heartIcon)
        
        let heartLabel = PointsLabel(num: 0)
        heartLabel.position = CGPointMake(screenSize.width/6.7, -7)
        heartLabel.name = "heartLabel"
        heartLabel.zPosition = 100
        if firstStart {
            heartLabel.runAction(fadeIn())
        }
        heartLabel.colon(heartCount)
        mustacheIcon.addChild(heartLabel)
        
        let bombIcon = SKSpriteNode(texture: bombTexture)
        bombIcon.position = CGPointMake(screenSize.width/4.87, 4.5)
        bombIcon.name = "bombIcon"
        bombIcon.size = CGSizeMake(bombTexture.size().width/13.5, bombTexture.size().height/13.5)
        bombIcon.zPosition = 100
        if firstStart {
            bombIcon.runAction(fadeIn())
        }
        mustacheIcon.addChild(bombIcon)
        
        let bombLabel = PointsLabel(num: 0)
        bombLabel.position = CGPointMake(screenSize.width/4.1, -7)
        bombLabel.name = "bombLabel"
        bombLabel.zPosition = 199
        if firstStart {
            bombLabel.runAction(fadeIn())
        }
        bombLabel.colon(bombCount)
        mustacheIcon.addChild(bombLabel)
        
        /*
        let mustacheLabel = PointsLabel(num: 0)
        mustacheLabel.position = CGPointMake(screenSize.width/3, view!.frame.size.height - 34)
        mustacheLabel.name = "mustacheLabel"
        mustacheLabel.zPosition = 199
        if firstStart {
        mustacheLabel.runAction(fadeIn())
        }
        mustacheLabel.colon(stacheCount)
        addChild(mustacheLabel)
        
        
        let heartIcon = SKSpriteNode(texture: heartTexture2)
        heartIcon.position = CGPointMake(screenSize.width/2.15, view!.frame.size.height - 27)
        heartIcon.name = "heartIcon"
        heartIcon.size = CGSizeMake(heartTexture.size().width/12, heartTexture.size().height/12.8)
        heartIcon.zPosition = 199
        if firstStart {
        heartIcon.runAction(fadeIn())
        }
        addChild(heartIcon)
        
        let heartLabel = PointsLabel(num: 0)
        heartLabel.position = CGPointMake(screenSize.width/1.96, view!.frame.size.height - 34)
        heartLabel.name = "heartLabel"
        heartLabel.zPosition = 199
        if firstStart {
        heartLabel.runAction(fadeIn())
        }
        heartLabel.colon(heartCount)
        addChild(heartLabel)
        
        let bombIcon = SKSpriteNode(texture: bombTexture)
        bombIcon.position = CGPointMake(screenSize.width/1.77, view!.frame.size.height - 23)
        bombIcon.name = "bombIcon"
        bombIcon.size = CGSizeMake(bombTexture.size().width/14, bombTexture.size().height/14)
        bombIcon.zPosition = 199
        if firstStart {
        bombIcon.runAction(fadeIn())
        }
        addChild(bombIcon)
        
        let bombLabel = PointsLabel(num: 0)
        bombLabel.position = CGPointMake(screenSize.width/1.65, view!.frame.size.height - 34)
        bombLabel.name = "bombLabel"
        bombLabel.zPosition = 199
        if firstStart {
        bombLabel.runAction(fadeIn())
        }
        bombLabel.colon(bombCount)
        addChild(bombLabel)
        */
        
        if stacheCount < 10 {
            mustacheLabel.position.x = screenSize.width/20
        }
        else if stacheCount < 100 {
            mustacheLabel.position.x = screenSize.width/19.995
        }
        
        let pointsLabel = PointsLabel(num: 0)
        pointsLabel.position = CGPointMake(screenSize.width/6.8, view!.frame.size.height - 35)
        pointsLabel.name = "pointsLabel"
        pointsLabel.zPosition = 199
        
        if firstStart {
            pointsLabel.runAction(fadeIn())
        }
        addChild(pointsLabel)
        
        let highscoreLabel = PointsLabel(num: 0)
        highscoreLabel.name = "highscoreLabel"
        highscoreLabel.position = CGPointMake(screenSize.width/568, view!.frame.size.height + 80)
        highscoreLabel.zPosition = 199
        
        if firstStart {
            highscoreLabel.runAction(fadeIn())
        }
        addChild(highscoreLabel)
        
        let scoreTextLabel = SKLabelNode(text: "Score: ")
        scoreTextLabel.fontColor = UIColor.blackColor()
        scoreTextLabel.fontSize = 20.0
        scoreTextLabel.name = "scoretextlabel"
        scoreTextLabel.fontName = "ChalkboardSE-Regular"
        scoreTextLabel.position = CGPointMake(-45, 0)
        
        if firstStart {
            scoreTextLabel.runAction(fadeIn())
        }
        pointsLabel.addChild(scoreTextLabel)
        
        let highscoreTextLabel = SKLabelNode(text: "High Score: ")
        highscoreTextLabel.fontColor = UIColor.blackColor()
        highscoreTextLabel.fontSize = 14.0
        highscoreTextLabel.name = "highscoretextlabel"
        highscoreTextLabel.fontName = "ChalkboardSE-Regular"
        highscoreTextLabel.position = CGPointMake(-55, 0)
        
        if firstStart {
            highscoreTextLabel.runAction(fadeIn())
        }
        highscoreLabel.addChild(highscoreTextLabel)
    }
    
    func addPointAddition(num: Int, color: UIColor) {//, pos: CGPoint) {
        let pointAddition = PointAddition(num: num, color: color)
        //pointAddition.position = pos
        addChild(pointAddition)
        pointAddition.zPosition = 199
        if num < 0 {
            pointAddition.text = "\(num)"
        }
    }
    
    func addPointAdditionHeart(num: Int, color: UIColor) {//, pos: CGPoint) {
        let pointAddition = PointAddition(num: num, color: color)
        //pointAddition.position = pos
        mustacheIcon.addChild(pointAddition)
        pointAddition.zPosition = 199
        pointAddition.position.x = mustacheIcon.childNodeWithName("heartLabel")!.position.x
        pointAddition.position.y = pointAddition.position.y - mustacheIcon.position.y
        if num < 0 {
            pointAddition.text = "\(num)"
        }
    }
    
    func addPointAdditionStache(num: Int) {//, pos: CGPoint) {
        let color = UIColor(red: 3/255, green: 3/255, blue: 80/155, alpha: 1.0)
        let pointAddition = PointAddition(num: num, color: color)
        //pointAddition.position = pos
        mustacheIcon.addChild(pointAddition)
        pointAddition.zPosition = 199
        pointAddition.position.x = mustacheIcon.childNodeWithName("mustacheLabel")!.position.x
        pointAddition.position.y = pointAddition.position.y - mustacheIcon.position.y
        if num < 0 {
            pointAddition.text = "\(num)"
        }
    }
    
    func addPointAdditionBomb(num: Int) {//, pos: CGPoint) {
        let color = UIColor.blackColor()
        let pointAddition = PointAddition(num: num, color: color)
        //pointAddition.position = pos
        mustacheIcon.addChild(pointAddition)
        pointAddition.zPosition = 199
        pointAddition.position.x = mustacheIcon.childNodeWithName("bombLabel")!.position.x
        pointAddition.position.y = pointAddition.position.y - mustacheIcon.position.y
        if num < 0 {
            pointAddition.text = "\(num)"
        }
    }
    
    func addPhysicsWorld() {
        physicsWorld.contactDelegate = self
    }
    
    func loadHighscore() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let highscoreLabel = childNodeWithName("highscoreLabel") as! PointsLabel
        highscoreLabel.setTo(defaults.integerForKey("highscore"))
        
        if highscoreLabel.getNum() > 1000000 {
            highscoreLabel.position.x = (300.0 * screenSize.width/568) + 5 * CGFloat(6 * screenSize.width/568)
            highscoreLabel.childNodeWithName("highscoretextlabel")?.position.x = -55 - 5 * CGFloat(6 * screenSize.width/568)
        }
            
        else if highscoreLabel.getNum() > 100000 {
            highscoreLabel.position.x = (300 * screenSize.width/568) + 4 * CGFloat(6 * screenSize.width/568)
            highscoreLabel.childNodeWithName("highscoretextlabel")?.position.x = -55 - 4 * CGFloat(6 * screenSize.width/568)
        }
            
        else if highscoreLabel.getNum() > 10000 {
            highscoreLabel.position.x = (300 * screenSize.width/568) + 3 * CGFloat(6 * screenSize.width/568)
            highscoreLabel.childNodeWithName("highscoretextlabel")?.position.x = -55 - 3 * CGFloat(6 * screenSize.width/568)
        }
            
        else if highscoreLabel.getNum() > 1000 {
            highscoreLabel.position.x = (300 * screenSize.width/568) + 2 * CGFloat(6 * screenSize.width/568)
            highscoreLabel.childNodeWithName("highscoretextlabel")?.position.x = -55 - 2 * CGFloat(6 * screenSize.width/568)
        }
            
        else if highscoreLabel.getNum() > 100 {
            highscoreLabel.position.x = (300 * screenSize.width/568) + CGFloat(6 * screenSize.width/568)
            highscoreLabel.childNodeWithName("highscoretextlabel")?.position.x = -55 - CGFloat(6 * screenSize.width/568)
        }
        
    }
    
    func removeMenu() {
        let play = childNodeWithName("play") as! SKSpriteNode
        play.removeFromParent()
        let title = childNodeWithName("title") as! SKSpriteNode
        title.removeFromParent()
        let titleFace = childNodeWithName("titleface") as! SKSpriteNode
        titleFace.removeFromParent()
        let highScore = childNodeWithName("highscore") as! SKSpriteNode
        highScore.removeFromParent()
        let htp = childNodeWithName("htp") as! SKSpriteNode
        htp.removeFromParent()
        let settings = childNodeWithName("settings") as! SKSpriteNode
        settings.removeFromParent()
        //let sky = childNodeWithName("sky") as! SKSpriteNode
        //sky.removeFromParent()
        let pText = childNodeWithName("ptext") as! SKSpriteNode
        pText.removeFromParent()
    }
    
    func addPointer() {
        let char = childNodeWithName("char") as! Char
        let pointer = SKSpriteNode(texture: pointerTexture)
        pointer.size.width = pointer.size.width * 0.2
        pointer.size.height = pointer.size.height * 0.2
        pointer.anchorPoint = CGPointMake(0.093, 0.7073)
        pointer.position = CGPointMake(screenSize.width/1.3, screenSize.height/2)//CGPointMake(char.position.x + screenSize.width/2, char.position.y)
        pointer.zPosition = 10
        pointer.name = "pointer"
        pointer.alpha = 0.5
        pointer.anchorPoint = CGPointMake(0.48, 0.5)
        addChild(pointer)
        
        shootLoc = pointer.position
        
    }
    
    func begin() {
        
        //backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        //stopSound(mainSong!)
        
        powerUp1 = PowerUpToken(texture: invisble)
        powerUp1.isPressed = false
        powerUp2 = PowerUpToken(texture: invisble)
        powerUp2.isPressed = false
        powerUp3 = PowerUpToken(texture: invisble)
        powerUp3.isPressed = false
        
        moneyTimer = 1000
        stacheCount = 4
        heartCount = 1
        bombCount = 1
        difficulty = 1.1
        max = 8
        
        if firstStart {
            songTimer = 0
            removeMenu()
        }
        else {
            removeAllChildren()
            addSky()
        }
        
        inMenu = false
        inGame = true
        isStarted = false
        inGameOver = false
        inHighScore = false
        inPause = false
        inHowTo = false
        
        addCharacter()
        //addTouchPanel()
        //addSlidePanel()
        //addSlider()
        addWallGenerator()
        addEnemyGenerator()
        addBirdGenerator()
        addCoinGenerator()
        addMoneyGenerator()
        addPowerUpGenerator()
        addPointsLabels()
        addPowerUpArray()
        addPhysicsWorld()
        addPauseButton()
        
        if !firstStart {
            addCloudGenerator()
            addTapToStartLabel()
        }
        else {
            timer2 = 0
            firstStart = false
        }
        
        //self.view!.showsPhysics = true
    }
    
    func addPauseButton() {
        var pause = Button(texture: pauseTexture)
        pause.changeSize(0.3, h: 0.3)
        pause.position = CGPointMake(screenSize.width/1.06, screenSize.height/1.08)
        pause.name = "pause"
        pause.zPosition = 1000
        if firstStart {
            pause.runAction(fadeIn())
        }
        self.addChild(pause)
    }
    
    func addMoneyGenerator() {
        if childNodeWithName("moneyGenerator") == nil {
            let moneyGenerator = MoneyGenerator(color: UIColor.clearColor(), size: CGSizeMake(1, 1))
            moneyGenerator.name = "moneyGenerator"
            addChild(moneyGenerator)
        }
    }
    
    func generateMoney() {
        addYellow()
        moneyTimer = 0
        let moneyGenerator = childNodeWithName("moneyGenerator") as! MoneyGenerator
        moneyGenerator.startGeneratingWithSpawnTime(0.09)
    }
    
    func generateBird() {
        var scale: Int
        var rand = Int(arc4random_uniform(5))
        var rand2 = arc4random_uniform(2)
        var rand3 = CGFloat(arc4random_uniform(5)) + 0.01
        var two = CGFloat(arc4random_uniform(6))
        var chance = arc4random_uniform(3)
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        
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
        
        birdGenerator.birds.append(bird)
        birdGenerator.birdTrackers.append(bird)
        birdGenerator.addChild(bird)
        
    }
    
    func generatePowerUp() {
        var texture: SKTexture!
        var type: Int = 0
        let chance = arc4random_uniform(5)
        let chance2 = arc4random_uniform(3)
        let r = arc4random_uniform(2)
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        
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
        
        powerUpGenerator.powerUps.append(powerUp)
        powerUpGenerator.addChild(powerUp)
        
    }
    
    func addYellow() {
        let yellow = SKSpriteNode(texture: yellowTexture)
        yellow.size = CGSizeMake(screenSize.width, screenSize.height)
        yellow.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        yellow.zPosition = 2000
        yellow.alpha = 0.1
        yellow.name = "yellow"
        
        addChild(yellow)
        
        yellow.runAction(fadeIn2())
    }
    
    func addWhite() {
        let white = SKShapeNode(rect: CGRectMake(0, 0, screenSize.width, screenSize.height))
        white.zPosition = 2000
        white.alpha = 0.0
        white.name = "white"
        white.fillColor = UIColor.whiteColor()
        addChild(white)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.3)
        let wait = SKAction.waitForDuration(1)
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        white.runAction(SKAction.sequence([fadeIn, wait, fadeOut]))
    }
    
    func shooterMode() {
        let char = childNodeWithName("char") as! Char
        char.currentState = Char.CharStates.Shooter
        char.addRotateArm()
        addPointer()
    }
    
    func highScoreMenu() {
        
        inMenu = false
        inGame = false
        isStarted = false
        inGameOver = false
        inHighScore = true
        inHowTo = false
        inPause = false
        firstStart = true
        
        childNodeWithName("title")?.removeFromParent()
        childNodeWithName("titleface")?.removeFromParent()
        childNodeWithName("play")?.removeFromParent()
        childNodeWithName("ptext")?.removeFromParent()
        childNodeWithName("htp")?.removeFromParent()
        childNodeWithName("highscore")?.removeFromParent()
        childNodeWithName("settings")?.removeFromParent()
        
        let blur = SKShapeNode(rect: CGRectMake(0, 0, screenSize.width, screenSize.height))
        blur.fillColor = UIColor.orangeColor()
        blur.zPosition = 2000
        blur.alpha = 0.1
        blur.name = "blur"
        addChild(blur)
        
        let title = SKLabelNode(text: "High Scores")
        title.fontColor = UIColor.blackColor()
        title.fontName = "ChalkboardSE-Regular"
        title.fontSize = 60.0
        title.position = CGPointMake(screenSize.width/2, screenSize.height/1.2)
        title.zPosition = 2010
        title.name = "title"
        addChild(title)
        
        let hs1 = SKLabelNode(text: "1: \(highScores[0])")
        hs1.fontColor = UIColor(red: 94/255, green: 116/255, blue: 195/255, alpha: 1.0)
        hs1.fontName = "ChalkboardSE-Regular"
        hs1.fontSize = 25.0
        hs1.position = CGPointMake(-screenSize.width/50, -screenSize.height/5.2)
        hs1.zPosition = 2020
        hs1.name = "hs1"
        title.addChild(hs1)
        
        let hs2 = SKLabelNode(text: "2: \(highScores[1])")
        hs2.fontColor = UIColor(red: 94/255, green: 116/255, blue: 195/255, alpha: 1.0)
        hs2.fontName = "ChalkboardSE-Regular"
        hs2.fontSize = 25.0
        hs2.position = CGPointMake(0, -screenSize.height/9)
        hs2.zPosition = 0
        hs2.name = "hs2"
        hs1.addChild(hs2)
        
        let hs3 = SKLabelNode(text: "3: \(highScores[2])")
        hs3.fontColor = UIColor(red: 94/255, green: 116/255, blue: 195/255, alpha: 1.0)
        hs3.fontName = "ChalkboardSE-Regular"
        hs3.fontSize = 25.0
        hs3.position = CGPointMake(0, -screenSize.height/9)
        hs3.zPosition = 0
        hs3.name = "hs3"
        hs2.addChild(hs3)
        
        let hs4 = SKLabelNode(text: "4: \(highScores[3])")
        hs4.fontColor = UIColor(red: 94/255, green: 116/255, blue: 195/255, alpha: 1.0)
        hs4.fontName = "ChalkboardSE-Regular"
        hs4.fontSize = 25.0
        hs4.position = CGPointMake(0, -screenSize.height/9)
        hs4.zPosition = 0
        hs4.name = "hs4"
        hs3.addChild(hs4)
        
        let hs5 = SKLabelNode(text: "5: \(highScores[4])")
        hs5.fontColor = UIColor(red: 94/255, green: 116/255, blue: 195/255, alpha: 1.0)
        hs5.fontName = "ChalkboardSE-Regular"
        hs5.fontSize = 25.0
        hs5.position = CGPointMake(0, -screenSize.height/9)
        hs5.zPosition = 0
        hs5.name = "hs5"
        hs4.addChild(hs5)
        
        /*
        let cloud1 = SKSpriteNode(texture: cloudTexture)
        cloud1.size = CGSizeMake(CGFloat(110 + arc4random_uniform(50)), CGFloat(45 + arc4random_uniform(20)))
        cloud1.zPosition = -1
        cloud1.position = CGPointMake(-screenSize.width/75, screenSize.height/45)
        hs1.addChild(cloud1)
        
        let cloud2 = SKSpriteNode(texture: cloudTexture)
        cloud2.size = CGSizeMake(CGFloat(110 + arc4random_uniform(50)), CGFloat(45 + arc4random_uniform(20)))
        cloud2.zPosition = -1
        cloud2.position = CGPointMake(-screenSize.width/75, screenSize.height/45)
        hs2.addChild(cloud2)
        
        let cloud3 = SKSpriteNode(texture: cloudTexture)
        cloud3.size = CGSizeMake(CGFloat(110 + arc4random_uniform(50)), CGFloat(45 + arc4random_uniform(20)))
        cloud3.zPosition = -1
        cloud3.position = CGPointMake(-screenSize.width/75, screenSize.height/45)
        hs3.addChild(cloud3)
        
        let cloud4 = SKSpriteNode(texture: cloudTexture)
        cloud4.size = CGSizeMake(CGFloat(110 + arc4random_uniform(50)), CGFloat(45 + arc4random_uniform(20)))
        cloud4.zPosition = -1
        cloud4.position = CGPointMake(-screenSize.width/75, screenSize.height/45)
        hs4.addChild(cloud4)
        
        let cloud5 = SKSpriteNode(texture: cloudTexture)
        cloud5.size = CGSizeMake(CGFloat(110 + arc4random_uniform(50)), CGFloat(45 + arc4random_uniform(20)))
        cloud5.zPosition = -1
        cloud5.position = CGPointMake(-screenSize.width/75, screenSize.height/45)
        hs5.addChild(cloud5)
        */
        
        let cloud1 = SKSpriteNode(texture: bigCloudTexture)
        cloud1.size = CGSizeMake(bigCloudTexture.size().width * 0.35, bigCloudTexture.size().height * 0.3)
        cloud1.zPosition = -1
        cloud1.position = CGPointMake(screenSize.width/70, screenSize.height/12)
        hs3.addChild(cloud1)
        
        /*
        let colorize = SKAction.colorizeWithColor(UIColor.blueColor(), colorBlendFactor: 0.08, duration: 0.0)
        cloud1.runAction(colorize)
        cloud2.runAction(colorize)
        cloud3.runAction(colorize)
        cloud4.runAction(colorize)
        cloud5.runAction(colorize)*/
        
        let move1 = SKAction.moveByX(0, y: screenSize.height/40, duration: 2.0)
        let move2 = SKAction.moveByX(0, y: -screenSize.height/40, duration: 2.0)
        let move = SKAction.repeatActionForever(SKAction.sequence([move1, move2]))
        hs1.runAction(move)
        
        
        //back
        var back = Button(texture: menuTexture1)
        back.changeSize(0.26 * screenSize.width/568, h: 0.26 * screenSize.height/320)
        back.position = CGPointMake(screenSize.width/9, screenSize.height/7)
        back.name = "back"
        back.zPosition = 2000
        self.addChild(back)
        
        //Game Center
        var gCenter = Button(texture: gcTexture1)
        gCenter.changeSize(0.26 * screenSize.width/568, h: 0.26 * screenSize.height/320)
        gCenter.position = CGPointMake(screenSize.width - screenSize.width/8.5, screenSize.height/7)
        gCenter.name = "gCenter"
        gCenter.zPosition = 2000
        self.addChild(gCenter)
    }
    
    func openGameCenter() {
        NSNotificationCenter.defaultCenter().postNotificationName("authenticateID", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("showID", object: nil)
    }
    
    func sendGSScore(score: Int) {
        GSScore = score
        NSNotificationCenter.defaultCenter().postNotificationName("sendID", object: nil)
    }
    
    func pauseGame()
    {
        let char = childNodeWithName("char") as! Char
        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        let cloudGenerator = childNodeWithName("cloudGenerator") as! CloudGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
        let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        let slider = childNodeWithName("slider") as? Slider
        
        enemyGenerator.pauseEnemies()
        
        char.paused = true
        wallGenerator.paused = true
        enemyGenerator.paused = true
        birdGenerator.paused = true
        cloudGenerator.paused = true
        coinGenerator.paused = true
        moneyGenerator?.paused = true
        powerUpGenerator.paused = true
        
        if slider != nil {
            slider!.paused = true
        }
        //scene!.view!.paused = true
    }
    
    func unPauseGame()
    {
        //scene!.view!.paused = false
        inMenu = false
        inGame = true
        inGameOver = false
        inHighScore = false
        inPause = false
        inHowTo = false
        
        let bullet = childNodeWithName("stache") as? Bullet
        if bullet != nil {
            bullet!.paused = false
        }
        
        let block = childNodeWithName("pauseblock") as! SKSpriteNode
        let resume = childNodeWithName("resume") as! Button
        let score = childNodeWithName("pausescore") as! SKLabelNode
        let score2 = childNodeWithName("highscore") as! SKLabelNode
        let cloud = childNodeWithName("cloud") as! SKSpriteNode
        let menu = childNodeWithName("pausemenu") as! SKSpriteNode
        let title = childNodeWithName("paused") as! SKSpriteNode
        let back = childNodeWithName("back") as? SKSpriteNode
        let gCenter = childNodeWithName("gCenter") as? SKSpriteNode
        
        block.removeFromParent()
        resume.removeFromParent()
        score.removeFromParent()
        score2.removeFromParent()
        cloud.removeFromParent()
        menu.removeFromParent()
        title.removeFromParent()
        back?.removeFromParent()
        gCenter?.removeFromParent()
        
        let pause = childNodeWithName("pause") as! Button
        
        pause.changeTexture(pauseTexture)
        pause.changeSize(0.909, h: 0.909)
        pause.size.width = pauseTexture.size().width * 0.3
        pause.size.height = pauseTexture.size().height * 0.3
        
        let char = childNodeWithName("char") as! Char
        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        let cloudGenerator = childNodeWithName("cloudGenerator") as! CloudGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
        let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        let slider = childNodeWithName("slider") as? Slider
        
        char.paused = false
        wallGenerator.paused = false
        enemyGenerator.paused = false
        birdGenerator.paused = false
        cloudGenerator.paused = false
        coinGenerator.paused = false
        moneyGenerator?.paused = false
        powerUpGenerator.paused = false
        
        enemyGenerator.unPauseEnemies()
        
        if slider != nil {
            slider!.paused = false
        }
        
        on = true
        wallGenerator.on = true
        coinGenerator.on = true
        enemyGenerator.on = true
        birdGenerator.on = true
        cloudGenerator.on = true
        moneyGenerator?.on = true
        powerUpGenerator.on = true
        
        resumeGenerators()
        
    }
    
    func addGunner() {
        let gunner = Gunner(texture: gunnerTexture, char: childNodeWithName("char") as! Char, gen: childNodeWithName("enemyGenerator") as! EnemyGenerator)
        gunner.name = "gunner"
        gunner.zPosition = 102
        addChild(gunner)
    }
    
    // MARK: - Game Lifecycle
    func start() {
        
        inMenu = false
        inGame = true
        isStarted = true
        inGameOver = false
        inHighScore = false
        inPause = false
        inHowTo = false
        
        //addGunner()
        let char = childNodeWithName("char") as! Char
        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
        let cloudGenerator = childNodeWithName("cloudGenerator") as! CloudGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        
        animateSky()
        
        addCeiling()
        char.addCape2()
        char.timer = 0
        
        cloudGenerator.moveFaster()
        cloudGenerator.generateFirstCloud()
        /*cloudGenerator.startGeneratingWithSpawnTime(0.9)
        wallGenerator.startGeneratingWallsEvery(4.2)
        enemyGenerator.startGeneratingEnemysEvery(3)
        birdGenerator.startGeneratingBirdsEvery(12)
        coinGenerator.startGeneratingWithSpawnTime(0.4)
        powerUpGenerator.startGeneratingWithSpawnTime(16)*/
        cloudGenerator.startGeneratingWithSpawnTime(1.1)
        wallGenerator.startGeneratingWallsEvery(4.1)//(4.3)
        enemyGenerator.startGeneratingEnemysEvery(1.6)//(2)
        birdGenerator.startGeneratingBirdsEvery(16)
        coinGenerator.startGeneratingWithSpawnTime(0.38)
        powerUpGenerator.startGeneratingWithSpawnTime(12)
        char.changeTexture(mainCharTexture)
        char.addLeftArm()
        char.addRightArm()
        char.setPhysicsBody(mainCharTexture, width: char.size.width * 0.95, height: char.size.height * 0.95)
        char.currentState = Char.CharStates.Touch
        char.blink?.removeFromParent()
        char.timer2 = 0
        
        let tapToStartLabel = childNodeWithName("tapToStartLabel")
        tapToStartLabel?.removeFromParent()
        
    }
    
    func pauseGenerators() {
        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
        let cloudGenerator = childNodeWithName("cloudGenerator") as! CloudGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
        let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        
        wallGenerator.pauseGenerating()
        cloudGenerator.pauseGenerating()
        enemyGenerator.pauseGenerating()
        birdGenerator.pauseGenerating()
        coinGenerator.pauseGenerating()
        if moneyTimer < 472 {
            moneyGenerator?.pauseGenerating()
        }
        powerUpGenerator.pauseGenerating()
    }
    
    func killGenerators() {
        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
        let cloudGenerator = childNodeWithName("cloudGenerator") as! CloudGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
        let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        
        wallGenerator.stopGenerating()
        cloudGenerator.stopGenerating()
        enemyGenerator.stopGenerating()
        birdGenerator.stopGenerating()
        coinGenerator.stopGenerating()
        if moneyTimer < 472 {
            moneyGenerator?.stopGenerating()
        }
        powerUpGenerator.stopGenerating()
    }
    
    func resumeGenerators() {
        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
        let cloudGenerator = childNodeWithName("cloudGenerator") as! CloudGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
        let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        
        wallGenerator.resumeGenerating()
        cloudGenerator.resumeGenerating()
        enemyGenerator.resumeGenerating()
        birdGenerator.resumeGenerating()
        coinGenerator.resumeGenerating()
        if moneyTimer < 472 {
            moneyGenerator?.resumeGenerating()
        }
        powerUpGenerator.resumeGenerating()
    }
    
    func stopEverything() {
        let char = childNodeWithName("char") as! Char
        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
        let cloudGenerator = childNodeWithName("cloudGenerator") as! CloudGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
        let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        
        // stop everything
        wallGenerator.stopWalls()
        wallGenerator.on = false
        cloudGenerator.stopGenerating()
        cloudGenerator.startGeneratingWithSpawnTime(8)
        cloudGenerator.moveSlower()
        enemyGenerator.stopEnemys()
        enemyGenerator.on = false
        birdGenerator.stopBirds()
        birdGenerator.on = false
        coinGenerator.stopCoins()
        coinGenerator.on = false
        if moneyTimer < 550 {
            moneyGenerator?.stopCoins()
        }
        moneyGenerator?.on = false
        powerUpGenerator.stopPowerUps()
        powerUpGenerator.on = false
    }
    
    func gameOver() {
        
        inMenu = false
        inGame = false
        isStarted = false
        inGameOver = true
        inHighScore = false
        inPause = false
        inHowTo = false
        
        let char = childNodeWithName("char") as! Char
        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
        let cloudGenerator = childNodeWithName("cloudGenerator") as! CloudGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
        let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
        
        addGameOverMenu()
        
        // stop everything
        wallGenerator.stopWalls()
        wallGenerator.on = false
        cloudGenerator.stopGenerating()
        cloudGenerator.startGeneratingWithSpawnTime(8)
        cloudGenerator.moveSlower()
        enemyGenerator.stopEnemys()
        enemyGenerator.on = false
        birdGenerator.stopBirds()
        birdGenerator.on = false
        coinGenerator.stopCoins()
        coinGenerator.on = false
        if moneyTimer < 550 {
            moneyGenerator?.stopCoins()
        }
        moneyGenerator?.on = false
        powerUpGenerator.stopPowerUps()
        powerUpGenerator.on = false
        
        char.endShooting()
        if char.greenTimer == 1000 {
            char.dead2()
        }
        char.timer = 100
        
        charAccel = 0.23 * screenSize.height/375
        
        
        // Send GC the score
        let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
        sendGSScore(pointsLabel.number)
        // save current points label value
        saveHighScores()
        
        /*
        let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
        let highscoreLabel = childNodeWithName("highscoreLabel") as! PointsLabel
        
        if pointsLabel.number > highscoreLabel.number {
        highscoreLabel.setTo(pointsLabel.number)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(highscoreLabel.number, forKey: "highscore")
        }
        */
    }
    
    func newHighScore() {
        
    }
    
    func saveHighScores() {
        // save current points label value
        let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
        
        var i: Int = 0
        var cont = true
        
        for i = 0; i < 5; i++ {
            if pointsLabel.number > highScores[i] && cont {
                cont = false
                highScores.insert(pointsLabel.number, atIndex: i)
                newHighScore()
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setInteger(highScores[0], forKey: "highscore1")
                defaults.setInteger(highScores[1], forKey: "highscore2")
                defaults.setInteger(highScores[2], forKey: "highscore3")
                defaults.setInteger(highScores[3], forKey: "highscore4")
                defaults.setInteger(highScores[4], forKey: "highscore5")
                break
            }
        }
    }
    func loadHighscores() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var i: Int = 0
        
        /*
        if highScores.count == 0 {
        highScores.append(0)
        highScores.append(0)
        highScores.append(0)
        highScores.append(0)
        highScores.append(0)
        }
        else if highScores.count == 1 {
        highScores.append(0)
        highScores.append(0)
        highScores.append(0)
        highScores.append(0)
        }
        else if highScores.count == 2 {
        highScores.append(0)
        highScores.append(0)
        highScores.append(0)
        }
        else if highScores.count == 3 {
        highScores.append(0)
        highScores.append(0)
        }
        else if highScores.count == 4 {
        highScores.append(0)
        }
        */
        
        highScores.append(defaults.integerForKey("highscore1"))
        highScores.append(defaults.integerForKey("highscore2"))
        highScores.append(defaults.integerForKey("highscore3"))
        highScores.append(defaults.integerForKey("highscore4"))
        highScores.append(defaults.integerForKey("highscore5"))
        
        /*
        highScores[0] = defaults.integerForKey("highscore1")
        highScores[1] = defaults.integerForKey("highscore2")
        highScores[2] = defaults.integerForKey("highscore3")
        highScores[3] = defaults.integerForKey("highscore4")
        highScores[4] = defaults.integerForKey("highscore5")
        */
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let char = childNodeWithName("char") as? Char
        let slider = childNodeWithName("slider") as? Slider
        let block = childNodeWithName("block") as? SKSpriteNode
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if inMenu {
                let play = childNodeWithName("play") as! Button
                let pText = childNodeWithName("ptext") as! SKSpriteNode
                if play.frame.contains(location) {
                    play.changeTexture(blueButtonTexture)
                    pText.texture = SKTexture(imageNamed: "p2")
                    play.isPressed = true
                }
                
                let highScore = childNodeWithName("highscore") as! Button
                if highScore.frame.contains(location) {
                    highScore.changeTexture(trophyTexture2)
                    highScore.isPressed = true
                }
                
                let htp = childNodeWithName("htp") as! Button
                if htp.frame.contains(location) {
                    htp.changeTexture(htpTexture2)
                    htp.isPressed = true
                }
                
                let settings = childNodeWithName("settings") as! Button
                if settings.frame.contains(location) {
                    settings.changeTexture(settingsTexture2)
                    settings.isPressed = true
                }
            }
                
            else if inHighScore {
                let back = childNodeWithName("back") as! Button
                let gCenter = childNodeWithName("gCenter") as! Button
                if back.frame.contains(location) {
                    back.changeTexture(menuTexture2)
                    back.isPressed = true
                }
                if gCenter.frame.contains(location) {
                    gCenter.changeTexture(gcTexture2)
                    gCenter.isPressed = true
                }
            }
            
            if inGameOver && !inGame {
                let playAgain = childNodeWithName("playagain") as! Button
                let back = childNodeWithName("back") as! Button
                //let gCenter = childNodeWithName("gCenter") as! Button
                if back.frame.contains(location) {
                    back.changeTexture(menuTexture2)
                    back.isPressed = true
                }
                /*
                if gCenter.frame.contains(location) {
                gCenter.changeTexture(gcTexture2)
                gCenter.isPressed = true
                }*/
                if playAgain.frame.contains(location) {
                    playAgain.texture = SKTexture(imageNamed: "playagain2")
                    playAgain.isPressed = true
                }
            }
            
            if inGame && isStarted {
                
                if location.y > screenSize.height * 0.7 {
                    bombSwipe = true
                }
                let pause = childNodeWithName("pause") as! Button
                let powerUpArray = childNodeWithName("powerUpArray") as! PowerUpArray
                /*
                if slider!.frame.contains(location) ||  block!.frame.contains(location) {
                slider!.isGrabbed = true
                slider!.size.height = slider!.size.height * 1.2
                slider!.size.width = slider!.size.width * 1.2
                slider!.position.y = location.y
                }
                
                else*/
                ind = 0
                for token in powerUpArray.powerUps {
                    if ind == 0 {
                        powerUp1 = token
                    }
                    else if ind == 1 {
                        powerUp2 = token
                    }
                    else if ind == 2 {
                        powerUp3 = token
                    }
                    ind = ind + 1
                }
                
                if char!.normal && powerUp1.frame.contains(location) {
                    powerUp1Pressed = true
                    powerUp1.changeSize(1.1, h: 1.1)
                }
                    
                else if char!.normal && powerUp2.frame.contains(location) {
                    powerUp2Pressed = true
                    powerUp2.changeSize(1.1, h: 1.1)
                }
                    
                else if char!.normal && powerUp3.frame.contains(location) {
                    powerUp3Pressed = true
                    powerUp3.changeSize(1.1, h: 1.1)
                }
                    
                else if pause.frame.contains(location) {
                    pause.isPressed = true
                    pause.changeSize(1.1, h: 1.1)
                }
                    
                else {
                    if char!.currentState == Char.CharStates.Big && location.x > 130 && char!.canPrep {
                        char!.prepareHit()
                    }
                    if char!.currentState == Char.CharStates.Shooter && location.x > 130 {
                        shootLoc = location
                        let pointer = childNodeWithName("pointer") as! SKSpriteNode
                        pointer.position = CGPointMake(location.x, location.y)
                    }
                    else if char!.canHold && location.x > 130 && stacheCount > 0 {
                        char!.hold()
                        runAction(grab, withKey: "grab")
                        char!.arm.rotate(location.x, b: location.y, c: char!.position.x, d: char!.position.y)
                    }
                    else if char!.canHold && location.x > 130 && stacheCount == 0 {
                        char!.nohold()
                    }
                    else if (char!.currentState == Char.CharStates.Touch || char!.currentState == Char.CharStates.Shooting || char!.currentState == Char.CharStates.Big || char!.currentState == Char.CharStates.Shooter || char!.currentState == Char.CharStates.Super) && location.x < 100 && char!.position.y <= screenSize.height - 20 {
                        char!.accelY = charAccel
                        //char!.locationY = location.y
                        movingUp = true
                    }
                    else if (char!.currentState == Char.CharStates.Touch || char!.currentState == Char.CharStates.Shooting) && location.x < 100 && char!.position.y > screenSize.height - 40 {
                        char!.moveUpLater = true
                    }
                }
            }
            
            if inPause {
                let resume = childNodeWithName("resume") as! Button
                let back = childNodeWithName("back") as! Button
                let gCenter = childNodeWithName("gCenter") as! Button
                if back.frame.contains(location) {
                    back.changeTexture(menuTexture2)
                    back.isPressed = true
                }
                if gCenter.frame.contains(location) {
                    gCenter.changeTexture(gcTexture2)
                    gCenter.isPressed = true
                }
                if resume.frame.contains(location) {
                    resume.changeTexture(resumeTexture2)
                    resume.isPressed = true
                }
            }
            
            if inHowTo && !inMenu {
                if howToCount == 1 {
                    removeImage()
                    addImage("howto2")
                    howToCount = 2
                }
                else if howToCount == 2 {
                    removeImage()
                    addImage("howto3")
                    howToCount = 3
                }
                else if howToCount == 3 {
                    removeImage()
                    inMenu = true
                    inGame = false
                    isStarted = false
                    inGameOver = false
                    inHighScore = false
                    inHowTo = false
                    inPause = false
                    firstStart = false
                    addMenu()
                }
            }
            
            
        }
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let char = childNodeWithName("char") as? Char
        let slider = childNodeWithName("slider") as? Slider
        let powerUpArray = childNodeWithName("powerUpArray") as? PowerUpArray
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if inMenu {
                let play = childNodeWithName("play") as! Button
                let pText = childNodeWithName("ptext") as! SKSpriteNode
                if play.frame.contains(location) && play.isPressed {
                    play.changeTexture(blueButtonTexture)
                    pText.texture = SKTexture(imageNamed: "p2")
                }
                if !play.frame.contains(location) {
                    play.changeTexture(whiteButtonTexture)
                    pText.texture = SKTexture(imageNamed: "p1")
                }
                
                let highScore = childNodeWithName("highscore") as! Button
                if highScore.frame.contains(location) && highScore.isPressed {
                    highScore.changeTexture(trophyTexture2)
                }
                if !highScore.frame.contains(location) {
                    highScore.changeTexture(trophyTexture1)
                }
                
                let htp = childNodeWithName("htp") as! Button
                if htp.frame.contains(location) && htp.isPressed {
                    htp.changeTexture(htpTexture2)
                }
                if !htp.frame.contains(location) {
                    htp.changeTexture(htpTexture1)
                }
                
                let settings = childNodeWithName("settings") as! Button
                if settings.frame.contains(location) && settings.isPressed {
                    settings.changeTexture(settingsTexture2)
                }
                if !settings.frame.contains(location) {
                    settings.changeTexture(settingsTexture1)
                }
            }
                
            else if inHighScore {
                let back = childNodeWithName("back") as! Button
                let gCenter = childNodeWithName("gCenter") as! Button
                if back.frame.contains(location) && back.isPressed {
                    back.changeTexture(menuTexture2)
                }
                if !back.frame.contains(location) {
                    back.changeTexture(menuTexture1)
                }
                if gCenter.frame.contains(location) && gCenter.isPressed {
                    gCenter.changeTexture(gcTexture2)
                }
                if !gCenter.frame.contains(location) {
                    gCenter.changeTexture(gcTexture1)
                }
            }
                
            else if inGameOver && !inGame {
                let playAgain = childNodeWithName("playagain") as! Button
                let back = childNodeWithName("back") as! Button
                let gCenter = childNodeWithName("gCenter") as! Button
                if playAgain.frame.contains(location) && playAgain.isPressed {
                    playAgain.changeTexture(playAgainTexture2)
                }
                if !playAgain.frame.contains(location) {
                    playAgain.changeTexture(playAgainTexture1)
                }
                if back.frame.contains(location) {
                    back.changeTexture(menuTexture2)
                    back.isPressed = true
                }
                if !back.frame.contains(location) {
                    back.changeTexture(menuTexture1)
                    back.isPressed = false
                }
                if gCenter.frame.contains(location) {
                    gCenter.changeTexture(gcTexture2)
                    gCenter.isPressed = true
                }
                if !gCenter.frame.contains(location) {
                    gCenter.changeTexture(gcTexture1)
                    gCenter.isPressed = false
                }
            }
            /*
            else if inGame && isStarted && slider!.isGrabbed {
            if location.x < 90 {
            slider!.position.y = location.y
            }
            else if location.x < 92{
            slider!.isGrabbed = false
            slider!.size.height = slider!.size.height / 1.2
            slider!.size.width = slider!.size.width / 1.2
            }
            }*/
            
            if inGame && isStarted && char!.isHolding {
                if location.x > 142 {
                    char!.arm.rotate(location.x, b: location.y, c: char!.position.x, d: char!.position.y)
                }
                else if location.x > 130 {
                    let x = location.x - char!.position.x
                    let y = location.y - char!.position.y
                    
                    var bullet = Bullet(texture: mustacheTexture)
                    bullet.position = CGPointMake(char!.position.x + 20, char!.position.y)
                    bullet.name = "stache"
                    bullet.changeSpeed(x, y: y)
                    bullet.zPosition = 300
                    if char!.shrunk {
                        bullet.size.width *= 0.18
                        bullet.size.height *= 0.18
                    }
                    addChild(bullet)
                    let label = mustacheIcon.childNodeWithName("mustacheLabel") as! PointsLabel
                    if stacheCount == max {
                        label.fontColor = UIColor.blackColor()
                    }
                    stacheCount = stacheCount - 1
                    addPointAdditionStache(-1)
                    if stacheCount == 0 {
                        label.fontColor = UIColor.redColor()
                        char!.changeTexture(stachelessTexture)
                    }
                    else if stacheCount < 10 {
                        label.position.x = screenSize.width/20
                    }
                    else if stacheCount < 100 {
                        label.position.x = screenSize.width/19.995
                    }
                    label.colon(stacheCount)
                    char!.shoot(location, x: x, y: y)
                    char!.arm.rotate(location.x, b: location.y, c: char!.position.x, d: char!.position.y)
                }
            }
            
            if inGame && isStarted {
                
                if location.y < screenSize.height * 0.5 && didSwipeDown && bombSwipe && bombCount > 0 && bombTimer == 1000 {
                    didSwipeDown = false
                    bombSwipe = false
                    dropBomb()
                }
                if char!.accelY > 0 && location.x < 145 && location.x > 100 {
                    char!.accelY = -charAccel
                    movingUp = false
                    char!.moveUpLater = false
                }
                
                if (char!.currentState == Char.CharStates.Touch || char!.currentState == Char.CharStates.Shooting || char!.currentState == Char.CharStates.Big || char!.currentState == Char.CharStates.Shooter) && location.x < 100 && char!.position.y <= screenSize.height - 20 {
                    //char!.locationY = location.y
                }
                
                if (char!.currentState == Char.CharStates.Touch || char!.currentState == Char.CharStates.Shooting || char!.currentState == Char.CharStates.Big || char!.currentState == Char.CharStates.Shooter) && location.x < 120 && char!.position.y > screenSize.height - 40 {
                    char!.moveUpLater = true
                }
                
                
                if char!.normal && !powerUp1Pressed && powerUp1.frame.contains(location) {
                    powerUp1Pressed = true
                    powerUp1.changeSize(1.1, h: 1.1)
                }
                
                if char!.normal &&  powerUp1Pressed && !powerUp1.frame.contains(location) {
                    powerUp1Pressed = false
                    powerUp1.changeSize(0.909, h: 0.909)
                }
                
                if char!.normal && !powerUp2Pressed && powerUp2.frame.contains(location) {
                    powerUp2Pressed = true
                    powerUp2.changeSize(1.1, h: 1.1)
                }
                if char!.normal && powerUp2Pressed && !powerUp2.frame.contains(location) {
                    powerUp2Pressed = false
                    powerUp2.changeSize(0.909, h: 0.909)
                }
                
                if char!.normal && !powerUp3Pressed && powerUp3.frame.contains(location) {
                    powerUp3Pressed = true
                    powerUp3.changeSize(1.1, h: 1.1)
                }
                if char!.normal && powerUp3Pressed && !powerUp3.frame.contains(location) {
                    powerUp3Pressed = false
                    powerUp3.changeSize(0.909, h: 0.909)
                }
                
                let pause = childNodeWithName("pause") as! Button
                if !pause.isPressed && pause.frame.contains(location) {
                    pause.isPressed = true
                    pause.changeSize(1.1, h: 1.1)
                }
                if pause.isPressed && !pause.frame.contains(location) {
                    pause.isPressed = false
                    pause.changeSize(0.909, h: 0.909)
                }
            }
                
            else if inPause {
                let resume = childNodeWithName("resume") as! Button
                let back = childNodeWithName("back") as! Button
                let gCenter = childNodeWithName("gCenter") as! Button
                if back.frame.contains(location) {
                    back.changeTexture(menuTexture2)
                    back.isPressed = true
                }
                if !back.frame.contains(location) {
                    back.changeTexture(menuTexture1)
                    back.isPressed = false
                }
                if gCenter.frame.contains(location) {
                    gCenter.changeTexture(gcTexture2)
                    gCenter.isPressed = true
                }
                if !gCenter.frame.contains(location) {
                    gCenter.changeTexture(gcTexture1)
                    gCenter.isPressed = false
                }
                if resume.frame.contains(location) && resume.isPressed {
                    resume.changeTexture(resumeTexture2)
                }
                if !resume.frame.contains(location) && resume.isPressed  {
                    resume.changeTexture(resumeTexture1)
                }
            }
            
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let char = childNodeWithName("char") as? Char
        let slider = childNodeWithName("slider") as? Slider
        let powerUpArray = childNodeWithName("powerUpArray") as? PowerUpArray
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            bombSwipe = false
            didSwipeDown = false
            
            ind = 0
            
            if inGame && !isStarted && timer2 == 51 {
                start()
            }
            else if inGame {
                let pause = childNodeWithName("pause") as! Button
                
                if char!.normal && powerUp1Pressed && powerUp1.frame.contains(location) {
                    if char!.normal {
                        let val = powerUp1.getType()
                        if val == 1 {
                            char!.normal = false
                            char!.addGlasses()
                            char!.blink?.removeFromParent()
                            generateMoney()
                        }
                        else if val == 2 {
                            char!.normal = false
                            char!.grow()
                        }
                        else if val == 3 {
                            char!.normal = false
                            charAccel = 0.65 * screenSize.height/375
                            char!.shrink2()
                        }
                        else if val == 4 {
                            char!.normal = false
                            shooterMode()
                        }
                        else if val == 5 {
                            char!.normal = false
                            char!.addSuper()
                        }
                        powerUpArray!.removePowerUp(powerUp1)
                    }
                }
                    
                else if char!.normal && powerUp2Pressed && powerUp2.frame.contains(location) {
                    if char!.normal {
                        let val = powerUp2.getType()
                        if val == 1 {
                            char!.normal = false
                            char!.addGlasses()
                            char!.blink.removeFromParent()
                            generateMoney()
                        }
                        else if val == 2 {
                            char!.normal = false
                            char!.grow()
                        }
                        else if val == 3 {
                            char!.normal = false
                            charAccel = 0.65 * screenSize.height/375
                            char!.shrink2()
                        }
                        else if val == 4 {
                            char!.normal = false
                            shooterMode()
                        }
                        else if val == 5 {
                            char!.normal = false
                            char!.addSuper()
                        }
                        powerUpArray!.removePowerUp(powerUp2)
                    }
                }
                    
                else if char!.normal && powerUp3Pressed && powerUp3.frame.contains(location) {
                    if char!.normal {
                        let val = powerUp3.getType()
                        if val == 1 {
                            char!.normal = false
                            char!.addGlasses()
                            char!.blink.removeFromParent()
                            generateMoney()
                        }
                        else if val == 2 {
                            char!.normal = false
                            char!.grow()
                        }
                        else if val == 3 {
                            char!.normal = false
                            charAccel = 0.65 * screenSize.height/375
                            char!.shrink2()
                        }
                        else if val == 4 {
                            char!.normal = false
                            shooterMode()
                        }
                        else if val == 5 {
                            char!.normal = false
                            char!.addSuper()
                        }
                        powerUpArray!.removePowerUp(powerUp3)
                    }
                }
                    
                else if pause.isPressed && pause.frame.contains(location) {
                    if !inPause {
                        //char!.addSuper()
                        addPauseMenu()
                    }
                }
                /*
                if isStarted && location.x < 90 {
                if slider!.isGrabbed {
                slider!.isGrabbed = false
                slider!.size.height = slider!.size.height / 1.2
                slider!.size.width = slider!.size.width / 1.2
                }
                }*/
                if isStarted && location.x > 130 {
                    if char!.currentState == Char.CharStates.Big && char!.canHit {
                        char!.hit()
                    }
                    if char!.isHolding {
                        let x = location.x - char!.position.x
                        let y = location.y - char!.position.y
                        
                        var bullet = Bullet(texture: mustacheTexture)
                        bullet.position = CGPointMake(char!.position.x + 20, char!.position.y)
                        bullet.name = "stache"
                        bullet.changeSpeed(x, y: y)
                        bullet.zPosition = 300
                        addChild(bullet)
                        let label = mustacheIcon.childNodeWithName("mustacheLabel") as! PointsLabel
                        if stacheCount == max {
                            label.fontColor = UIColor.blackColor()
                        }
                        stacheCount = stacheCount - 1
                        addPointAdditionStache(-1)
                        if stacheCount == 0 {
                            label.fontColor = UIColor.redColor()
                            char!.changeTexture(stachelessTexture)
                        }
                        else if stacheCount < 10 {
                            label.position.x = screenSize.width/20
                        }
                        else if stacheCount < 100 {
                            label.position.x = screenSize.width/19.995
                        }
                        label.colon(stacheCount)
                        char!.shoot(location, x: x, y: y)
                        char!.arm.rotate(location.x, b: location.y, c: char!.position.x, d: char!.position.y)
                    }
                }
                
                if isStarted && location.x < 100 && (char!.currentState == Char.CharStates.Touch || char!.currentState == Char.CharStates.Shooting || char!.currentState == Char.CharStates.Big || char!.currentState == Char.CharStates.Shooter || char!.currentState == Char.CharStates.Super) {
                    char!.accelY = -charAccel
                    //char!.locationY = char!.position.y
                    movingUp = false
                    char!.moveUpLater = false
                }
            }
            
            if inMenu {
                let play = childNodeWithName("play") as! Button
                let highScore = childNodeWithName("highscore") as! Button
                let htp = childNodeWithName("htp") as! Button
                let settings = childNodeWithName("settings") as! Button
                if play.frame.contains(location) && play.isPressed  {
                    inMenu = false
                    play.isPressed = false
                    highScore.isPressed = false
                    htp.isPressed = false
                    settings.isPressed = false
                    begin()
                }
                else if highScore.frame.contains(location) && highScore.isPressed  {
                    play.isPressed = false
                    highScore.isPressed = false
                    htp.isPressed = false
                    settings.isPressed = false
                    highScore.texture = trophyTexture1
                    highScoreMenu()
                }
                else if htp.frame.contains(location) && htp.isPressed  {
                    /*inMenu = false
                    inGame = false
                    isStarted = false
                    inGameOver = false
                    inHighScore = false
                    inHowTo = true
                    inPause = false
                    firstStart = false*/
                    play.isPressed = false
                    highScore.isPressed = false
                    htp.isPressed = false
                    settings.isPressed = false
                    htp.texture = htpTexture1
                    //howToCount = 1
                    //removeAllChildren()
                    //addImage("howto1")
                }
                else if settings.frame.contains(location) && settings.isPressed  {
                    /*inMenu = false
                    inGame = false
                    isStarted = false
                    inGameOver = false
                    inHighScore = false
                    inHowTo = true
                    inPause = false
                    firstStart = false*/
                    play.isPressed = false
                    highScore.isPressed = false
                    htp.isPressed = false
                    settings.isPressed = false
                    settings.texture = settingsTexture1
                    //howToCount = 1
                    //removeAllChildren()
                    //addImage("howto1")
                    NSNotificationCenter.defaultCenter().postNotificationName("faceBookID", object: nil)
                }
                else {
                    play.isPressed = false
                    highScore.isPressed = false
                    htp.isPressed = false
                    settings.isPressed = false
                }
            }
                
            else if inHighScore {
                let back = childNodeWithName("back") as! Button
                let gCenter = childNodeWithName("gCenter") as! Button
                if back.frame.contains(location) && back.isPressed {
                    inMenu = true
                    inGame = false
                    isStarted = false
                    inGameOver = false
                    inHighScore = false
                    inHowTo = false
                    inPause = false
                    firstStart = true
                    firstOpen = false
                    back.removeFromParent()
                    gCenter.removeFromParent()
                    childNodeWithName("title")?.removeFromParent()
                    childNodeWithName("blur")?.removeFromParent()
                    addMenu()
                    back.changeTexture(whiteButtonTexture)
                    back.isPressed = false
                    gCenter.isPressed = false
                }
                if gCenter.frame.contains(location) && gCenter.isPressed{
                    openGameCenter()
                    gCenter.changeTexture(gcTexture1)
                    gCenter.isPressed = false
                    back.isPressed = false
                }
                else {
                    back.isPressed = false
                    gCenter.isPressed = false
                }
            }
            
            if inGameOver {
                let playAgain = childNodeWithName("playagain") as? Button
                let back = childNodeWithName("back") as! Button
                //let gCenter = childNodeWithName("gCenter") as! Button
                if back.frame.contains(location) {
                    back.changeTexture(menuTexture1)
                    back.isPressed = false
                    //gCenter.isPressed = false
                    killGenerators()
                    returnToMenu()
                }
                /*
                if gCenter.frame.contains(location) {
                openGameCenter()
                gCenter.changeTexture(gcTexture1)
                gCenter.isPressed = false
                back.isPressed = false
                }*/
                
                if playAgain!.frame.contains(location) && playAgain!.isPressed {
                    killGenerators()
                    inGameOver = false
                    begin()
                }
                else {
                    playAgain!.isPressed = false
                    back.isPressed = false
                    //gCenter.isPressed = false
                }
            }
            
            if inPause {
                let resume = childNodeWithName("resume") as! Button
                let back = childNodeWithName("back") as! Button
                let gCenter = childNodeWithName("gCenter") as! Button
                if back.frame.contains(location) {
                    unPauseGame()
                    killGenerators()
                    returnToMenu()
                }
                if gCenter.frame.contains(location) {
                    openGameCenter()
                    gCenter.changeTexture(gcTexture1)
                    gCenter.isPressed = false
                    back.isPressed = false
                }
                if resume.isPressed && resume.frame.contains(location) {
                    unPauseGame()
                }
                else {
                    resume.isPressed = false
                    back.isPressed = false
                    gCenter.isPressed = false
                }
            }
        }
    }
    
    func returnToMenu() {
        type = 1
        NSNotificationCenter.defaultCenter().postNotificationName("gameSceneID", object: nil)
        /*
        inMenu = true
        inGame = false
        isStarted = false
        inGameOver = false
        inHighScore = false
        inHowTo = false
        inPause = false
        firstStart = true
        firstOpen = true
        removeAllChildren()
        mainSong.volume = 0.3
        println("\(mainSong.volume)")
        addMenu()
        */
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        
        let char = childNodeWithName("char") as? Char
        let wallGenerator = childNodeWithName("wallGenerator") as? WallGenerator
        let enemyGenerator = childNodeWithName("enemyGenerator") as? EnemyGenerator
        let birdGenerator = childNodeWithName("birdGenerator") as? BirdGenerator
        let coinGenerator = childNodeWithName("coinGenerator") as? CoinGenerator
        let powerUpGenerator = childNodeWithName("powerUpGenerator") as? PowerUpGenerator
        let slider = childNodeWithName("slider") as? Slider
        let bullet = childNodeWithName("stache") as? Bullet
        let powerUpArray = childNodeWithName("powerUpArray") as? PowerUpArray
        
        if highScores.count >= 5 {
            //println("    \(highScores[0])    \(highScores[1])    \(highScores[2])    \(highScores[3])    \(highScores[4]) ")
        }
        let bird = childNodeWithName("bird") as? Bird
        if bird != nil {
            bird!.update()
        }
        
        if setUpTimer < 200 {
            setUpTimer++
            if setUpTimer == 40 {
                setUpTimer = 1000
                killGenerators()
                println("\(mainSong.volume)")
                playSound(mainSong!)
                returnToMenu()
            }
        }
        if inMenu {
            let titleFace = childNodeWithName("titleface") as! SKSpriteNode
            let blink = titleFace.childNodeWithName("titleblink") as! Blink
            
            if timert < 80 {
                titleFace.position.y = titleFace.position.y + 0.1
                timert++
            }
            else {
                titleFace.position.y = titleFace.position.y - 0.1
                timert++
                if timert == 160 {
                    timert = 0
                }
            }
            
            blink.update()
            
        }
        
        if on {
            if(bullet != nil) {
                bullet!.update()
                
                if bullet!.position.x > screenSize.width + 30 || bullet!.position.y < -self.position.y - 30 {
                    bullet!.removeFromParent()
                    char!.timer4 = 40
                    runAction(recharge)
                }
            }
            
            char?.update()
            enemyGenerator?.update()
            birdGenerator?.update()
            wallGenerator?.update()
            coinGenerator?.update()
            slider?.update()
            powerUpGenerator?.update()
            
            let gunner = childNodeWithName("gunner") as? Gunner
            if gunner != nil {
                gunner!.update()
            }
        }
        
        if inGame {
            
            if songTimer < 20 {
                mainSong.volume = mainSong.volume * 0.94
                
                println("\(mainSong.volume)")
                songTimer++
            }
            
            if isStarted {
                
                if arrayTimer < 35 {
                    arrayTimer++
                    if arrayTimer == 34 {
                        let array = childNodeWithName("powerUpArray") as! PowerUpArray
                        if array.count == 0 {
                            array.alpha = 1.0
                            powerUp1.alpha = 1.0
                            powerUp2.alpha = 1.0
                            powerUp3.alpha = 1.0
                        }
                        arrayTimer = 1000
                    }
                }
                
                if bombTimer < 11 {
                    childNodeWithName("bomb")?.position.y -= 15.8
                    bombTimer++
                }
                else if bombTimer < 70 {
                    if bombTimer == 11 {
                        let bomb = childNodeWithName("bomb") as! SKSpriteNode
                        let pointAddition = PointAddition(num: 500, color: UIColor(red: 130/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1.0))
                        addChild(pointAddition)
                        pointAddition.zPosition = 199
                        let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                        pointsLabel.add(500)
                        runAction(explosionSound)
                        bomb.size.width *= 1.7
                        bomb.size.height *= 1.5
                        bomb.texture = explosionTexture
                    }
                    if bombTimer == 11 {
                        addWhite()
                    }
                    else if bombTimer < 16 {
                        let bomb = childNodeWithName("bomb") as? SKSpriteNode
                        bomb?.size.width *= 1.7
                        bomb?.size.height *= 1.5
                    }
                    if bombTimer == 14 {
                        explosion()
                    }
                    if bombTimer == 17 {
                        childNodeWithName("bomb")?.removeFromParent()
                    }
                    bombTimer++
                    
                    if bombTimer == 55 {
                        childNodeWithName("char")?.position.y = screenSize.height/2
                    }
                    if bombTimer == 65 {
                        bombTimer = 1000
                        let wallGenerator = childNodeWithName("wallGenerator") as! WallGenerator
                        let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
                        let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
                        let birdGenerator = childNodeWithName("birdGenerator") as! BirdGenerator
                        let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
                        let powerUpGenerator = childNodeWithName("powerUpGenerator") as! PowerUpGenerator
                        
                        wallGenerator.on = true
                        coinGenerator.on = true
                        enemyGenerator.on = true
                        birdGenerator.on = true
                        moneyGenerator?.on = true
                        powerUpGenerator.on = true
                    }
                }
                if difficulty < 1.7 {
                    difficulty = difficulty + 0.00012
                }
                else if difficulty < 2.1 {
                    difficulty = difficulty + 0.000092
                }
                else if difficulty < 2.3 {
                    difficulty = difficulty + 0.000003
                }
                
                if genCount == 0 && difficulty > 1.25 {
                    generateBird()
                    genCount = 1
                }
                if genCount == 1 && difficulty > 1.28 {
                    generatePowerUp()
                    genCount = 2
                }
                let difficultyLabel = childNodeWithName("difficultyLabel") as? PointsLabel
                if difficultyLabel != nil {
                    difficultyLabel!.text = "\(difficulty)"
                }
                println("difficulty: \(difficulty)")
                
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                pointsLabel.increment()
                
                let moneyGenerator = childNodeWithName("moneyGenerator") as? MoneyGenerator
                
                if moneyTimer < 130 {
                    moneyTimer++
                }
                else if moneyTimer == 250 {
                    moneyGenerator!.stopGenerating()
                    moneyTimer++
                }
                else if moneyTimer < 550 {
                    if moneyTimer == 450 {
                        char!.normal = true
                        char!.childNodeWithName("glasses")?.removeFromParent()
                        childNodeWithName("yellow")?.runAction(fadeOut())
                    }
                    if moneyTimer == 470 {
                        moneyTimer = 1000
                        childNodeWithName("yellow")?.removeFromParent()
                    }
                    moneyTimer++
                }
                
                if pointsLabel.getNum() > 1000000 {
                    pointsLabel.position.x = (screenSize.width/7) + 5 * CGFloat(6 * screenSize.width/568)
                    pointsLabel.childNodeWithName("scoretextlabel")?.position.x = -45 - 5 * CGFloat(6 * screenSize.width/568)
                }
                    
                else if pointsLabel.getNum() > 100000 {
                    pointsLabel.position.x = (screenSize.width/7) + 4 * CGFloat(6 * screenSize.width/568)
                    pointsLabel.childNodeWithName("scoretextlabel")?.position.x = -45 - 4 * CGFloat(6 * screenSize.width/568)
                }
                    
                else if pointsLabel.getNum() > 10000 {
                    pointsLabel.position.x = (screenSize.width/7) + 3 * CGFloat(6 * screenSize.width/568)
                    pointsLabel.childNodeWithName("scoretextlabel")?.position.x = -45 - 3 * CGFloat(6 * screenSize.width/568)
                }
                    
                else if pointsLabel.getNum() > 1000 {
                    pointsLabel.position.x = (screenSize.width/7) + 2 * CGFloat(6 * screenSize.width/568)
                    pointsLabel.childNodeWithName("scoretextlabel")?.position.x = -45 - 2 * CGFloat(6 * screenSize.width/568)
                }
                    
                else if pointsLabel.getNum() > 100 {
                    pointsLabel.position.x = (screenSize.width/7) + CGFloat(6 * screenSize.width/568)
                    pointsLabel.childNodeWithName("scoretextlabel")?.position.x = -45 - CGFloat(6 * screenSize.width/568)
                }
                
                func myObserverMethod(notification : NSNotification) {
                    println("Observer method called")
                    addPauseMenu()
                }
            }
            if pauseTimer < 1 {
                pauseTimer++
            }
            else if pauseTimer == 1 {
                //pauseGame()
            }
            
            if timer2 < 50 {
                timer2++
            }
            if timer2 == 50 {
                timer2++
                addTapToStartLabel()
            }
            
            /*
            if(slider!.isGrabbed == true) {
            var speed = (slider!.position.y - char!.position.y)/10
            
            if speed > 0.7 || speed < -0.7 {
            char!.notMoving = false
            if char!.currentState == Char.CharStates.Super {
            speed = speed * 8
            }
            char!.move(speed * 0.2 * (screenSize.height/320))
            }
            else {
            char!.notMoving = true
            }
            }
            char!.notMoving = true*/
            /*
            if wallGenerator!.wallTrackers.count > 0 {
            
            let wall = wallGenerator!.wallTrackers[0] as Wall
            
            let wallLocation = wallGenerator!.convertPoint(wall.position, toNode: self)
            if wallLocation.x < char!.position.x {
            wallGenerator!.wallTrackers.removeAtIndex(0)
            
            let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
            pointsLabel.add(250)
            
            
            }
            }
            
            if wallGenerator!.openWallTrackers.count > 0 {
            
            let openWall = wallGenerator!.openWallTrackers[0] as OpenWall
            
            let openWallLocation = wallGenerator!.convertPoint(openWall.position, toNode: self)
            if openWallLocation.x < char!.position.x {
            wallGenerator!.openWallTrackers.removeAtIndex(0)
            
            let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
            pointsLabel.add(250)
            
            
            }
            }*/
        }
        
        if timer3 < 50 {
            timer3++
        }
            
        else if timer3 == 50 {
            inGameOver = true
            timer3++
        }
        
    }
    
    // MARK: - SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        
        var x: CGFloat
        var y: CGFloat
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if inGame {
            switch(contactMask) {
                
            case BodyType.char.rawValue | BodyType.wall.rawValue :
                let char = childNodeWithName("char") as! Char
                if char.currentState == Char.CharStates.Big {
                    
                }
                else if char.growing {
                    
                }
                else if(char.currentState != Char.CharStates.Dead) && !char.isHurt {
                    heartCount = heartCount - 1
                    if heartCount != 0 {
                        addPointAdditionHeart(-1, color: UIColor(red: 200/255, green: 76/255, blue: 76/255, alpha: 1.0))
                    }
                    let heartLabel = mustacheIcon.childNodeWithName("heartLabel") as! PointsLabel
                    heartLabel.colon(heartCount)
                    if heartCount == 0 {
                        gameOver()
                    }
                    else {
                        let char = childNodeWithName("char") as! Char
                        char.hurt()
                    }
                }
                
            case BodyType.char.rawValue | BodyType.stacheBag.rawValue :
                var stacheBag: StacheBag!
                stacheBag = contact.bodyB.node as? StacheBag
                if stacheBag == nil {
                    stacheBag = contact.bodyA.node as? StacheBag
                }
                if stacheBag != nil {
                    if stacheBag!.on {
                        let mustacheLabel = mustacheIcon.childNodeWithName("mustacheLabel") as! PointsLabel
                        if stacheCount == 0 {
                            mustacheLabel.fontColor = UIColor.blackColor()
                        }
                        let num = 2 + Int(arc4random_uniform(3))
                        let diff = max - stacheCount
                        var display: Int!
                        if diff < num {
                            display = diff
                        }
                        else {
                            display = num
                        }
                        stacheCount = stacheCount + num
                        if stacheCount > max {
                            stacheCount = max
                        }
                        if stacheCount == max {
                            mustacheLabel.fontColor = UIColor(red: 3/255, green: 3/255, blue: 80/155, alpha: 1.0)
                        }
                        if stacheCount == 3 {
                            let char = childNodeWithName("char") as! Char
                            char.texture = mainCharTexture
                        }
                        mustacheLabel.colon(stacheCount)
                        if stacheCount < 10 {
                            mustacheLabel.position.x = screenSize.width/20
                        }
                        else if stacheCount < 100 {
                            mustacheLabel.position.x = screenSize.width/19.995
                        }
                        stacheBag!.on = false
                        addPointAdditionStache(display)
                    }
                    stacheBag!.removeFromParent()
                }
                
            case BodyType.char.rawValue | BodyType.heart.rawValue :
                var heart: Heart!
                heart = contact.bodyB.node as? Heart
                if heart == nil {
                    heart = contact.bodyA.node as? Heart
                }
                if heart != nil {
                    if heart!.on {
                        addPointAdditionHeart(1, color: UIColor(red: 200/255, green: 76/255, blue: 76/255, alpha: 1.0))
                        heartCount = heartCount + 1
                        let heartLabel = mustacheIcon.childNodeWithName("heartLabel") as! PointsLabel
                        heartLabel.colon(heartCount)
                        heart!.on = false
                    }
                    heart!.removeFromParent()
                }
                else {
                    var bomb: BirdBomb!
                    bomb = contact.bodyB.node as? BirdBomb
                    if bomb == nil {
                        bomb = contact.bodyA.node as? BirdBomb
                    }
                    if bomb != nil {
                        if bomb!.on {
                            addPointAdditionBomb(1)
                            bombCount = bombCount + 1
                            let bombLabel = mustacheIcon.childNodeWithName("bombLabel") as! PointsLabel
                            bombLabel.colon(bombCount)
                            bomb!.on = false
                        }
                        bomb!.removeFromParent()
                    }
                }
            case BodyType.bigarm.rawValue | BodyType.stacheBag.rawValue :
                var stacheBag: StacheBag!
                stacheBag = contact.bodyB.node as? StacheBag
                if stacheBag == nil {
                    stacheBag = contact.bodyA.node as? StacheBag
                }
                if stacheBag != nil {
                    if stacheBag!.on {
                        addPointAdditionStache(3)
                        stacheCount = stacheCount + 3
                        let mustacheLabel = mustacheIcon.childNodeWithName("mustacheLabel") as! PointsLabel
                        if stacheCount == 3 {
                            mustacheLabel.fontColor = UIColor.blackColor()
                        }
                        if stacheCount > max {
                            stacheCount = max
                        }
                        if stacheCount == max {
                            mustacheLabel.fontColor = UIColor(red: 3/255, green: 3/255, blue: 80/155, alpha: 1.0)
                        }
                        mustacheLabel.colon(stacheCount)
                        if stacheCount < 10 {
                            mustacheLabel.position.x = screenSize.width/20
                        }
                        else if stacheCount < 100 {
                            mustacheLabel.position.x = screenSize.width/19.995
                        }
                        stacheBag!.on = false
                    }
                    stacheBag!.removeFromParent()
                }
                
            case BodyType.bigarm.rawValue | BodyType.heart.rawValue :
                var heart: Heart!
                heart = contact.bodyB.node as? Heart
                if heart == nil {
                    heart = contact.bodyA.node as? Heart
                }
                if heart != nil {
                    if heart!.on {
                        addPointAdditionHeart(1, color: UIColor(red: 200/255, green: 76/255, blue: 76/255, alpha: 1.0))
                        heartCount = heartCount + 1
                        let heartLabel = mustacheIcon.childNodeWithName("heartLabel") as! PointsLabel
                        heartLabel.colon(heartCount)
                        heart!.on = false
                    }
                    heart!.removeFromParent()
                }
                
            case BodyType.char.rawValue | BodyType.beam.rawValue :
                var char = contact.bodyA.node as? Char
                if char == nil {
                    char = contact.bodyB.node as? Char
                }
                char?.greenExplode()
                
            case BodyType.char.rawValue | BodyType.wall2.rawValue :
                let char = childNodeWithName("char") as! Char
                if char.currentState == Char.CharStates.Big {
                    
                }
                else if char.growing {
                    
                }
                else if(char.currentState != Char.CharStates.Dead) && !char.isHurt {
                    heartCount = heartCount - 1
                    if heartCount != 0 {
                        addPointAdditionHeart(-1, color: UIColor(red: 200/255, green: 76/255, blue: 76/255, alpha: 1.0))
                    }
                    let heartLabel = mustacheIcon.childNodeWithName("heartLabel") as! PointsLabel
                    heartLabel.colon(heartCount)
                    if heartCount == 0 {
                        gameOver()
                    }
                    else {
                        let char = childNodeWithName("char") as! Char
                        char.hurt()
                    }
                }
                
            case BodyType.char.rawValue | BodyType.ceiling.rawValue :
                let char = childNodeWithName("char") as! Char
                if movingUp {
                    char.position.y = screenSize.height - 10
                    char.velY = 0
                    char.accelY = 0
                }
                else {
                    char.velY = 0
                    char.accelY = -charAccel
                }
                
            case BodyType.char.rawValue | BodyType.rotater.rawValue :
                let char = childNodeWithName("char") as! Char
                if char.currentState == Char.CharStates.Big {
                    
                }
                else if char.growing {
                    
                }
                else if char.currentState != Char.CharStates.Dead && !char.isHurt {
                    heartCount = heartCount - 1
                    if heartCount != 0 {
                        addPointAdditionHeart(-1, color: UIColor(red: 200/255, green: 76/255, blue: 76/255, alpha: 1.0))
                    }
                    let heartLabel = mustacheIcon.childNodeWithName("heartLabel") as! PointsLabel
                    heartLabel.colon(heartCount)
                    if heartCount == 0 {
                        gameOver()
                    }
                    else {
                        let char = childNodeWithName("char") as! Char
                        char.hurt()
                    }
                }
                
            case BodyType.char.rawValue | BodyType.rotateArms.rawValue :
                let char = childNodeWithName("char") as! Char
                if char.currentState == Char.CharStates.Big {
                    
                }
                else if char.growing {
                    
                }
                else if char.currentState != Char.CharStates.Dead && !char.isHurt {
                    heartCount = heartCount - 1
                    if heartCount != 0 {
                        addPointAdditionHeart(-1, color: UIColor(red: 200/255, green: 76/255, blue: 76/255, alpha: 1.0))
                    }
                    let heartLabel = mustacheIcon.childNodeWithName("heartLabel") as! PointsLabel
                    heartLabel.colon(heartCount)
                    if heartCount == 0 {
                        gameOver()
                    }
                    else {
                        let char = childNodeWithName("char") as! Char
                        char.hurt()
                    }
                }
                
            case BodyType.char.rawValue | BodyType.enemy.rawValue :
                let char = childNodeWithName("char") as! Char
                if char.currentState == Char.CharStates.Big {
                    
                }
                else if char.growing {
                    
                }
                else if char.currentState != Char.CharStates.Dead && !char.isHurt {
                    heartCount = heartCount - 1
                    if heartCount != 0 {
                        addPointAdditionHeart(-1, color: UIColor(red: 200/255, green: 76/255, blue: 76/255, alpha: 1.0))
                    }
                    let heartLabel = mustacheIcon.childNodeWithName("heartLabel") as! PointsLabel
                    heartLabel.colon(heartCount)
                    if heartCount == 0 {
                        gameOver()
                    }
                    else {
                        let char = childNodeWithName("char") as! Char
                        char.hurt()
                    }
                }
                
            case BodyType.char.rawValue | BodyType.coin.rawValue :
                let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
                let char = childNodeWithName("char") as! Char
                let coin = contact.bodyB.node as! Coin
                x = char.position.x
                y = char.position.y
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                if coin.active {
                    coin.active = false
                    let val = coin.getValue()
                    coin.removeFromParent()
                    pointsLabel.add(val)
                    if val == 100 {
                        addPointAddition(val, color: UIColor(red: 155/255.0, green: 95/255.0, blue: 41/255.0, alpha: 1.0))
                    }
                    else if val == 300 {
                        addPointAddition(val, color: UIColor(red: 107/255.0, green: 104/255.0, blue: 101/255.0, alpha: 1.0))
                    }
                    else if val == 1000 {
                        addPointAddition(val, color: UIColor(red: 235/255.0, green: 237/255.0, blue: 95/255.0, alpha: 1.0))
                    }
                    else {
                        addPointAddition(val, color: UIColor(red: 121/255.0, green: 123/255.0, blue: 32/255.0, alpha: 1.0))
                    }
                    char.position.x = x
                    char.position.y = y
                    runAction(coinSound)
                }
                
            case BodyType.char.rawValue | BodyType.powerup.rawValue :
                let powerUp = contact.bodyB.node as! PowerUp
                let char = childNodeWithName("char") as! Char
                let powerUpArray = childNodeWithName("powerUpArray") as! PowerUpArray
                if powerUp.live {
                    powerUp.live = false
                    
                    let type = powerUp.getType()
                    powerUp.removeFromParent()
                    
                    if powerUp1Pressed {
                        powerUp1Pressed = false
                        powerUp1.changeSize(0.909, h: 0.909)
                    }
                    
                    if powerUp2Pressed {
                        powerUp2Pressed = false
                        powerUp2.changeSize(0.909, h: 0.909)
                    }
                    
                    if powerUp3Pressed {
                        powerUp3Pressed = false
                        powerUp3.changeSize(0.909, h: 0.909)
                    }
                    
                    if type == 1 {
                        powerUpArray.addPowerUp(moneyTokenTexture1G)
                    }
                        
                    else if type == 2 {
                        powerUpArray.addPowerUp(muscleTokenTexture1)
                    }
                        
                    else if type == 3 {
                        powerUpArray.addPowerUp(miniTokenTexture1)
                    }
                        
                    else if type == 4 {
                        powerUpArray.addPowerUp(shooterTokenTexture1)
                    }
                        
                    else if type == 5 {
                        powerUpArray.addPowerUp(superTokenTexture1)
                    }
                    
                    if powerUp1Pressed {
                        powerUp1Pressed = false
                        powerUp1.changeSize(0.909, h: 0.909)
                    }
                    
                    runAction(powerUpSound)
                }
                
            case BodyType.bullet.rawValue | BodyType.enemy.rawValue :
                let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
                let char = childNodeWithName("char") as! Char
                var enemy = contact.bodyB.node as? Enemy
                var bullet = contact.bodyA.node as? Bullet
                if enemy == nil {
                    enemy = contact.bodyA.node as? Enemy
                    bullet = contact.bodyB.node as? Bullet
                }
                if bullet != nil {
                    if bullet!.active {
                        
                        let array = childNodeWithName("powerUpArray") as! PowerUpArray
                        if enemy!.inside {
                            array.count = array.count - 1
                            
                        }
                        if bullet!.inside {
                            array.count = array.count - 1
                        }
                        if array.count == 0 {
                            arrayTimer = 0
                        }
                        
                        bullet!.active = false
                        enemy?.addStache()
                        //enemyGenerator.findEnemy(x, y: y).addStache()
                        bullet?.removeFromParent()
                        char.timer4 = 40
                        //runAction(recharge)
                    }
                }
                else {
                    enemy?.addStache()
                }
                
            case BodyType.bullet.rawValue | BodyType.rotater.rawValue :
                let enemyGenerator = childNodeWithName("enemyGenerator") as! EnemyGenerator
                let char = childNodeWithName("char") as! Char
                var rotater = contact.bodyB.node as? Rotater
                var bullet = contact.bodyA.node as? Bullet
                if rotater == nil {
                    rotater = contact.bodyA.node as? Rotater
                    bullet = contact.bodyB.node as? Bullet
                }
                if bullet != nil {
                    if bullet!.active {
                        
                        let array = childNodeWithName("powerUpArray") as! PowerUpArray
                        if rotater!.inside {
                            array.count = array.count - 1
                        }
                        if bullet!.inside {
                            array.count = array.count - 1
                        }
                        if array.count == 0 {
                            arrayTimer = 0
                        }
                        bullet!.active = false
                        rotater?.addStache()
                        bullet!.removeFromParent()
                        char.timer4 = 40
                    }
                }
                else {
                    rotater?.addStache()
                }
                
            case BodyType.bullet.rawValue | BodyType.rotateArms.rawValue :
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                pointsLabel.add(100)
                addPointAddition(100, color: UIColor(red: 80/255.0, green: 138/255.0, blue: 93/255.0, alpha: 1.0))
                let char = childNodeWithName("char") as! Char
                var bullet = contact.bodyA.node as? Bullet
                var rotater = contact.bodyB.node!.parent! as? Rotater
                if rotater == nil {
                    rotater = contact.bodyA.node!.parent! as? Rotater
                    bullet = contact.bodyB.node as? Bullet
                }
                if bullet != nil {
                    if bullet!.active {
                        bullet!.active = false
                        rotater?.hit1()
                        bullet!.removeFromParent()
                        char.timer4 = 40
                    }
                }
                else {
                    rotater?.hit1()
                }
                
            case BodyType.bullet.rawValue | BodyType.wall2.rawValue :
                let char = childNodeWithName("char") as! Char
                var bullet = contact.bodyA.node as? SKSpriteNode
                var wall = contact.bodyB.node! as? Wall
                if wall == nil {
                    wall = contact.bodyA.node! as? Wall
                    bullet = contact.bodyB.node as? SKSpriteNode
                }
                
                let array = childNodeWithName("powerUpArray") as! PowerUpArray
                if wall!.inside {
                    array.count = array.count - 1
                    if array.count == 0 {
                        arrayTimer = 15
                    }
                }
                
                y = bullet!.position.y
                let y2 = bullet!.position.y - char.position.y
                runAction(crack)
                wall!.direc = bullet!.position.y - char.position.y
                wall!.timer = 0
                wall!.split = y
                wall!.relativeLocation = y2
                wall!.physicsBody?.categoryBitMask = 0
                wall!.physicsBody?.collisionBitMask = 0
                wall!.physicsBody?.contactTestBitMask = 0
                
                
            case BodyType.sup.rawValue | BodyType.coin.rawValue :
                let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
                let char = childNodeWithName("char") as! Char
                let coin = contact.bodyB.node as! Coin
                x = char.position.x
                y = char.position.y
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                if coin.active {
                    coin.active = false
                    let val = coin.getValue()
                    coin.removeFromParent()
                    pointsLabel.add(val)
                    if val == 100 {
                        addPointAddition(val, color: UIColor(red: 25/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0))
                    }
                    else if val == 300 {
                        addPointAddition(val, color: UIColor(red: 25/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0))
                    }
                    else if val == 1000 {
                        addPointAddition(val, color: UIColor(red: 25/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0))
                    }
                    else {
                        addPointAddition(val, color: UIColor(red: 25/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0))
                    }
                    char.position.x = x
                    char.position.y = y
                    runAction(coinSound)
                }
                
            case BodyType.sup.rawValue | BodyType.wall.rawValue :
                let wall1 = contact.bodyB.node as? OpenWall
                let wall2 = contact.bodyA.node as? OpenWall
                let wall3 = contact.bodyB.node as? TopWall
                let wall4 = contact.bodyA.node as? TopWall
                
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                pointsLabel.add(100)
                addPointAddition(100, color: UIColor(red: 25/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0))
                
                if wall1 != nil {
                    wall1!.removeAllActions()
                    if wall1!.position.y >= screenSize.height/2 {
                        wall1!.physicsBody!.applyImpulse(CGVectorMake(12 + CGFloat(arc4random_uniform(3)), 3 + CGFloat(arc4random_uniform(2))))
                        wall1!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 6, duration: 0))
                    }
                    else {
                        wall1!.physicsBody!.applyImpulse(CGVectorMake(12 + CGFloat(arc4random_uniform(3)), -( 3 + CGFloat(arc4random_uniform(2)))))
                        wall1!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -6, duration: 0))
                    }
                }
                
                if wall2 != nil {
                    wall2!.removeAllActions()
                    if wall2!.position.y >= screenSize.height/2 {
                        wall2!.physicsBody!.applyImpulse(CGVectorMake(12 + CGFloat(arc4random_uniform(3)), 3 + CGFloat(arc4random_uniform(2))))
                        wall2!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 6, duration: 0))
                    }
                    else {
                        wall2!.physicsBody!.applyImpulse(CGVectorMake(12 + CGFloat(arc4random_uniform(3)), -( 3 + CGFloat(arc4random_uniform(2)))))
                        wall2!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -6, duration: 0))
                    }
                }
                
                if wall3 != nil {
                    wall3!.removeAllActions()
                    if wall3!.position.y >= screenSize.height/2 {
                        wall3!.physicsBody!.applyImpulse(CGVectorMake(8 + CGFloat(arc4random_uniform(3)), 5 + CGFloat(arc4random_uniform(2))))
                        wall3!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 6, duration: 0))
                    }
                    else {
                        wall3!.physicsBody!.applyImpulse(CGVectorMake(8 + CGFloat(arc4random_uniform(3)), -( 5 + CGFloat(arc4random_uniform(2)))))
                        wall3!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -6, duration: 0))
                    }
                }
                
                if wall4 != nil {
                    wall4!.removeAllActions()
                    if wall4!.position.y >= screenSize.height/2 {
                        wall4!.physicsBody!.applyImpulse(CGVectorMake(12 + CGFloat(arc4random_uniform(3)), 3 + CGFloat(arc4random_uniform(2))))
                        wall4!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 6, duration: 0))
                    }
                    else {
                        wall4!.physicsBody!.applyImpulse(CGVectorMake(12 + CGFloat(arc4random_uniform(3)), -( 3 + CGFloat(arc4random_uniform(2)))))
                        wall4!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -6, duration: 0))
                    }
                }
                
            case BodyType.sup.rawValue | BodyType.wall2.rawValue :
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                pointsLabel.add(100)
                addPointAddition(100, color: UIColor(red: 25/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0))
                var wall = contact.bodyB.node as? Wall
                if wall == nil {
                    wall = contact.bodyA.node as? Wall
                }
                wall!.stopMoving()
                if wall!.position.y >= screenSize.height/2 {
                    wall!.physicsBody!.applyImpulse(CGVectorMake(12 + CGFloat(arc4random_uniform(3)), 3 + CGFloat(arc4random_uniform(2))))
                    wall!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 6, duration: 0))
                }
                else {
                    wall!.physicsBody!.applyImpulse(CGVectorMake(12 + CGFloat(arc4random_uniform(3)), -( 3 + CGFloat(arc4random_uniform(2)))))
                    wall!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -6, duration: 0))
                }
                wall!.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.removeFromParent()]))
                
            case BodyType.sup.rawValue | BodyType.enemy.rawValue :
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                pointsLabel.add(100)
                addPointAddition(100, color: UIColor(red: 25/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0))
                var enemy = contact.bodyB.node as? Enemy
                if enemy == nil {
                    enemy = contact.bodyA.node as? Enemy
                }
                enemy!.stopMoving()
                if enemy!.position.y >= screenSize.height/2 {
                    enemy!.physicsBody!.applyImpulse(CGVectorMake(12 + CGFloat(arc4random_uniform(3)), 3 + CGFloat(arc4random_uniform(2))))
                    enemy!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -0.2, duration: 2))
                }
                else {
                    enemy!.physicsBody!.applyImpulse(CGVectorMake(12 + CGFloat(arc4random_uniform(3)), -( 3 + CGFloat(arc4random_uniform(2)))))
                    enemy!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 0.2, duration: 2))
                }
                enemy!.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.removeFromParent()]))
                
            case BodyType.sup.rawValue | BodyType.rotater.rawValue :
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                pointsLabel.add(200)
                addPointAddition(200, color: UIColor(red: 25/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0))
                var rotater = contact.bodyB.node as? Rotater
                if rotater == nil {
                    rotater = contact.bodyA.node as? Rotater
                }
                rotater!.stopMoving()
                if rotater!.position.y >= screenSize.height/2 {
                    rotater!.physicsBody!.applyImpulse(CGVectorMake(50 + CGFloat(arc4random_uniform(3)), 16 + CGFloat(arc4random_uniform(2))))
                    rotater!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 0.2, duration: 2))
                }
                else {
                    rotater!.physicsBody!.applyImpulse(CGVectorMake(50 + CGFloat(arc4random_uniform(3)), -( 16 + CGFloat(arc4random_uniform(2)))))
                    rotater!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -0.2, duration: 2))
                }
                rotater!.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.removeFromParent()]))
                
            case BodyType.sup.rawValue | BodyType.rotateArms.rawValue :
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                pointsLabel.add(200)
                addPointAddition(200, color: UIColor(red: 25/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0))
                var rotater = contact.bodyB.node?.parent as? Rotater
                if rotater == nil {
                    rotater = contact.bodyA.node?.parent as? Rotater
                }
                
                if rotater!.position.y >= screenSize.height/2 {
                    rotater!.physicsBody!.applyImpulse(CGVectorMake(50 + CGFloat(arc4random_uniform(3)), 16 + CGFloat(arc4random_uniform(2))))
                    rotater!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 0.2, duration: 2))
                }
                else {
                    rotater!.physicsBody!.applyImpulse(CGVectorMake(50 + CGFloat(arc4random_uniform(3)), -( 16 + CGFloat(arc4random_uniform(2)))))
                    rotater!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -0.2, duration: 2))
                }
                rotater!.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.removeFromParent()]))
                
            case BodyType.sup.rawValue | BodyType.beam.rawValue :
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                pointsLabel.add(500)
                addPointAddition(200, color: UIColor(red: 25/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0))
                var gunner = contact.bodyB.node!.parent as? Gunner
                if gunner == nil {
                    gunner = contact.bodyA.node!.parent as? Gunner
                }
                gunner!.stopMoving()
                if gunner!.position.y >= screenSize.height/2 {
                    gunner!.runAction(SKAction.moveByX(-110, y: 20, duration: 0.5))
                    gunner!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 6, duration: 0))
                }
                else {
                    gunner!.runAction(SKAction.moveByX(500, y: -20, duration: 2))
                    gunner!.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -6, duration: 0))
                }
                gunner?.death()
                gunner?.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.removeFromParent()]))
                
            case BodyType.bigarm.rawValue | BodyType.coin.rawValue :
                let coinGenerator = childNodeWithName("coinGenerator") as! CoinGenerator
                let char = childNodeWithName("char") as! Char
                let coin = contact.bodyB.node as! Coin
                x = char.position.x
                y = char.position.y
                let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                if coin.active {
                    coin.active = false
                    let val = coin.getValue()
                    coin.removeFromParent()
                    pointsLabel.add(val)
                    if val == 100 {
                        addPointAddition(val, color: UIColor(red: 155/255.0, green: 95/255.0, blue: 41/255.0, alpha: 1.0))
                    }
                    else if val == 300 {
                        addPointAddition(val, color: UIColor(red: 107/255.0, green: 104/255.0, blue: 101/255.0, alpha: 1.0))
                    }
                    else if val == 1000 {
                        addPointAddition(val, color: UIColor(red: 235/255.0, green: 237/255.0, blue: 95/255.0, alpha: 1.0))
                    }
                    else {
                        addPointAddition(val, color: UIColor(red: 121/255.0, green: 123/255.0, blue: 32/255.0, alpha: 1.0))
                    }
                    char.position.x = x
                    char.position.y = y
                    runAction(coinSound)
                }
                
            case BodyType.bigarm.rawValue | BodyType.wall.rawValue :
                let char = childNodeWithName("char") as! Char
                if char.hitting {
                    let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                    pointsLabel.add(200)
                    addPointAddition(200, color: UIColor(red: 130/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1.0))
                    let wa = contact.bodyB.node as? OpenWall
                    let wa2 = contact.bodyA.node as? OpenWall
                    let wa3 = contact.bodyA.node as? TopWall
                    let wa4 = contact.bodyB.node as? TopWall
                    
                    if wa != nil {
                        wa!.physicsBody?.applyImpulse(CGVectorMake(15 + CGFloat(arc4random_uniform(6)), CGFloat(arc4random_uniform(3))))
                        wa!.physicsBody?.affectedByGravity = true
                    }
                    else if wa2 != nil {
                        wa2!.physicsBody?.applyImpulse(CGVectorMake(15 + CGFloat(arc4random_uniform(6)), CGFloat(arc4random_uniform(3))))
                        wa2!.physicsBody?.affectedByGravity = true
                    }
                    else if wa3 != nil {
                        wa3!.physicsBody?.applyImpulse(CGVectorMake(15 + CGFloat(arc4random_uniform(6)), CGFloat(arc4random_uniform(3))))
                        wa3!.physicsBody?.affectedByGravity = true
                    }
                    else if wa4 != nil {
                        wa4!.physicsBody?.applyImpulse(CGVectorMake(15 + CGFloat(arc4random_uniform(6)), CGFloat(arc4random_uniform(3))))
                        wa4!.physicsBody?.affectedByGravity = true
                    }
                }
                else if char.growing {
                    
                }
                else {
                    char.shrink()
                    char.hurt()
                }
                
            case BodyType.bigarm.rawValue | BodyType.wall2.rawValue :
                let char = childNodeWithName("char") as! Char
                if char.hitting {
                    let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                    pointsLabel.add(200)
                    addPointAddition(200, color: UIColor(red: 130/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1.0))
                    var wa = contact.bodyB.node as? Wall
                    if wa == nil {
                        wa = contact.bodyA.node as? Wall
                    }
                    wa!.physicsBody?.applyImpulse(CGVectorMake(15 + CGFloat(arc4random_uniform(6)), CGFloat(arc4random_uniform(3))))
                    wa!.physicsBody?.affectedByGravity = true
                }
                else if char.growing {
                    
                }
                else {
                    char.shrink()
                    char.hurt()
                }
                
            case BodyType.bigarm.rawValue | BodyType.beam.rawValue :
                let char = childNodeWithName("char") as! Char
                if char.growing {
                    
                }
                else {
                    char.shrink()
                    char.hurt()
                }
                
            case BodyType.bigarm.rawValue | BodyType.enemy.rawValue :
                let char = childNodeWithName("char") as! Char
                if char.hitting {
                    let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                    pointsLabel.add(200)
                    addPointAddition(200, color: UIColor(red: 130/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1.0))
                    var en = contact.bodyB.node as? Enemy
                    if en == nil {
                        en = contact.bodyA.node as? Enemy
                    }
                    en!.physicsBody?.affectedByGravity = true
                    en!.physicsBody?.applyImpulse(CGVectorMake(15 + CGFloat(arc4random_uniform(6)), CGFloat(arc4random_uniform(3))))
                }
                else if char.growing {
                    
                }
                else {
                    char.shrink()
                    char.hurt()
                }
                
            case BodyType.bigarm.rawValue | BodyType.rotateArms.rawValue :
                let char = childNodeWithName("char") as! Char
                if char.hitting {
                    let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                    pointsLabel.add(200)
                    addPointAddition(200, color: UIColor(red: 130/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1.0))
                    var en = contact.bodyB.node as? SKSpriteNode
                    if en == nil {
                        en = contact.bodyA.node as? SKSpriteNode
                    }
                    en!.physicsBody?.affectedByGravity = true
                    en!.physicsBody?.applyImpulse(CGVectorMake(15 + CGFloat(arc4random_uniform(6)), CGFloat(arc4random_uniform(3))))
                }
                else if char.growing {
                    
                }
                else {
                    char.shrink()
                    char.hurt()
                }
                
            case BodyType.bigarm.rawValue | BodyType.rotater.rawValue :
                let char = childNodeWithName("char") as! Char
                if char.hitting {
                    let pointsLabel = childNodeWithName("pointsLabel") as! PointsLabel
                    pointsLabel.add(200)
                    addPointAddition(200, color: UIColor(red: 130/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1.0))
                    var en = contact.bodyB.node as? Rotater
                    if en == nil {
                        en = contact.bodyA.node as? Rotater
                    }
                    en!.physicsBody?.affectedByGravity = true
                    en!.physicsBody?.applyImpulse(CGVectorMake(15 + CGFloat(arc4random_uniform(6)), CGFloat(arc4random_uniform(3))))
                }
                else if char.growing {
                    
                }
                else {
                    char.shrink()
                    char.hurt()
                }
                
            case BodyType.array.rawValue | BodyType.enemy.rawValue :
                var array = contact.bodyA.node as? PowerUpArray
                var enemy = contact.bodyB.node as? Enemy
                if array == nil {
                    array = contact.bodyB.node as? PowerUpArray
                    enemy = contact.bodyA.node as? Enemy
                }
                enemy!.inside = true
                array!.alpha = 0.6
                array!.count = array!.count + 1
                powerUp1.alpha = 0.6
                powerUp2.alpha = 0.6
                powerUp3.alpha = 0.6
                
            case BodyType.array.rawValue | BodyType.rotater.rawValue :
                var array = contact.bodyA.node as? PowerUpArray
                var rotater = contact.bodyB.node as? Rotater
                if array == nil {
                    array = contact.bodyB.node as? PowerUpArray
                    rotater = contact.bodyA.node as? Rotater
                }
                rotater!.inside = true
                array!.alpha = 0.6
                array!.count = array!.count + 1
                powerUp1.alpha = 0.6
                powerUp2.alpha = 0.6
                powerUp3.alpha = 0.6
                
            case BodyType.array.rawValue | BodyType.wall.rawValue :
                var array = contact.bodyA.node as? PowerUpArray
                var wall1 = contact.bodyB.node as? OpenWall
                var wall2 = contact.bodyA.node as? OpenWall
                var wall3 = contact.bodyA.node as? TopWall
                var wall4 = contact.bodyA.node as? TopWall
                if array == nil {
                    array = contact.bodyB.node as? PowerUpArray
                }
                if wall1 != nil {
                    wall1?.inside = true
                }
                if wall2 != nil {
                    wall2?.inside = true
                }
                if wall3 != nil {
                    wall3?.inside = true
                }
                if wall4 != nil {
                    wall4?.inside = true
                }
                array!.alpha = 0.6
                array!.count = array!.count + 1
                powerUp1.alpha = 0.6
                powerUp2.alpha = 0.6
                powerUp3.alpha = 0.6
                
            case BodyType.array.rawValue | BodyType.wall2.rawValue :
                var array = contact.bodyA.node as? PowerUpArray
                var wall = contact.bodyB.node as? Wall
                if array == nil {
                    array = contact.bodyB.node as? PowerUpArray
                    wall = contact.bodyA.node as? Wall
                }
                wall!.inside = true
                array!.alpha = 0.6
                array!.count = array!.count + 1
                powerUp1.alpha = 0.6
                powerUp2.alpha = 0.6
                powerUp3.alpha = 0.6
                
            case BodyType.array.rawValue | BodyType.powerup.rawValue :
                var array = contact.bodyA.node as? PowerUpArray
                if array == nil {
                    array = contact.bodyB.node as? PowerUpArray
                }
                array!.alpha = 0.6
                array!.count = array!.count + 1
                powerUp1.alpha = 0.6
                powerUp2.alpha = 0.6
                powerUp3.alpha = 0.6
                
            case BodyType.array.rawValue | BodyType.coin.rawValue :
                var array = contact.bodyA.node as? PowerUpArray
                if array == nil {
                    array = contact.bodyB.node as? PowerUpArray
                }
                array!.alpha = 0.6
                array!.count = array!.count + 1
                powerUp1.alpha = 0.6
                powerUp2.alpha = 0.6
                powerUp3.alpha = 0.6
                
            case BodyType.array.rawValue | BodyType.bullet.rawValue :
                var array = contact.bodyA.node as? PowerUpArray
                var bullet = contact.bodyB.node as? Bullet
                if array == nil {
                    array = contact.bodyB.node as? PowerUpArray
                    bullet = contact.bodyA.node as? Bullet
                }
                bullet?.inside = true
                array!.alpha = 0.6
                array!.count = array!.count + 1
                powerUp1.alpha = 0.6
                powerUp2.alpha = 0.6
                powerUp3.alpha = 0.6
                
            case BodyType.array.rawValue | BodyType.powerup.rawValue :
                var array = contact.bodyA.node as? PowerUpArray
                if array == nil {
                    array = contact.bodyB.node as? PowerUpArray
                }
                array!.alpha = 0.6
                array!.count = array!.count + 1
                powerUp1.alpha = 0.6
                powerUp2.alpha = 0.6
                powerUp3.alpha = 0.6
                
            case BodyType.array.rawValue | BodyType.stacheBag.rawValue :
                var array = contact.bodyA.node as? PowerUpArray
                if array == nil {
                    array = contact.bodyB.node as? PowerUpArray
                }
                array!.alpha = 0.7
                array!.count = array!.count + 1
                powerUp1.alpha = 0.7
                powerUp2.alpha = 0.7
                powerUp3.alpha = 0.7
                
            case BodyType.array.rawValue | BodyType.heart.rawValue :
                var array = contact.bodyA.node as? PowerUpArray
                if array == nil {
                    array = contact.bodyB.node as? PowerUpArray
                }
                array!.alpha = 0.6
                array!.count = array!.count + 1
                powerUp1.alpha = 0.6
                powerUp2.alpha = 0.6
                powerUp3.alpha = 0.6
                
            default:
                return
                
            }
        }
    }
    
    
    func didEndContact(contact: SKPhysicsContact) {
        var x: CGFloat
        var y: CGFloat
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
            
        case BodyType.array.rawValue | BodyType.enemy.rawValue :
            var array = contact.bodyA.node as? PowerUpArray
            var enemy = contact.bodyB.node as? Enemy
            if array == nil {
                array = contact.bodyB.node as? PowerUpArray
                enemy = contact.bodyA.node as? Enemy
            }
            enemy!.inside = false
            array!.count = array!.count - 1
            if array!.count == 0 {
                array!.alpha = 1.0
                powerUp1.alpha = 1.0
                powerUp2.alpha = 1.0
                powerUp3.alpha = 1.0
            }
            
        case BodyType.array.rawValue | BodyType.rotater.rawValue :
            var array = contact.bodyA.node as? PowerUpArray
            var rotater = contact.bodyB.node as? Rotater
            if array == nil {
                array = contact.bodyB.node as? PowerUpArray
                rotater = contact.bodyA.node as? Rotater
            }
            rotater!.inside = false
            array!.count = array!.count - 1
            if array!.count == 0 {
                array!.alpha = 1.0
                powerUp1.alpha = 1.0
                powerUp2.alpha = 1.0
                powerUp3.alpha = 1.0
            }
            
        case BodyType.array.rawValue | BodyType.wall.rawValue :
            var array = contact.bodyA.node as? PowerUpArray
            var wall1 = contact.bodyB.node as? OpenWall
            var wall2 = contact.bodyA.node as? OpenWall
            var wall3 = contact.bodyA.node as? TopWall
            var wall4 = contact.bodyA.node as? TopWall
            if array == nil {
                array = contact.bodyB.node as? PowerUpArray
            }
            if wall1 != nil {
                wall1?.inside = false
            }
            if wall2 != nil {
                wall2?.inside = false
            }
            if wall3 != nil {
                wall3?.inside = false
            }
            if wall4 != nil {
                wall4?.inside = false
            }
            array!.count = array!.count - 1
            if array!.count == 0 {
                array!.alpha = 1.0
                powerUp1.alpha = 1.0
                powerUp2.alpha = 1.0
                powerUp3.alpha = 1.0
            }
            
        case BodyType.array.rawValue | BodyType.wall2.rawValue :
            var array = contact.bodyA.node as? PowerUpArray
            var wall = contact.bodyB.node as? Wall
            if array == nil {
                array = contact.bodyB.node as? PowerUpArray
                wall = contact.bodyA.node as? Wall
            }
            wall!.inside = false
            array!.count = array!.count - 1
            if array!.count == 0 {
                array!.alpha = 1.0
                powerUp1.alpha = 1.0
                powerUp2.alpha = 1.0
                powerUp3.alpha = 1.0
            }
            
        case BodyType.array.rawValue | BodyType.powerup.rawValue :
            var array = contact.bodyA.node as? PowerUpArray
            if array == nil {
                array = contact.bodyB.node as? PowerUpArray
            }
            array!.count = array!.count - 1
            if array!.count == 0 {
                array!.alpha = 1.0
                powerUp1.alpha = 1.0
                powerUp2.alpha = 1.0
                powerUp3.alpha = 1.0
            }
            
        case BodyType.array.rawValue | BodyType.coin.rawValue :
            var array = contact.bodyA.node as? PowerUpArray
            if array == nil {
                array = contact.bodyB.node as? PowerUpArray
            }
            array!.count = array!.count - 1
            if array!.count == 0 {
                array!.alpha = 1.0
                powerUp1.alpha = 1.0
                powerUp2.alpha = 1.0
                powerUp3.alpha = 1.0
            }
            
        case BodyType.array.rawValue | BodyType.bullet.rawValue :
            var array = contact.bodyA.node as? PowerUpArray
            var bullet = contact.bodyB.node as? Bullet
            if array == nil {
                array = contact.bodyB.node as? PowerUpArray
                bullet = contact.bodyA.node as? Bullet
            }
            bullet?.inside = false
            array!.count = array!.count - 1
            if array!.count == 0 {
                array!.alpha = 1.0
                powerUp1.alpha = 1.0
                powerUp2.alpha = 1.0
                powerUp3.alpha = 1.0
            }
            
        case BodyType.array.rawValue | BodyType.powerup.rawValue :
            var array = contact.bodyA.node as? PowerUpArray
            if array == nil {
                array = contact.bodyB.node as? PowerUpArray
            }
            array!.count = array!.count - 1
            if array!.count == 0 {
                array!.alpha = 1.0
                powerUp1.alpha = 1.0
                powerUp2.alpha = 1.0
                powerUp3.alpha = 1.0
            }
            
        case BodyType.array.rawValue | BodyType.stacheBag.rawValue :
            var array = contact.bodyA.node as? PowerUpArray
            if array == nil {
                array = contact.bodyB.node as? PowerUpArray
            }
            array!.alpha = 0.7
            array!.count = array!.count + 1
            powerUp1.alpha = 0.7
            powerUp2.alpha = 0.7
            powerUp3.alpha = 0.7
            
        case BodyType.array.rawValue | BodyType.heart.rawValue :
            var array = contact.bodyA.node as? PowerUpArray
            if array == nil {
                array = contact.bodyB.node as? PowerUpArray
            }
            array!.alpha = 0.7
            array!.count = array!.count + 1
            powerUp1.alpha = 0.7
            powerUp2.alpha = 0.7
            powerUp3.alpha = 0.7
            
        default:
            return
        }
    }
    
    // MARK: - Animations
    func blinkAnimation() -> SKAction {
        let duration = 0.4
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: duration)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatActionForever(blink)
    }
    
    func blinkAnimation2() -> SKAction {
        let duration = 0.4
        let fadeOut = SKAction.fadeAlphaTo(0.15, duration: duration)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatActionForever(blink)
    }
    
    func fadeIn() -> SKAction {
        let duration = 0.6
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.0)
        let fadeOut2 = SKAction.fadeAlphaTo(0.0, duration: 0.7)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
        return SKAction.sequence([fadeOut, fadeOut2, fadeIn])
    }
    func fadeIn2() -> SKAction {
        let duration = 0.6
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.0)
        let fadeIn = SKAction.fadeAlphaTo(0.15, duration: duration)
        return SKAction.sequence([fadeOut, fadeIn])
    }
    func fadeOut() -> SKAction {
        let duration = 0.6
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        return fadeOut
    }
    
}
