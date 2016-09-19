//
//  Constants.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/7/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import SpriteKit
import Foundation
import UIKit

var difficulty: CGFloat = 0.8
var type: Int = 0

var screenSize: CGRect = UIScreen.mainScreen().bounds

// Configuration
let GroundHeight: CGFloat = 20.0

// Collision Detection
let heroCategory: UInt32 = 0x1
let wallCategory: UInt32 = 0x01
let groundCategory: UInt32 = 0x001

//GS Textures
let gameOverTexture = SKTexture(imageNamed: "gameover")
let playAgainTexture1 = SKTexture(imageNamed: "playagain1")
let playAgainTexture2 = SKTexture(imageNamed: "playagain2")
let resumeTexture1 = SKTexture(imageNamed: "resumebutton1")
let resumeTexture2 = SKTexture(imageNamed: "resumebutton2")
let scoreTexture = SKTexture(imageNamed: "score")
let titleTexture = SKTexture(imageNamed: "titlenofaceG")
let titleFaceTexture = SKTexture(imageNamed: "faceG4")
let p1Texture = SKTexture(imageNamed: "p1")
let htpTexture = SKTexture(imageNamed: "htp1")
let hsTextTexture = SKTexture(imageNamed: "hs1")
let title2Texture = SKTexture(imageNamed: "title2")
let pausedTexture = SKTexture(imageNamed: "paused")
let sliderTexture = SKTexture(imageNamed: "slider")
let barTexture = SKTexture(imageNamed: "bar")
let mustacheTexture2 = SKTexture(imageNamed: "mustache2G")
let timerTexture = SKTexture(imageNamed: "timer")
let redTimerTexture = SKTexture(imageNamed: "redTimer")
let grayTimerTexture = SKTexture(imageNamed: "graytimer")
let blueTimerTexture = SKTexture(imageNamed: "blueTimer")
let darkBlueTimerTexture = SKTexture(imageNamed: "darkblueTimer")
let heartTexture = SKTexture(imageNamed: "heartG")
let heartTexture2 = SKTexture(imageNamed: "heart2G")
let bombTexture = SKTexture(imageNamed: "bombG")
let bombTexture2 = SKTexture(imageNamed: "bomb2G")
let launchTexture = SKTexture(imageNamed: "launchscreen5")
let launchTexture2 = SKTexture(imageNamed: "launchscreen6")
let gcTexture1 = SKTexture(imageNamed: "GC12")
let gcTexture2 = SKTexture(imageNamed: "GC13")
let menuTexture1 = SKTexture(imageNamed: "back3")
let menuTexture2 = SKTexture(imageNamed: "back4")
let trophyTexture1 = SKTexture(imageNamed: "trophybutton3")
let trophyTexture2 = SKTexture(imageNamed: "trophybutton4")
let htpTexture1 = SKTexture(imageNamed: "question3")
let htpTexture2 = SKTexture(imageNamed: "question4")
let settingsTexture1 = SKTexture(imageNamed: "settings1")
let settingsTexture2 = SKTexture(imageNamed: "settings2")
let skyTexture = SKTexture(imageNamed: "sky3")
let faceBookTexture = SKTexture(imageNamed: "fbButton")
let twitterTexture = SKTexture(imageNamed: "twitButton2")
let faceBookTexture2 = SKTexture(imageNamed: "fbButton2")
let twitterTexture2 = SKTexture(imageNamed: "twitButton3")
let retryTexture1 = SKTexture(imageNamed: "retry1")
let retryTexture2 = SKTexture(imageNamed: "retry2")
let onTexture = SKTexture(imageNamed: "onG")
let offTexture = SKTexture(imageNamed: "offG")
let resetScoresTexture1 = SKTexture(imageNamed: "resetScores1G")
let resetScoresTexture2 = SKTexture(imageNamed: "resetScores2G")
let iPadBarTexture = SKTexture(imageNamed: "ipadbar4")


