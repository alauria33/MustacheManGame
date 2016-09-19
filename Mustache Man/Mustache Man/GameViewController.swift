//
//  GameViewController.swift
//  Nimble Ninja
//
//  Created by Andrew on 6/7/15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import Social

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()
        
        // Configure the view
        let skView = view as! SKView
        skView.multipleTouchEnabled = true
        
        // Create and configue the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        // Present the scene
        skView.presentScene(scene)
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("myObserverMethod:"), name:UIApplicationDidEnterBackgroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "show:", name: "showID", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "send:", name: "sendID", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restart:", name: "restartID", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "authenticate:", name: "authenticateID", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "faceBook:", name: "faceBookID", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "twitter:", name: "twitterID", object: nil)
        
    }
    
    func restart(notification: NSNotification) {

    }
    
    func show(notification: NSNotification) {
        showLeader()
    }
    
    func send(notification: NSNotification) {
        sendHighscore(scene.GSScore)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //initiate gamecenter
    func authenticateLocalPlayer(){
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController, animated: true, completion: nil)
            }
                
            else {
                //println((GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
    
    func authenticate(notification : NSNotification){
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController, animated: true, completion: nil)
            }
                
            else {
                //println((GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
    
    
    
    //send high score to leaderboard
    func sendHighscore(score:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            var scoreReporter = GKScore(leaderboardIdentifier: "MustacheMan") //leaderboard id here
            
            scoreReporter.value = Int64(score) //score variable here (same as above)
            
            var scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError!) -> Void in
                if error != nil {
                    println("error")
                }
            })
            
        }
        
    }
    
    
    //shows leaderboard screen
    func showLeader() {
        var vc = self.view?.window?.rootViewController
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    func twitter(notification: NSNotification) {
        let pointsLabel = scene.childNodeWithName("pointsLabel") as! PointsLabel
        let score = pointsLabel.getNum()
        let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        tweetSheet.completionHandler = {
            result in
            switch result {
            case SLComposeViewControllerResult.Cancelled:
                //Add code to deal with it being cancelled
                break
                
            case SLComposeViewControllerResult.Done:
                //Add code here to deal with it being completed
                //Remember that dimissing the view is done for you, and sending the tweet to social media is automatic too. You could use this to give in game rewards?
                break
            }
        }
        
        tweetSheet.setInitialText("Just scored \(score) points in #mustacheman!! Can you beat me?") //The default text in the tweet
        tweetSheet.addImage(UIImage(named: "facesky.png")) //Add an image if you like?
        //tweetSheet.addURL(NSURL(string: "http://twitter.com")) //A url which takes you into safari if tapped on
        
        self.presentViewController(tweetSheet, animated: false, completion: {
            //Optional completion statement
        })
    }
    
    func faceBook(notification: NSNotification) {
        let pointsLabel = scene.childNodeWithName("pointsLabel") as! PointsLabel
        let score = pointsLabel.getNum()
        let faceBookSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        faceBookSheet.completionHandler = {
            result in
            switch result {
            case SLComposeViewControllerResult.Cancelled:
                //Add code to deal with it being cancelled
                break
                
            case SLComposeViewControllerResult.Done:
                //Add code here to deal with it being completed
                //Remember that dimissing the view is done for you, and sending the tweet to social media is automatic too. You could use this to give in game rewards?
                break
            }
        }
        
        faceBookSheet.setInitialText("Just scored \(score) points in Mustache Man!! Can you beat me?") //The default text in the tweet
        faceBookSheet.addImage(UIImage(named: "facesky.png")) //Add an image if you like?
        //faceBookSheet.addURL(NSURL(string: "")) //A url which takes you into safari if tapped on
        
        self.presentViewController(faceBookSheet, animated: false, completion: {
            //Optional completion statement
        })
    }
    
    func myObserverMethod(notification : NSNotification) {
        if scene.isStarted {
            scene.addPauseMenu()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

