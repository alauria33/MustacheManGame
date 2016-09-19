//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Char: SKSpriteNode {
    
    var timer = 0, timer2 = 0, timer3 = 100, timer4 = 0, timer6 = 0, timer7 = 0, timer8 = 0,
                growthTimer = 1000, growthTimer2 = 1000, shrinkTimer = 1000, superTimer = 1000, sadTimer = 1000, shooterTimer = 1000, hurtTimer = 1000, greenTimer = 1000, goTimer = 1000
    var bullet: Bullet!
    var cape: Cape!
    var arm: Arm!
    var sup: Super!
    var stache: SKSpriteNode!
    var blink: SKSpriteNode!
    var leftArm: SKSpriteNode!
    var rightArm: SKSpriteNode!
    var block: SKSpriteNode!
    var timerColor: SKSpriteNode!
    var timerSize: CGFloat!
    var tempPhysics: SKPhysicsBody!
    var notMoving = true
    var justMovedUp = true
    var justMovedDown = false
    var canShoot = false
    var canHold = true
    var canPrep = false
    var canHit = false
    var hitting = false
    var isHolding = false
    var growing = false
    var shrinking = false
    var shrunk = false
    var on = true
    var fallD = false
    var moveUpLater = false
    var normal = true
    var isHurt = false
    var shotGenerator: NSTimer!
    var tempDiff: CGFloat!
    
    var bullets = [Bullet2]()
    
    var velY: CGFloat = 0
    var accelY: CGFloat = 0
    
    var velY2: CGFloat = 0
    var accelY2: CGFloat = 0
    var locationY: CGFloat = 0
    
    enum CharStates: Int {
        
        case Idle, Falling, Hurt, Fire, Moving, Dead, Shooting, Flying, Super, Touch, Big, Small, Shooter

    }
    
    var currentState = CharStates.Idle
    
    init () {

        super.init(texture: charIdleTexture, color: nil, size: charIdleTexture.size())
        self.zPosition = 30
        //changeSize(0.18, h: 0.18)
        changeSize(0.36 * screenSize.width/667, h: 0.36 * screenSize.height/375)//0.125 * 0.9 * 1.6, h: 0.125 * 0.9 * 1.6)
        setPhysicsBody(charIdleTexture, width: size.width * 0.95, height: size.height * 0.95)

    }
    
    func setPhysicsBody(texture: SKTexture, width: CGFloat, height: CGFloat) {
        let size = CGSize(width: width, height: height)
        var body: SKPhysicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.9, size: size)
        body.dynamic = true
        body.categoryBitMask = BodyType.char.rawValue
        body.affectedByGravity = false
        body.collisionBitMask = BodyType.beam.rawValue | BodyType.powerup.rawValue | BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue
        body.contactTestBitMask = BodyType.beam.rawValue | BodyType.powerup.rawValue | BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue
        body.mass = 100
        body.allowsRotation = false
        self.physicsBody = body
    }
    
    func greenExplode() {
        if greenTimer  == 1000 {
            endShooting()
            canHold = false
            physicsBody?.dynamic = false
            physicsBody?.categoryBitMask = 0
            physicsBody?.collisionBitMask = 0
            physicsBody?.contactTestBitMask = 0
            greenTimer = 0
        }
    }
    
    func makeBodyDynamic() {
        
        self.physicsBody?.dynamic = true
        
    }
    
    func placeOnGround() {
        self.position.y = 173
    }
    
    func grow() {
        if currentState != Char.CharStates.Big {
            childNodeWithName("hold")?.removeFromParent()
            addTimer(redTimerTexture)
            normal = false
            growing = true
            self.texture = superTexture2
            currentState = Char.CharStates.Big
            growthTimer = 0
            growthTimer2 = 0
        }
    }
    
    func shrink() {
        if !isHurt {
            print("shrinking")
            self.texture = mainCharTexture
            growthTimer2 = 1000
            growthTimer = 200
            if canHit {
                let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / -1.7, duration: 0.0)
                leftArm.runAction(rotate)
                rightArm.runAction(rotate)
            }
            growing = false
            shrinking = false
            canPrep = false
            canHit = false
            hitting = false
        }
    }
    
    func shrink2() {
        //currentState = CharStates.Small
        if !shrunk {
            addTimer(grayTimerTexture)
            normal = false
            blink?.texture = invisble
            if currentState == CharStates.Shooting {
                childNodeWithName("throw")?.removeFromParent()
                //childNodeWithName("stache")?.removeFromParent()
                changeTexture(mainCharTexture)
                addRightArm()
                currentState = CharStates.Touch
            }
            accelY *= 2.8
            canHold = false
            shrinkTimer = 0
            shrunk = true
        }
    }
    
    func addSuper() {
        childNodeWithName("hold")?.removeFromParent()
        childNodeWithName("throw")?.removeFromParent()
        let arm =  childNodeWithName("right") as! SKSpriteNode
        if arm.texture == invisble {
            reAddRightArm()
        }
        canHold = false
        addTimer(blueTimerTexture)
        self.changeTexture(superTexture)
        tempPhysics = self.physicsBody
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 0
        if difficulty > 1.11 {
            currentState = CharStates.Super
        }
        //parent!.runAction(Animation())
        superTimer = 0
        addBlue()
        tempDiff = difficulty
        timerColor = parent!.childNodeWithName("timerColor") as! SKSpriteNode
        timerSize = timerColor.size.width
        sup = Super()
        sup.name = "sup"
        childNodeWithName("blink")?.removeFromParent()
        addChild(sup)
    }
    
    func removeSuper() {
        
    }
    
    func hold() {
        
        canHold = false
        isHolding = true
        changeTexture(stachelessTexture)
        let right = childNodeWithName("right") as! SKSpriteNode
        right.texture = invisble
        arm = Arm(texture: arm2Texure)
        arm.size = CGSizeMake(arm.size.width * 0.33, arm.size.height * 0.33)
        arm.anchorPoint = CGPointMake(0.92, 0.08)
        arm.position = CGPointMake(0, -4.9 * screenSize.height/375)
        arm.zPosition = 10
        arm.name = "hold"
        
        if shrunk {
            arm.size.width = arm.size.width * 0.2824 * screenSize.width/667
            arm.size.height = arm.size.height * 0.2824 * screenSize.height/375
        }
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / 4, duration: 0.0)
        arm.runAction(rotate)
        
        addChild(arm)
    }
    
    func resetArm() {
        texture = mainCharTexture
        childNodeWithName("hold")?.removeFromParent()
        canHold = true
        isHolding = false
        addRightArm()
    }
    
    func reAddRightArm() {
        if shooterTimer == 1000 {
            let right = childNodeWithName("right") as! SKSpriteNode
            right.texture = rightArmTexture
        }
    }
    
    func nohold() {
        canHold = false
        let right = childNodeWithName("right") as! SKSpriteNode
        right.texture = invisble
        let sad = SKSpriteNode(texture: sadTexture)
        sad.anchorPoint = self.anchorPoint
        sad.size = self.size
        sad.position = CGPointMake(0, 0)
        sad.zPosition = 31
        sad.name = "sad"
        addChild(sad)
        
        sadTimer = 0
    }
    
    func shoot(location: CGPoint, x: CGFloat, y: CGFloat) {
        
        isHolding = false
        runAction(throw)
        timer4 = 0
        currentState = CharStates.Shooting
        currentState = Char.CharStates.Shooting
        childNodeWithName("hold")!.removeFromParent()
        /*
        let x = location.x - self.position.x
        let y = location.y - self.position.y
        
        bullet = Bullet(imageNamed: "mustache")
        bullet.position = CGPointMake(20, 0)
        bullet.name = "stache"
        bullet.changeSpeed(x, y: y)
        bullet.zPosition = 1000
        addChild(bullet)
        */
        arm = Arm(texture: armTexture)
        arm.changeSize(0.22, h: 0.22)
        arm.anchorPoint = CGPointMake(0.13, 0.802)
        arm.position = CGPointMake(-0.2 * screenSize.width/667, -4.4 * screenSize.height/375)
        arm.zPosition = 10
        arm.name = "throw"
        
        if shrunk {
            arm.size.width = arm.size.width * 0.2824 * screenSize.width/667
            arm.size.height = arm.size.height * 0.2824 * screenSize.height/375
        }
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / 2, duration: 0.0)
        arm.runAction(rotate)
        
        addChild(arm)
        
        
    }
    
    func jump() {
        currentState = CharStates.Falling
        physicsBody?.affectedByGravity = true
        physicsBody?.applyImpulse(CGVectorMake(0, 120))
        
        changeTexture(jumpTexture)
        
    }
    
    func dead1() {
        
        currentState = CharStates.Dead
        
        let size = CGSize(width: 30, height: 100)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.affectedByGravity = true
        changeTexture(jumpTexture)
        
        physicsBody?.applyImpulse(CGVectorMake(-10, 10))
        
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / 2, duration: 0.4)
        runAction(rotateBack)
    }
    
    func addStache() {
        stache = SKSpriteNode(imageNamed: "stache")
        stache.position = CGPointMake(3.5, 2)
        stache.zPosition = 31
        stache.size.width = size.width * 0.2
        stache.size.height = size.height * 0.058
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / -25, duration: 0)
        stache.runAction(rotateBack)
        addChild(stache)
    }
    
    func dead2() {
        
        if currentState != CharStates.Dead {
        currentState = CharStates.Dead
        
        removeAllChildren()
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = 0
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 0
        self.texture = JumpImage
        
        physicsBody?.applyImpulse(CGVectorMake(-10005, 20500))
        
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / 2, duration: 0.4)
        runAction(rotateBack)
        }
    }
    
    func hurt() {
        if !isHurt {
        runAction(gruntSound)
        let colorBody = SKSpriteNode(texture: stachelessTexture)
        colorBody.position = CGPointMake(0, 0)
        colorBody.size = size
        colorBody.anchorPoint = anchorPoint
        colorBody.alpha = 0.3
        colorBody.name = "colorBody"
        colorBody.runAction(SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.0))
        addChild(colorBody)
        isHurt = true
        normal = false
        hurtTimer = 0
        self.runAction(hurtAnimation())
        }
    }
    
    func changeTexture(texture: SKTexture) {
        
        self.texture = texture
        
    }
    
    func changeSize(w: CGFloat, h: CGFloat) {
        self.size.width = self.size.width * w
        self.size.height = self.size.height * h
    }
    
    func addCape2() {
        cape = Cape()
        cape.zPosition = 3
        cape.anchorPoint = CGPointMake(1.0, 0.7)
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / -50, duration: 0.0)
        cape.runAction(rotate)
        cape.name = "cape"
        cape.position = CGPointMake(0.82, 1.5)
        //cape.position = CGPointMake(0.7, 1.2)
        cape.size = CGSizeMake(cape.size.width * 0.1347 * 0.9, cape.size.height * 0.154 * 0.9)
        addChild(cape)
    }
    
    func addGlasses() {
        let glasses = SKSpriteNode(texture: glassesTexture)
        glasses.zPosition = 4
        glasses.anchorPoint = self.anchorPoint
        glasses.name = "glasses"
        glasses.position = CGPointMake(0, 0)
        glasses.size = self.size//CGSizeMake(self.size.width, self.size.height)
        addChild(glasses)
    }
    
    func addBlink() {
        if currentState == .Idle {
            blink = SKSpriteNode(texture: blinki1)
            blink.size.width = size.width * 0.71
            blink.size.height = size.height * 1.0
            blink.position = CGPointMake(3.75 * screenSize.width/667, 13 * screenSize.height/375)
        }
        else if currentState == .Flying || currentState == .Shooting || currentState == .Touch {
            blink = SKSpriteNode(texture: blinks1)
            blink.size.width = size.width * 1.06
            blink.size.height = size.height * 1.0
            blink.position = CGPointMake(16.4 * screenSize.width/667, 10 * screenSize.height/375)
        }
        blink.name = "blink"
        blink.zPosition = 1
        addChild(blink)
    }
    
    func addLeftArm() {
        leftArm = SKSpriteNode(texture: leftArmTexture)
        leftArm.position = CGPointMake(12.5 * screenSize.width/667, -6.5 * screenSize.height/375)
        leftArm.zPosition = -1
        leftArm.size.width = leftArm.size.width * 0.14 * 0.9 * screenSize.width/667
        leftArm.size.height = leftArm.size.height * 0.14 * 0.9 * screenSize.height/375
        leftArm.anchorPoint = CGPointMake(0.4, 0.8)
        leftArm.name = "left"
        let rotateBack3 = SKAction.rotateByAngle(CGFloat(M_PI) / 12, duration: 0)
        let rotateBack2 = SKAction.rotateByAngle(CGFloat(M_PI) / 13, duration: 1)
        let rotateBack1 = SKAction.rotateByAngle(CGFloat(M_PI) / -13, duration: 1)
        let animate = SKAction.sequence([rotateBack1, rotateBack2])
        leftArm.runAction(rotateBack3)
        leftArm.runAction(SKAction.repeatActionForever(animate))
        addChild(leftArm)
    }
    
    func addRotateArm() {
        childNodeWithName("hold")?.removeFromParent()
        childNodeWithName("throw")?.removeFromParent()
        texture = stachelessTexture
        
        addTimer(darkBlueTimerTexture)
        
        let right = childNodeWithName("right") as! SKSpriteNode
        right.texture = invisble
        
        /*
        arm = Arm(texture: armTexture)
        arm.changeSize(0.22 * 0.9, h: 0.22 * 0.9)
        arm.anchorPoint = CGPointMake(0.093, 0.7073)
        arm.position = CGPointMake(-1.7, -6)
        arm.zPosition = 10
        arm.name = "rotateArm"
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / -2, duration: 0.1)
        arm.runAction(SKAction.repeatActionForever(rotateBack))*/
        
        arm = Arm(texture: arm2Texure)
        arm.size = CGSizeMake(arm.size.width * 0.33 * 0.9, arm.size.height * 0.33 * 0.9)
        arm.anchorPoint = CGPointMake(0.92, 0.08)
        arm.position = CGPointMake(0, -4.9)
        arm.zPosition = 10
        arm.name = "rotateArm"
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / -2, duration: 0.05)
        arm.runAction(SKAction.repeatActionForever(rotateBack))
        
        addChild(arm)
        
        addBullet()
        shotGenerator = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "addBullet", userInfo: nil, repeats: true)
        shooterTimer = 0
    }
    
    func endShooting() {
        if currentState == CharStates.Shooter {
            normal = true
            shooterTimer = 1000
            let dad = parent as! GameScene
            dad.childNodeWithName("timerColor")?.removeFromParent()
            dad.childNodeWithName("timer")?.removeFromParent()
            dad.childNodeWithName("pointer")?.removeFromParent()
            dad.shootLoc = CGPointMake(screenSize.width/1.3, screenSize.height/2)
            shotGenerator.invalidate()
            currentState = CharStates.Touch
            childNodeWithName("rotateArm")?.removeFromParent()
            reAddRightArm()
        }
    }
    
    func addBullet() {
        let dad = parent as? GameScene
        if dad != nil {
        let x = dad!.shootLoc.x - self.position.x
        let y = dad!.shootLoc.y - self.position.y
        var bullet = Bullet2(texture: mustacheTexture)
        bullet.position = CGPointMake(20, 0)
        bullet.changeSpeed(x, y: y)
        bullet.zPosition = 1
        bullets.append(bullet)
        addChild(bullet)
        }
    }
    
    func addRightArm() {
        rightArm = SKSpriteNode(texture: rightArmTexture)
        rightArm.position = CGPointMake(-0.3 * screenSize.width/667, -8 * screenSize.height/375)
        rightArm.zPosition = 1
        rightArm.size.width = rightArm.size.width * 0.225 * screenSize.width/667
        rightArm.size.height = rightArm.size.height * 0.225 * screenSize.height/375
        rightArm.anchorPoint = CGPointMake(0.2, 0.9)
        rightArm.name = "right"
        let rotateBack1 = SKAction.rotateByAngle(CGFloat(M_PI) / 13, duration: 1)
        let rotateBack2 = SKAction.rotateByAngle(CGFloat(M_PI) / -13, duration: 1)
        let rotateBack3 = SKAction.rotateByAngle(CGFloat(M_PI) / -12, duration: 0)
        let animate = SKAction.sequence([rotateBack1, rotateBack2])
        rightArm.runAction(rotateBack3)
        rightArm.runAction(SKAction.repeatActionForever(animate))
        addChild(rightArm)
        
        if shrunk {
            rightArm.size.width = rightArm.size.width * 0.2824
            rightArm.size.height = rightArm.size.height * 0.2824
            rightArm.position.y += 3.6
        }
    }
    
    func addBigArms() {
        leftArm = SKSpriteNode(texture: leftBigArmTexture)
        leftArm.position = CGPointMake(5 * screenSize.width/667, 3 * screenSize.height/375)
        leftArm.zPosition = -1
        leftArm.size.width = self.size.width * 1.3
        leftArm.size.height = self.size.height * 1.3
        leftArm.anchorPoint = CGPointMake(0.492, 0.5)
        leftArm.name = "leftbig"
        let rotateBack2 = SKAction.rotateByAngle(CGFloat(M_PI) / 50, duration: 1)
        let rotateBack1 = SKAction.rotateByAngle(CGFloat(M_PI) / -50, duration: 1)
        let rotateBack3 = SKAction.rotateByAngle(CGFloat(M_PI) / 50, duration: 0)
        let rotateBack4 = SKAction.rotateByAngle(CGFloat(M_PI) / -50, duration: 0)
        let animate = SKAction.sequence([rotateBack1, rotateBack2])
        let animate2 = SKAction.sequence([rotateBack2, rotateBack1])
        leftArm.runAction(rotateBack3)
        leftArm.runAction(SKAction.repeatActionForever(animate))
        addChild(leftArm)
        
        rightArm = SKSpriteNode(texture: rightBigArmTexture)
        rightArm.position = CGPointMake(-2 * screenSize.width/667, 4 * screenSize.height/375)
        rightArm.zPosition = 1
        rightArm.size.width = self.size.width * 1.3
        rightArm.size.height = self.size.height * 1.3
        rightArm.anchorPoint = CGPointMake(0.495, 0.502)
        rightArm.name = "rightbig"
        rightArm.runAction(rotateBack4)
        rightArm.runAction(SKAction.repeatActionForever(animate2))
        addChild(rightArm)
        
        leftArm.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100, 100))
        leftArm.physicsBody!.dynamic = false
        leftArm.physicsBody!.categoryBitMask = BodyType.bigarm.rawValue
        leftArm.physicsBody!.affectedByGravity = false
        leftArm.physicsBody!.collisionBitMask = BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.powerup.rawValue | BodyType.beam.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue
        leftArm.physicsBody!.contactTestBitMask = BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.powerup.rawValue | BodyType.beam.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue
        leftArm.physicsBody!.mass = 100000
        leftArm.physicsBody!.allowsRotation = false

    }
    
    func prepareHit() {
        canPrep = false
        canHit = true
        hitting = false
        let leftArm = childNodeWithName("leftbig") as! SKSpriteNode
        let rightArm = childNodeWithName("rightbig") as! SKSpriteNode
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / 1.7, duration: 0.0)
        let rotate2 = SKAction.rotateByAngle(CGFloat(M_PI) / 1.7, duration: 0.0)
        leftArm.runAction(rotate2)
        rightArm.runAction(rotate)
    }
    
    func hit() {
        canPrep = false
        canHit = false
        hitting = true
        let leftArm = childNodeWithName("leftbig") as! SKSpriteNode
        let rightArm = childNodeWithName("rightbig") as! SKSpriteNode
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / -1.7, duration: 0.3)
        let rotate2 = SKAction.rotateByAngle(CGFloat(M_PI) / -1.7, duration: 0.3)
        leftArm.runAction(rotate2)
        rightArm.runAction(rotate)
        growthTimer = 100
    }
    
    /*
    func addCape2() {
        cape = Cape()
        cape.zPosition = 2
        cape.anchorPoint = CGPointMake(1.0, 0.7)
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / -50, duration: 0.0)
        cape.runAction(rotate)
        cape.position = CGPointMake(2.2, 1)
        cape.size = CGSizeMake(cape.size.width * 0.1347 * 0.9, cape.size.height * 0.154 * 0.9)
        addChild(cape)
    }
    
    func addBlink() {
        if currentState == .Idle {
            blink = SKSpriteNode(imageNamed: "blinki1")
            blink.size.width = size.width * 0.7 * 0.9
            blink.size.height = size.height * 1.0 * 0.9
            blink.position = CGPointMake(4.75, 14.5)
        }
        else if currentState == .Flying || currentState == .Shooting || currentState == .Touch {
            blink = SKSpriteNode(imageNamed: "blinks1")
            blink.size.width = size.width * 1.1 * 0.9
            blink.size.height = size.height * 1.0 * 0.9
            blink.position = CGPointMake(19, 10.5)
        }
        blink.zPosition = 1
        addChild(blink)
    }*/
    
    func addTimer(texture: SKTexture) {

        let timer = SKSpriteNode(texture: timerTexture)
        timer.size = CGSizeMake(screenSize.width/2, screenSize.height/15)
        timer.position = CGPointMake(screenSize.width/14, screenSize.height/13)
        timer.anchorPoint = CGPointMake(0.0, 0.44)
        timer.zPosition = 300
        timer.name = "timer"
        
        parent!.addChild(timer)
        
        timerColor = SKSpriteNode(texture: texture)
        timerColor.size = timer.size
        timerColor.anchorPoint = timer.anchorPoint
        timerColor.position = timer.position
        timerColor.zPosition = 301
        timerColor.name = "timerColor"
        
        parent!.addChild(timerColor)
        
    }
    
    func move(speed: CGFloat) {
        self.position.y += speed
        timer = -5
        if speed > 0 {
            justMovedUp = true
            justMovedDown = false
        }
        else {
            justMovedUp = false
            justMovedDown = true
        }
    }
    
    func fallDeath() {
        removeAllChildren()
        position.y = 15 * screenSize.height/375
        texture = jumpTexture
        physicsBody?.categoryBitMask = 0
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 0
        fallD = true
        currentState = CharStates.Dead
        self.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -100, duration: 0.0))
        self.runAction(SKAction.rotateByAngle(CGFloat(M_PI)/2, duration: 0.4))
        //self.runAction(SKAction.moveByX(0, y: -100, duration: 0.6))
        goTimer = 0
    }
    
    func update() {
        if fallD {
            velY = -2.8
            position.y += velY
        }
        // update when told to by the GameScene class
        //do things for certain states

        if goTimer < 100 {
            goTimer++
            if goTimer == 7 {
                goTimer = 1000
                let dad = parent as! GameScene
                dad.gameOver()
            }
        }
        if position.y <= 2 && currentState != CharStates.Dead {
            fallDeath()
        }
        
        for bullet in bullets {
            bullet.update()
        }
        
        if greenTimer < 90 {
            if greenTimer == 0 {
                texture = jumpTexture
                removeAllChildren()
                currentState = CharStates.Dead
                alpha = 0.5
                self.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / -2, duration: 0.0))
                self.runAction(SKAction.rotateByAngle(CGFloat(M_PI) / 0.04, duration: 8.0))
                self.runAction(SKAction.sequence([SKAction.waitForDuration(0.15), SKAction.moveByX(-200, y: 0, duration: 1.2)]))
                self.runAction(SKAction.colorizeWithColor(UIColor(red: 37/255, green: 240/255, blue: 118/255, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.1))
            }
            greenTimer++
            if greenTimer == 25 {
                let dad = parent as! GameScene
                dad.stopEverything()
                removeAllChildren()
            }
            if greenTimer == 35 {
                let dad = parent as! GameScene
                dad.gameOver()
            }
        }
        
        if hurtTimer < 60 {
            hurtTimer++
            if hurtTimer == 60 {
                let colorize = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0, duration: 0)
                //self.runAction(colorize)
                removeAllActions()
                let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.3)
                runAction(fadeIn)
                normal = true
                isHurt = false
                childNodeWithName("colorBody")!.removeFromParent()
                hurtTimer = 1000
            }
        }
        
        if sadTimer < 15 {
            sadTimer++
            if sadTimer == 15 {
                canHold = true
                childNodeWithName("sad")?.removeFromParent()
                reAddRightArm()
            }
        }

        if growthTimer2 < 900 {
            if growthTimer2 == 0 {
                timerColor = parent!.childNodeWithName("timerColor") as! SKSpriteNode
                timerSize = timerColor.size.width
            }
            timerColor!.size.width -= timerSize/650
            growthTimer2++
            if growthTimer2 == 650 {
                self.shrink()
            }
        }
        if currentState == CharStates.Big {
        if growthTimer == 0 {
            childNodeWithName("throw")?.removeFromParent()
            let right = childNodeWithName("right") as! SKSpriteNode
            if right.texture == invisble {
                reAddRightArm()
            }
            let cape = childNodeWithName("cape") as? Cape
            leftArm = childNodeWithName("left") as? SKSpriteNode
            rightArm = childNodeWithName("right") as? SKSpriteNode
            isHolding = false
            canHold = false
            blink?.texture = invisble
            
            cape!.position = CGPointMake(cape!.position.x - 6, cape!.position.y + 10)
            let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / 30, duration: 0)
            cape!.runAction(rotate)
            leftArm!.removeFromParent()
            rightArm!.removeFromParent()
            addBigArms()
            
            leftArm = childNodeWithName("leftbig") as? SKSpriteNode
            rightArm = childNodeWithName("rightbig") as? SKSpriteNode
            
            growthTimer++
        }
        else if growthTimer < 12 {
            canPrep = false
            canHit = false
            hitting = true
            self.changeSize(1.05, h: 1.05)
            cape!.size.width = cape!.size.width * 1.04
            cape!.size.height = cape!.size.height * 1.04
            //leftArm!.position.y = leftArm!.position.y + 0.1
            //rightArm!.position.y = rightArm!.position.y + 0.1
            leftArm!.size.width = leftArm!.size.width * 1.045
            leftArm!.size.height = leftArm!.size.height * 1.045
            rightArm!.size.width = rightArm!.size.width * 1.045
            rightArm!.size.height = rightArm!.size.height * 1.045
            growthTimer++
        }
            
        else if growthTimer == 12 {
            growthTimer++
            //self.physicsBody = SKPhysicsBody(circleOfRadius: 2)
            let redColor = UIColor(red: 254.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            block = SKSpriteNode(color: redColor, size: CGSizeMake(28, 12))
            block.anchorPoint = CGPointMake(0.0, 0.0)
            block.position = CGPointMake(-30, -7)
            block.zPosition = 2
            addChild(block)
        }
            
        else if growthTimer > 12 && growthTimer < 18 {
            growthTimer++
            if growthTimer == 18 {
                canPrep = true
                canHit = false
                hitting = false
                growing = false
            }
        }
            
        else if growthTimer > 90 && growthTimer < 112 {
            growthTimer++
        }
            
        else if growthTimer == 112 {
            canPrep = false
            canHit = false
            hitting = false
            growthTimer++
        }
        else if growthTimer < 116 {
            growthTimer++
            if growthTimer == 116 {
                canPrep = true
            }
        }
            
            
        else if growthTimer > 190 && growthTimer < 212 {
            if growthTimer == 200 {
                parent!.childNodeWithName("timerColor")?.removeFromParent()
                parent!.childNodeWithName("timer")?.removeFromParent()
            }
            let cape = childNodeWithName("cape") as? Cape
            leftArm = childNodeWithName("leftbig") as? SKSpriteNode
            rightArm = childNodeWithName("rightbig") as? SKSpriteNode
            block?.color = UIColor.clearColor()
            block?.removeFromParent()
            self.changeSize(0.95238, h: 0.95238)
            cape!.size.width = cape!.size.width * 0.96154
            cape!.size.height = cape!.size.height * 0.96154
            cape!.position.y = cape!.position.y - 0.4
            cape!.position.x = cape!.position.x + 0.4
            //leftArm!.position.y = leftArm!.position.y + 0.1
            //rightArm!.position.y = rightArm!.position.y + 0.1
            leftArm!.size.width = leftArm!.size.width * 0.95693
            leftArm!.size.height = leftArm!.size.height * 0.95693
            rightArm!.size.width = rightArm!.size.width * 0.95693
            rightArm!.size.height = rightArm!.size.height * 0.95693
            growthTimer++
            if growthTimer == 212 {
                canPrep = false
                canHit = false
                hitting = false
                canHold = true
                leftArm!.removeFromParent()
                rightArm!.removeFromParent()
                addLeftArm()
                addRightArm()
                cape!.removeFromParent()
                addCape2()
                self.size.width = charIdleTexture.size().width * 0.36 * screenSize.width/667
                self.size.height = charIdleTexture.size().height * 0.36 * screenSize.height/375
            }
        }
        else if growthTimer > 200 && growthTimer < 240 {
            growthTimer++
        }
        else if growthTimer == 240 {
            shrinking = false
            growing = false
            //normal = true
            //physicsBody?.collisionBitMask = BodyType.beam.rawValue | BodyType.powerup.rawValue | BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue
            //physicsBody?.contactTestBitMask = BodyType.beam.rawValue | BodyType.powerup.rawValue | BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue
            if currentState == CharStates.Big {
                currentState = CharStates.Touch
            }
            growthTimer++
        }
        }
        //else if shrunk {
        if shooterTimer < 400 {
            if shooterTimer == 0 {
                timerColor = parent!.childNodeWithName("timerColor") as! SKSpriteNode
                timerSize = timerColor.size.width
            }
            timerColor.size.width -= timerSize/400
            shooterTimer++
            if shooterTimer == 400 {
                let dad = parent as! GameScene
                if dad.stacheCount > 0 {
                    texture = mainCharTexture
                }
                parent!.childNodeWithName("timerColor")?.removeFromParent()
                parent!.childNodeWithName("timer")?.removeFromParent()
                endShooting()
            }
        }
            if shrinkTimer < 12 {
                if shrinkTimer == 0 {
                    timerColor = parent!.childNodeWithName("timerColor") as! SKSpriteNode
                    timerSize = timerColor.size.width
                    if blink != nil {
                        blink!.removeFromParent()
                    }
                    tempPhysics = self.physicsBody
                }
                timerColor!.size.width -= timerSize/600
                self.changeSize(0.9, h: 0.9)
                cape!.size.width = cape!.size.width * 0.9
                cape!.size.height = cape!.size.height * 0.9
                leftArm!.size.width = leftArm!.size.width * 0.9
                leftArm!.size.height = leftArm!.size.height * 0.9
                rightArm!.size.width = rightArm!.size.width * 0.9
                rightArm!.size.height = rightArm!.size.height * 0.9
                shrinkTimer++
                
                rightArm.position.y += 0.45 * screenSize.width/667
                leftArm.position.y += 0.4 * screenSize.width/667
                leftArm.position.x -= 0.75 * screenSize.width/667
                cape.position.x -= 0.4 * screenSize.width/667
                
                cape!.position.x = cape!.position.x + 0.3 * screenSize.width/667
                
                let size = CGSize(width: 0.7 * self.size.width, height: 0.7 * self.size.height)
                var body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
                body.dynamic = true
                body.categoryBitMask = BodyType.char.rawValue
                body.affectedByGravity = false
                body.collisionBitMask = BodyType.beam.rawValue | BodyType.powerup.rawValue | BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue
                body.contactTestBitMask = BodyType.beam.rawValue | BodyType.powerup.rawValue | BodyType.ceiling.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue | BodyType.rotateArms.rawValue | BodyType.rotater.rawValue
                body.mass = 100
                body.allowsRotation = false
                self.physicsBody = body
            }
            else if shrinkTimer == 12 {
                canHold = true
                timerColor!.size.width -= timerSize/600
                shrinkTimer++
            }
            else if shrinkTimer < 600 {
                timerColor!.size.width -= timerSize/600
                shrinkTimer++
            }
            else if shrinkTimer < 612 {
                if shrinkTimer == 600 {
                    parent!.childNodeWithName("timerColor")?.removeFromParent()
                    parent!.childNodeWithName("timer")?.removeFromParent()
                    canHold = false
                    shrunk = false
                    if currentState == CharStates.Shooting {
                        childNodeWithName("throw")?.removeFromParent()
                        //childNodeWithName("stache")?.removeFromParent()
                        changeTexture(mainCharTexture)
                        reAddRightArm()
                        currentState = CharStates.Touch
                    }
                    if velY > 3 {
                        velY = 3
                    }
                    if velY < -3 {
                        velY = -3
                    }
                }
                let taco = parent as! GameScene
                taco.charAccel = 0.23
                self.changeSize(1.111, h: 1.111)
                cape!.size.width = cape!.size.width * 1.111
                cape!.size.height = cape!.size.height * 1.111
                leftArm!.size.width = leftArm!.size.width * 1.111
                leftArm!.size.height = leftArm!.size.height * 1.111
                rightArm!.size.width = rightArm!.size.width * 1.111
                rightArm!.size.height = rightArm!.size.height * 1.111
                
                rightArm.position.y -= 0.45 * screenSize.width/667
                leftArm.position.y -= 0.4 * screenSize.width/667
                leftArm.position.x += 0.75 * screenSize.width/667
                cape.position.x += 0.4 * screenSize.width/667
                
                shrinkTimer++
                if shrinkTimer == 612 {
                    canHold = true
                    isHolding = false
                    cape.position = CGPointMake(0.7, 1.2)
                    rightArm.removeFromParent()
                    addRightArm()
                    self.physicsBody = tempPhysics
                    normal = true
                }
            }

        if timer3 < 150 {
            self.position.y = self.position.y - 4
            if self.position.y < screenSize.height/2 + 8 {
                timer3 = 300
            }
        }
        
        if currentState == .Idle {
            if timer2 < 170 {
                timer2++
            }
            else if timer2 == 170 {
                addBlink()
                timer2++
            }
            else if timer2 < 172 {
                timer2++
            }
            else if timer2 == 172 {
                blink.texture = blinki2
                timer2++
            }
            else if timer2 < 174 {
                timer2++
            }
            else if timer2 == 174 {
                blink.texture = blinki3
                timer2++
            }
            else if timer2 < 176 {
                timer2++
            }
            else if timer2 == 176 {
                blink.texture = blinki4
                timer2++
            }
            else if timer2 < 182 {
                timer2++
            }
            else if timer2 == 182 {
                blink.texture = blinki3
                timer2++
            }
            else if timer2 < 184 {
                timer2++
            }
            else if timer2 == 184 {
                blink.texture = blinki2
                timer2++
            }
            else if timer2 < 186 {
                timer2++
            }
            else if timer2 == 186 {
                blink.texture = blinki1
                timer2++
            }
            else if timer2 < 188 {
                timer2++
            }
            else {
                if timer2 ==  188 {
                    timer2 = 0
                    blink.removeFromParent()
                }
                timer2++
            }
        }
        
        if (currentState == .Flying || currentState == .Touch) && normal {
            if timer2 < 170 {
                timer2++
            }
            else if timer2 == 170 {
                addBlink()
                timer2++
            }
            else if timer2 < 172 {
                timer2++
            }
            else if timer2 == 172 {
                blink.texture = blinks2
                timer2++
            }
            else if timer2 < 174 {
                timer2++
            }
            else if timer2 == 174 {
                blink.texture = blinks3
                timer2++
            }
            else if timer2 < 176 {
                timer2++
            }
            else if timer2 == 176 {
                blink.texture = blinks4
                timer2++
            }
            else if timer2 < 182 {
                timer2++
            }
            else if timer2 == 182 {
                blink.texture = blinks3
                timer2++
            }
            else if timer2 < 184 {
                timer2++
            }
            else if timer2 == 184 {
                blink.texture = blinks2
                timer2++
            }
            else if timer2 < 186 {
                timer2++
            }
            else if timer2 == 186 {
                blink.texture = blinks1
                timer2++
            }
            else if timer2 < 188 {
                timer2++
            }
            else {
                if timer2 ==  188 {
                    timer2 = 0
                    blink.removeFromParent()
                }
                timer2++
            }
        }
        
        if greenTimer == 1000 && velY == 0 && accelY == 0 {
            if(timer < 25) {
                self.position.y = self.position.y + (2/10) * screenSize.width/667
                timer++
            }
            else {
                self.position.y = self.position.y - (2/10) * screenSize.width/667
                timer++
                if(timer == 50) {
                    timer = 0
                }
            }
        }
        
        if currentState == .Touch || currentState == .Shooting || currentState == Char.CharStates.Big || currentState == Char.CharStates.Shooter || currentState == Char.CharStates.Super {
            
            let parent = self.parent as! GameScene
            //parent.movingUp = true
            
            if moveUpLater && position.y < screenSize.height - 40 {
                moveUpLater = false
                accelY = 0.8
            }
            
            if self.position.y < -5 {
                let parent = self.parent as! GameScene
                //parent.gameOver()
            }
            
            
            if (greenTimer == 1000) && (self.position.y < screenSize.height - 5 || accelY <= 0) {
                self.position.y += (velY * screenSize.height/375)
                if shrunk {
                    if (velY > 7.8 && accelY >= 0) || (velY < -7.8 && accelY <= 0) {
                        accelY = 0
                    }
                    else if (velY > 0 && accelY > 0) || (velY < 0 && accelY < 0) {
                        accelY = accelY * 0.80
                    }
                }
                else {
                    if (velY > 3.5 && accelY >= 0) || (velY < -3.5 && accelY <= 0) {
                        accelY = 0
                    }
                    else if (velY > 0 && accelY > 0) || (velY < 0 && accelY < 0) {
                        accelY = accelY * 0.93
                    }
                }
                velY += accelY
            }
            
            /*else if self.position.y > screenSize.height - 5 {
                self.position.y = screenSize.height - 5
                accelY = 0
                velY = 0
            }*/
            
        }
        
        if( currentState == .Flying) {
            
            if notMoving {
                if justMovedUp{
                    if(timer < 0) {
                        self.position.y = self.position.y + 4/10
                        timer++
                    }
                    if(timer < 20) {
                        self.position.y = self.position.y + 2/10
                        timer++
                    }
                    else {
                        self.position.y = self.position.y - 2/10
                        timer++
                        if(timer == 40) {
                            timer = 0
                        }
                    }
                }
                    
                else if justMovedDown {
                    if(timer < 0) {
                        self.position.y = self.position.y - 4/10
                        timer++
                    }
                    else if(timer < 20) {
                        self.position.y = self.position.y - 2/10
                        timer++
                    }
                    else {
                        self.position.y = self.position.y + 2/10
                        timer++
                        if(timer == 40) {
                            timer = 0
                        }
                    }
                }
                
            }
                
            else {
                timer = -5
            }
            
        }
        
        if( currentState == .Shooting) {
            if !shrunk {
                if timer2 < 170 {
                    timer2++
                }
                else if timer2 == 170 {
                    addBlink()
                    timer2++
                }
                else if timer2 < 172 {
                    timer2++
                }
                else if timer2 == 172 {
                    blink.texture = blinks2
                    timer2++
                }
                else if timer2 < 174 {
                    timer2++
                }
                else if timer2 == 174 {
                    blink.texture = blinks3
                    timer2++
                }
                else if timer2 < 176 {
                    timer2++
                }
                else if timer2 == 176 {
                    blink.texture = blinks4
                    timer2++
                }
                else if timer2 < 182 {
                    timer2++
                }
                else if timer2 == 182 {
                    blink.texture = blinks3
                    timer2++
                }
                else if timer2 < 184 {
                    timer2++
                }
                else if timer2 == 184 {
                    blink.texture = blinks2
                    timer2++
                }
                else if timer2 < 186 {
                    timer2++
                }
                else if timer2 == 186 {
                    blink.texture = blinks1
                    timer2++
                }
                else if timer2 < 188 {
                    timer2++
                }
                else {
                    if timer2 ==  188 {
                        timer2 = 0
                        blink.removeFromParent()
                    }
                    timer2++
                }
            }
            if(timer4 < 30) {
                timer4++
            }
            else if timer4 == 40 {
                shrinking = false
                growing = false
                childNodeWithName("throw")?.removeFromParent()
                //childNodeWithName("stache")?.removeFromParent()
                let dad = parent as! GameScene
                if dad.stacheCount == 0 {
                    changeTexture(stachelessTexture)
                }
                else if dad.stacheCount > 0 {
                    changeTexture(mainCharTexture)
                }
                reAddRightArm()
                currentState = CharStates.Touch//Flying
                canHold = true
                timer4++
            }
        }
        
        if( currentState == .Falling) {
            physicsBody?.affectedByGravity = true
        }
        
        if(bullet != nil) {
            bullet.update()
            
            if bullet.position.x > screenSize.width + 10 || bullet.position.y < -self.position.y {
                childNodeWithName("stache")?.removeFromParent()
                timer4 = 40
            }
        }
        
        if(currentState == .Super) {
            let sup = childNodeWithName("sup") as? Super
            if sup != nil {
                sup!.update()
            }
            if superTimer < 700 {
                timerColor!.size.width -= timerSize/340
                //let GS = parent as! GameScene
                //GS.addPointAddition(1, color: UIColor(red: 25/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0))
                let pointsLabel = parent!.childNodeWithName("pointsLabel") as! PointsLabel
                pointsLabel.add(1)
                if superTimer < 18 {
                    //difficulty *= 1.07
                    position.x = position.x + 2.5 * screenSize.width/667
                    //position.y = position.y + 3
                }
                if superTimer == 15 {
                    difficulty *= 4
                }
                if superTimer == 16 {
                    let GS = parent as! GameScene
                    let cloudGenerator = GS.childNodeWithName("cloudGenerator") as? CloudGenerator
                    let wallGenerator = GS.childNodeWithName("wallGenerator") as? WallGenerator
                    let enemyGenerator = GS.childNodeWithName("enemyGenerator") as? EnemyGenerator
                    let birdGenerator = GS.childNodeWithName("birdGenerator") as? BirdGenerator
                    let coinGenerator = GS.childNodeWithName("coinGenerator") as? CoinGenerator
                    let powerUpGenerator = GS.childNodeWithName("powerUpGenerator") as? PowerUpGenerator
                    cloudGenerator?.moveFaster()
                    wallGenerator?.moveFaster()
                    enemyGenerator?.moveFaster()
                    birdGenerator?.moveFaster()
                    coinGenerator?.moveFaster()
                    powerUpGenerator?.moveFaster()
                }
                if superTimer == 280 {
                    let GS = parent as! GameScene
                    GS.pauseGenerators()
                }
                if superTimer == 340 {
                    let sup = childNodeWithName("sup") as! Super
                    sup.timer = 0
                    parent!.childNodeWithName("timerColor")?.removeFromParent()
                    parent!.childNodeWithName("timer")?.removeFromParent()
                    difficulty = tempDiff
                }
                if superTimer >= 340 && superTimer < 358 {
                    position.x = position.x - 2.5 * screenSize.width/667
                }
                if superTimer == 367 {
                    normal = true
                    currentState = CharStates.Touch
                    let GS = parent as! GameScene
                    GS.resumeGenerators()
                    superTimer == 1000
                    //difficulty = tempDiff + 0.05
                }
                superTimer++
            }
        }
        
    }
    
    func Animation() -> SKAction {
        let duration = 0.4
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / 20, duration: 0.1)
        let rotateBack2 = SKAction.rotateByAngle(CGFloat(M_PI) / -20, duration: 0.1)
        let animate = SKAction.sequence([rotateBack, rotateBack2])
        return SKAction.repeatActionForever(animate)
    }
    
    func addBlue() {
        let blue = SKSpriteNode(texture: blueTexture)
        blue.size = CGSizeMake(screenSize.width, screenSize.height)
        blue.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        blue.zPosition = 2000
        blue.alpha = 0.2
        blue.name = "blue"
        
        self.parent!.addChild(blue)
    }
    
    
    func addYellow() {
        let yellow = SKSpriteNode(texture: yellowTexture)
        yellow.size = CGSizeMake(screenSize.width, screenSize.height)
        yellow.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        yellow.zPosition = 2000
        yellow.alpha = 0.1
        yellow.name = "yellow"
        
        self.parent!.addChild(yellow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hurtAnimation() -> SKAction {
        let duration = 0.4
        let colorize = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0.3, duration: 0)
        //self.runAction(colorize)
        let fadeOut = SKAction.fadeAlphaTo(0.3, duration: duration)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatActionForever(blink)
    }
    
}

