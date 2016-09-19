//
//  Char.swift
//  Jumper
//
//  Created by Andrew on 6/13/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import Foundation
import SpriteKit

class Char2: SKSpriteNode {
    
    var timer = 0, timer2 = 0, timer3 = 100, timer4 = 0, timer5 = 100, timer6 = 0, timer7 = 0, timer8 = 0
    var bullet: Bullet!
    var cape: Cape!
    var arm: Arm!
    var sup: Super!
    var stache: SKSpriteNode!
    var blink: SKSpriteNode!
    var leftArm: SKSpriteNode!
    var rightArm: SKSpriteNode!
    var notMoving = true
    var justMovedUp = true
    var justMovedDown = false
    var canShoot = false
    var canHold = true
    var isHolding = false
    var on = true
    
    enum CharStates: Int {
        
        case Idle, Falling, Hurt, Fire, Moving, Dead, Shooting, Flying, Super
        
    }
    
    var currentState = CharStates.Idle
    
    init () {
        
        super.init(texture: charIdleTexture, color: nil, size: charIdleTexture.size())
        self.zPosition = 30
        changeSize(0.09, h: 0.09)
        setPhysicsBody(charIdleTexture, width: size.width, height: size.height)
        
    }
    
    func setPhysicsBody(texture: SKTexture, width: CGFloat, height: CGFloat) {
        let size = CGSize(width: width, height: height)
        var body: SKPhysicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.9, size: size)
        body.dynamic = true
        body.categoryBitMask = BodyType.char.rawValue
        body.affectedByGravity = false
        body.collisionBitMask = 0//BodyType.ground.rawValue | BodyType.wall.rawValue |
            //BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue
        body.contactTestBitMask = 0//BodyType.ground.rawValue | BodyType.wall.rawValue |
            //BodyType.wall2.rawValue | BodyType.enemy.rawValue | BodyType.coin.rawValue
        body.mass = 100
        self.physicsBody = body
    }
    
    
    func makeBodyDynamic() {
        
        self.physicsBody?.dynamic = true
        
    }
    
    func placeOnGround() {
        self.position.y = 173
    }
    
    func addSuper() {
        self.changeTexture(superTexture)
        self.zPosition = 3000
        physicsBody?.dynamic = false
        currentState = CharStates.Super
        parent!.runAction(Animation())
        timer5 = 0
        addBlue()
        sup = Super()
        sup.name = "sup"
        addChild(sup)
    }
    
    
    func addLeftArm() {
        leftArm = SKSpriteNode(imageNamed: "leftarm")
        leftArm.position = CGPointMake(13, 8)
        leftArm.zPosition = -1
        leftArm.size.width = leftArm.size.width * 0.125
        leftArm.size.height = leftArm.size.height * 0.125
        leftArm.anchorPoint = CGPointMake(0.65, 0.623)
        leftArm.name = "left"
        let rotateBack2 = SKAction.rotateByAngle(CGFloat(M_PI) / 32, duration: 1)
        let rotateBack1 = SKAction.rotateByAngle(CGFloat(M_PI) / -32, duration: 1)
        let animate = SKAction.sequence([rotateBack1, rotateBack2])
        leftArm.runAction(rotateBack2)
        leftArm.runAction(SKAction.repeatActionForever(animate))
        addChild(leftArm)
    }
    
    func addRightArm() {
        rightArm = SKSpriteNode(imageNamed: "rightarm")
        rightArm.position = CGPointMake(3, 10.5)
        rightArm.zPosition = 1
        rightArm.size.width = rightArm.size.width * 0.125
        rightArm.size.height = rightArm.size.height * 0.125
        rightArm.anchorPoint = CGPointMake(0.517, 0.660)
        rightArm.name = "right"
        let rotateBack1 = SKAction.rotateByAngle(CGFloat(M_PI) / 32, duration: 1)
        let rotateBack2 = SKAction.rotateByAngle(CGFloat(M_PI) / -32, duration: 1)
        let animate = SKAction.sequence([rotateBack1, rotateBack2])
        rightArm.runAction(rotateBack2)
        rightArm.runAction(SKAction.repeatActionForever(animate))
        addChild(rightArm)
    }
    
    func hold() {
        runAction(grab)
        
        canHold = false
        isHolding = true
        changeTexture(stachelessTexture)
        childNodeWithName("right")?.removeFromParent()
        arm = Arm(texture: arm2Texure)
        arm.size = CGSizeMake(arm.size.width * 0.33, arm.size.height * 0.33)
        arm.anchorPoint = CGPointMake(0.803, 0.143)
        arm.position = CGPointMake(-1.3, -5)
        arm.zPosition = 10
        arm.name = "hold"
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / 4, duration: 0.0)
        arm.runAction(rotate)
        
        addChild(arm)
    }
    
    func shoot(location: CGPoint) {
        
        isHolding = false
        runAction(throw)
        timer4 = 0
        currentState = CharStates.Shooting
        currentState = Char2.CharStates.Shooting
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
        arm.changeSize(0.25, h: 0.25)
        arm.anchorPoint = CGPointMake(0.13, 0.802)
        arm.position = CGPointMake(0, -6)
        arm.zPosition = 10
        arm.name = "throw"
        
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
        
        currentState = CharStates.Dead
        
        cape!.removeFromParent()
        blink?.removeFromParent()
        leftArm?.removeFromParent()
        rightArm?.removeFromParent()
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = 0
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 0
        self.texture = JumpImage
        
        physicsBody?.applyImpulse(CGVectorMake(-10005, 20500))
        
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / 2, duration: 0.4)
        runAction(rotateBack)
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
        cape.zPosition = 2
        cape.anchorPoint = CGPointMake(1.0, 0.7)
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) / -50, duration: 0.0)
        cape.runAction(rotate)
        cape.position = CGPointMake(2.2, 1)
        cape.size = CGSizeMake(cape.size.width * 0.1347, cape.size.height * 0.154)
        addChild(cape)
    }
    
    func addBlink() {
        if currentState == .Idle {
            blink = SKSpriteNode(imageNamed: "blinki1")
            blink.size.width = size.width * 0.7
            blink.size.height = size.height * 1.0
            blink.position = CGPointMake(4.75, 14.5)
        }
        else if currentState == .Flying || currentState == .Shooting {
            blink = SKSpriteNode(imageNamed: "blinks1")
            blink.size.width = size.width * 1.1
            blink.size.height = size.height * 1.0
            blink.position = CGPointMake(19, 10.5)
        }
        blink.zPosition = 1
        addChild(blink)
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
    
    func update() {
        // update when told to by the GameScene class
        //do things for certain states
        
        if timer3 < 200 {
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
            else if timer2 < 171 {
                timer2++
            }
            else if timer2 == 171 {
                blink.texture = blinki2
                timer2++
            }
            else if timer2 < 172 {
                timer2++
            }
            else if timer2 == 172 {
                blink.texture = blinki3
                timer2++
            }
            else if timer2 < 173 {
                timer2++
            }
            else if timer2 == 173 {
                blink.texture = blinki4
                timer2++
            }
            else if timer2 < 178 {
                timer2++
            }
            else if timer2 == 178 {
                blink.texture = blinki3
                timer2++
            }
            else if timer2 < 179 {
                timer2++
            }
            else if timer2 == 179 {
                blink.texture = blinki2
                timer2++
            }
            else if timer2 < 180 {
                timer2++
            }
            else if timer2 == 180 {
                blink.texture = blinki1
                timer2++
            }
            else if timer2 < 181 {
                timer2++
            }
            else {
                if timer2 ==  181 {
                    timer2 = 0
                    blink.removeFromParent()
                }
                timer2++
            }
        }
        
        if currentState == .Flying {
            if timer2 < 170 {
                timer2++
            }
            else if timer2 == 170 {
                addBlink()
                timer2++
            }
            else if timer2 < 171 {
                timer2++
            }
            else if timer2 == 171 {
                blink.texture = blinks2
                timer2++
            }
            else if timer2 < 172 {
                timer2++
            }
            else if timer2 == 172 {
                blink.texture = blinks3
                timer2++
            }
            else if timer2 < 173 {
                timer2++
            }
            else if timer2 == 173 {
                blink.texture = blinks4
                timer2++
            }
            else if timer2 < 178 {
                timer2++
            }
            else if timer2 == 178 {
                blink.texture = blinks3
                timer2++
            }
            else if timer2 < 179 {
                timer2++
            }
            else if timer2 == 179 {
                blink.texture = blinks2
                timer2++
            }
            else if timer2 < 180 {
                timer2++
            }
            else if timer2 == 180 {
                blink.texture = blinks1
                timer2++
            }
            else if timer2 < 181 {
                timer2++
            }
            else {
                if timer2 ==  181 {
                    timer2 = 0
                    blink.removeFromParent()
                }
                timer2++
            }
        }
        
        if( currentState == .Idle) {
            if(timer < 25) {
                self.position.y = self.position.y + 2/10
                timer++
            }
            else {
                self.position.y = self.position.y - 2/10
                timer++
                if(timer == 50) {
                    timer = 0
                }
            }
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
            if timer2 < 170 {
                timer2++
            }
            else if timer2 == 170 {
                addBlink()
                timer2++
            }
            else if timer2 < 171 {
                timer2++
            }
            else if timer2 == 171 {
                blink.texture = blinks2
                timer2++
            }
            else if timer2 < 172 {
                timer2++
            }
            else if timer2 == 172 {
                blink.texture = blinks3
                timer2++
            }
            else if timer2 < 173 {
                timer2++
            }
            else if timer2 == 173 {
                blink.texture = blinks4
                timer2++
            }
            else if timer2 < 178 {
                timer2++
            }
            else if timer2 == 178 {
                blink.texture = blinks3
                timer2++
            }
            else if timer2 < 179 {
                timer2++
            }
            else if timer2 == 179 {
                blink.texture = blinks2
                timer2++
            }
            else if timer2 < 180 {
                timer2++
            }
            else if timer2 == 180 {
                blink.texture = blinks1
                timer2++
            }
            else if timer2 < 181 {
                timer2++
            }
            else {
                if timer2 ==  181 {
                    timer2 = 0
                    blink.removeFromParent()
                }
                timer2++
            }
            
            if(timer4 < 30) {
                timer4++
            }
            else if timer4 == 40 {
                childNodeWithName("throw")?.removeFromParent()
                childNodeWithName("stache")?.removeFromParent()
                changeTexture(mainCharTexture)
                addRightArm()
                currentState = CharStates.Flying
                canHold = true
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
            let sup = childNodeWithName("sup") as! Super
            sup.update()
            if timer5 < 10 {
                println("1")
                position.x = position.x + 5
                //position.y = position.y + 3
                timer5++
            }
            else if timer5 < 20 {
                println("2")
                //position.y = position.y - 3
                timer5++
            }
            else {
                println("3")
                //position.y = position.y + 3
                timer5++
                if timer5 == 30 {
                    timer5 = 10
                }
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

