//
//  GameViewController.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 27/01/22.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit
import GoogleMobileAds

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GADFullScreenContentDelegate {
    
    var scene: GameScene!
    private var interstitial: GADInterstitialAd?
    
    var check = true
    
    @IBOutlet weak var btnUpView: UIImageView!
    @IBOutlet weak var btnUp: UIButton!
    @IBOutlet weak var btnDownView: UIImageView!
    @IBOutlet weak var btnDown: UIButton!
    @IBOutlet weak var btnKick: UIButton!
    @IBOutlet weak var btnKickView: UIImageView!
    @IBOutlet weak var btnPunch: UIButton!
    @IBOutlet weak var btnPunchView: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var introView: UIView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPlayView: UIImageView!
    @IBOutlet weak var btnPlayAgain: UIButton!
    @IBOutlet weak var btnPlayAgainView: UIImageView!
    @IBOutlet weak var btnLeaderboard: UIButton!
    @IBOutlet weak var btnLeaderboardView: UIImageView!
    @IBOutlet weak var leftBtnsView: UIView!
    @IBOutlet weak var rightBtnsView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnSoundView: UIImageView!
    
    var audioPlayer = AudioManager.instance
    
    var score = CGFloat(0.0)
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    let LEADERBOARD_ID = "CyberunnerLeaderboard"
    let userData = UserData()
    
    var soundOn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let notificationCenter = NotificationCenter.default
        //        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        //        notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        verifySoundSettings()
        
        showIntroView()
        
        hideEndView()
        
        hideGameSettings()
        
        scoreLabel.font = UIFont(name: "NicoMoji-Regular", size: 15)
        
        AppUtility.lockOrientation(.landscape)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            scene = SKScene(fileNamed: "GameScene") as? GameScene
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.gameViewController = self
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            //            GameCenter.shared.authenticateLocalPlayer(presentingVC: self)
            authenticateLocalPlayer()
        }
        
        requestIntersticial()
    }
    
    //    @objc func appMovedToBackground() {
    //        print("App moved to background!")
    //    }
    //
    //    @objc func appBecomeActive() {
    //        print("App become active!")
    //    }
    
    func showAd() {
        if interstitial != nil {
            interstitial!.present(fromRootViewController: self)
        } else {
            scene.reset()
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        scene.reset()
    }
    
    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        requestIntersticial()
        scene.reset()
    }
    
    func requestIntersticial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-7234411944619676/1348617408",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
    func updateScore() {
        if gcEnabled {
            userData.saveBestScore(score: Int(score))
            updateScoreLabel()
            
            // Submit score to GC leaderboard
            let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
            bestScoreInt.value = Int64(score)
            GKScore.report([bestScoreInt])
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func BtnPlayPressed(_ sender: Any) {
        btnPlayView.image = UIImage(named: "btnPlayClicked")
        scene.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.btnPlayView.image = UIImage(named: "btnPlay")
        }
    }
    @IBAction func BtnPlayReleased(_ sender: Any) {
        btnPlayView.image = UIImage(named: "btnPlay")
    }
    
    @IBAction func BtnPlayAgainPressed(_ sender: Any) {
        btnPlayAgainView.image = UIImage(named: "btnPlayAgainClicked")
        showAd()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.btnPlayAgainView.image = UIImage(named: "btnPlayAgain")
        }
    }
    @IBAction func BtnPlayAgainReleased(_ sender: Any) {
        btnPlayAgainView.image = UIImage(named: "btnPlayAgain")
    }
    
    @IBAction func BtnLeaderboardPressed(_ sender: Any) {
        btnLeaderboardView.image = UIImage(named: "btnLeaderboardClicked")
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.btnLeaderboardView.image = UIImage(named: "btnLeaderboard")
        }
    }
    @IBAction func BtnLeaderboardReleased(_ sender: Any) {
        btnLeaderboardView.image = UIImage(named: "btnLeaderboard")
    }
    @IBAction func BtnPunchPressed(_ sender: Any) {
        scene.PunchPressed()
    }
    @IBAction func BtnFootPressed(_ sender: Any) {
        scene.KickPressed()
    }
    @IBAction func BtnUpPressed(_ sender: Any) {
        scene.UpPressed()
    }
    @IBAction func BtnDownPressed(_ sender: Any) {
        scene.DownPressed()
        audioPlayer.playSound(sound: .walkingDown)
    }
    @IBAction func BtnDownRealesed(_ sender: Any) {
        scene.DownPressed()
        audioPlayer.stopSound()
    }
    
    @IBAction func BtnSoundPressed(_ sender: Any) {
        if soundOn {
            audioPlayer.stopBgSound()
            audioPlayer.stopSound()
            btnSoundView.image = UIImage(named:"soundOff")
        }
        else {
            audioPlayer.playBackgroundSound(sound: .backgroundSoundLoop)
            btnSoundView.image = UIImage(named:"soundOn")
        }
        soundOn = !soundOn
    }
    
    func verifySoundSettings() {
        if soundOn {
            btnSoundView.image = UIImage(named:"soundOn")
        }
        else {
            btnSoundView.image = UIImage(named:"soundOff")
        }
    }
    
    func setButton(button: ScreenButtons, status: TapStatus){
        switch button {
        case .up:
            btnUpView.image = UIImage(named: status == .tap ? "btnUpTap" : "btnUp")
        case .down:
            btnDownView.image = UIImage(named: status == .tap ? "btnDownTap" : "btnDown")
        case .punch:
            btnPunchView.image = UIImage(named: status == .tap ? "btnPunchTap" : "btnPunch")
        case .kick:
            btnKickView.image = UIImage(named: status == .tap ? "btnKickTap" : "btnKick")
        }
    }
    
    func showIntroView () {
        introView.alpha = 1
    }
    
    func hideIntroView () {
        introView.alpha = 0
    }
    
    func showEndView () {
        endView.alpha = 1
    }
    
    func hideEndView () {
        endView.alpha = 0
    }
    
    func showGameSettings() {
        leftBtnsView.alpha = 1
        rightBtnsView.alpha = 1
        scoreView.alpha = 1
    }
    
    func hideGameSettings() {
        leftBtnsView.alpha = 0
        rightBtnsView.alpha = 0
        scoreView.alpha = 0
    }
    
    func setScore(deltaTime: TimeInterval) {
        self.score += GameManager.scoreMultiplier * deltaTime
        updateScoreLabel()
    }
    
    func resetScore() {
        self.score  = 0
        updateScoreLabel()
    }
    
    func updateScoreLabel() {
        let bestScore = userData.getBestScore()
        let scoreText = "SCORE: \(String(format: "%.0f", self.score)) | BEST SCORE: \(bestScore)"
        scoreLabel.text = scoreText
    }
    
}


enum ScreenButtons {
    case up
    case down
    case punch
    case kick
}

enum TapStatus {
    case tap
    case untap
}