//How To
let howToTexture1 = SKTexture(imageNamed: "howto1")
let howToTexture2 = SKTexture(imageNamed: "howto2")
let howToTexture3 = SKTexture(imageNamed: "howto3")
let howToTexture4 = SKTexture(imageNamed: "howto4")
let howToTexture5 = SKTexture(imageNamed: "howto5")

//WG Textures
let spikeWallTexture = SKTexture(imageNamed: "spikewallG")
let openWallTexture = SKTexture(imageNamed: "woodG")
let topBrokeTexture = SKTexture(imageNamed: "topbrokeG")
let bottomBrokeTexture = SKTexture(imageNamed: "bottombrokeG")
let topWallTexture = SKTexture(imageNamed: "wood2G")
let prickTexture = SKTexture(imageNamed: "prick")

//EG Textures
let enemyTexture1 = SKTexture(imageNamed: "enemy1G")
let enemyTexture2 = SKTexture(imageNamed: "enemy2G")
let enemyTexture3 = SKTexture(imageNamed: "enemy4G")
let alienTexture1 = SKTexture(imageNamed: "alien1RG")
let alienTexture2 = SKTexture(imageNamed: "alien2RG")
let alienTexture3 = SKTexture(imageNamed: "alien3RG")
let explosionTexture = SKTexture(imageNamed: "explosion")
let gunnerTexture = SKTexture(imageNamed: "gunnerG")
let fireTexture = SKTexture(imageNamed: "fire")
let bootFireTexture = SKTexture(imageNamed: "bootfire")
let rotaterTexture = SKTexture(imageNamed: "rotatealienG2")
let rotateArmsTexture = SKTexture(imageNamed: "rotatearmsG2")
let energyTexture = SKTexture(imageNamed: "energy")
let eBallTexture = SKTexture(imageNamed: "eball")

//Cloud Textures
let cloudTexture = SKTexture(imageNamed: "cloud2G")
let bigCloudTexture = SKTexture(imageNamed: "bigcloudG")

//Char Textures
let charIdleTexture = SKTexture(imageNamed: "IdleG2C")
let superTexture = SKTexture(imageNamed: "supcharGC")
let superTexture2 = SKTexture(imageNamed: "supcharG2C")
let stachelessTexture = SKTexture(imageNamed: "stachelessGC")
let jumpTexture = SKTexture(imageNamed: "jumpC")
let JumpImage = SKTexture(imageNamed: "jumpC")
let mainCharTexture = SKTexture(imageNamed: "FlyingGC")
let blueTexture = SKTexture(imageNamed: "blue")
let yellowTexture = SKTexture(imageNamed: "yellow")
let blinki1 = SKTexture(imageNamed: "blinki1")
let blinki2 = SKTexture(imageNamed: "blinki2")
let blinki3 = SKTexture(imageNamed: "blinki3")
let blinki4 = SKTexture(imageNamed: "blinki4")
let blinks1 = SKTexture(imageNamed: "blinks1")
let blinks2 = SKTexture(imageNamed: "blinks2")
let blinks3 = SKTexture(imageNamed: "blinks3")
let blinks4 = SKTexture(imageNamed: "blink4")
let arm2Texure = SKTexture(imageNamed: "arm2G")
let armTexture = SKTexture(imageNamed: "armG")
let capeTexture = SKTexture(imageNamed: "cape1G")
let mustacheTexture = SKTexture(imageNamed: "mustache")
let leftArmTexture = SKTexture(imageNamed: "leftarmG7")
let rightArmTexture = SKTexture(imageNamed: "rightarmG4")
let leftBigArmTexture = SKTexture(imageNamed: "leftbigarm5")
let rightBigArmTexture = SKTexture(imageNamed: "rightbigarm5")
let moneyManTexture = SKTexture(imageNamed: "moneyman")
let glassesTexture = SKTexture(imageNamed: "moneymanface")
let sadTexture = SKTexture(imageNamed: "sad")
let pointerTexture = SKTexture(imageNamed: "pointer")


//Coins 
let coin1Texture = SKTexture(imageNamed: "coinGG1")
let coin2Texture = SKTexture(imageNamed: "coinGG2")
let coin3Texture = SKTexture(imageNamed: "coinGG3")

//Power Ups
let moneyTokenTexture1 = SKTexture(imageNamed: "moneytoken1")
let moneyTokenTexture2 = SKTexture(imageNamed: "moneytoken2")
let moneyTokenTexture3 = SKTexture(imageNamed: "moneytoken3")
let moneyTokenTexture4 = SKTexture(imageNamed: "moneytoken4")
let moneyTokenTexture1G = SKTexture(imageNamed: "moneytoken1G")

let muscleTokenTexture1 = SKTexture(imageNamed: "muscletoken1")
let muscleTokenTexture2 = SKTexture(imageNamed: "muscletoken2")
let muscleTokenTexture3 = SKTexture(imageNamed: "muscletoken3")
let muscleTokenTexture4 = SKTexture(imageNamed: "muscletoken4")

let miniTokenTexture1 = SKTexture(imageNamed: "minitoken1")
let miniTokenTexture2 = SKTexture(imageNamed: "minitoken2")
let miniTokenTexture3 = SKTexture(imageNamed: "minitoken3")
let miniTokenTexture4 = SKTexture(imageNamed: "minitoken4")

let shooterTokenTexture1 = SKTexture(imageNamed: "shootertoken1")
let shooterTokenTexture2 = SKTexture(imageNamed: "shootertoken2")
let shooterTokenTexture3 = SKTexture(imageNamed: "shootertoken3")
let shooterTokenTexture4 = SKTexture(imageNamed: "shootertoken4")

let superTokenTexture1 = SKTexture(imageNamed: "supertoken1")
let superTokenTexture2 = SKTexture(imageNamed: "supertoken2")
let superTokenTexture3 = SKTexture(imageNamed: "supertoken3")
let superTokenTexture4 = SKTexture(imageNamed: "supertoken4")

//Super
let superStacheTexture1 = SKTexture(imageNamed: "super1s")
let superStacheTexture2 = SKTexture(imageNamed: "super2s")
let superStacheTexture3 = SKTexture(imageNamed: "super3s")
let superStacheTexture4 = SKTexture(imageNamed: "super4s")
let superStacheTexture5 = SKTexture(imageNamed: "super5s")
let superStacheTexture6 = SKTexture(imageNamed: "super6s")
let superStacheTexture7 = SKTexture(imageNamed: "super7s")
let superStacheTexture7a = SKTexture(imageNamed: "super7as")
let superStacheTexture7b = SKTexture(imageNamed: "super7bs")

//Buttons
let whiteButtonTexture = SKTexture(imageNamed: "buttonwhite")
let blueButtonTexture = SKTexture(imageNamed: "buttonblue")
let pause2Texture = SKTexture(imageNamed: "pause2")
let pauseTexture = SKTexture(imageNamed: "pause")

//Random
let invisble = SKTexture(imageNamed: "invisible")
let blink1 = SKTexture(imageNamed: "faceblink1")
let blink2 = SKTexture(imageNamed: "faceblink2")
let blink3 = SKTexture(imageNamed: "faceblink3")
let blink4 = SKTexture(imageNamed: "faceblink4")
let birdTexture1 = SKTexture(imageNamed: "bird1G2")
let birdTexture2 = SKTexture(imageNamed: "bird2G2")
let stacheBagTexture = SKTexture(imageNamed: "stachebagG2")

//Sounds
var recharge: SKAction!
var coinSound: SKAction!
var crack: SKAction!
var grab: SKAction!
var throwSound: SKAction!
var explosion: SKAction!
var powerUpSound: SKAction!
var explosionSound: SKAction!
var chargingSound: SKAction!
var beamSound: SKAction!
var punchSound: SKAction!
var crashSound: SKAction!
var gruntSound: SKAction!
