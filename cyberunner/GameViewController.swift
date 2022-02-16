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
    var homeViewController: HomeViewController!
    
    var check = true
    
    var score = CGFloat(0.0)
    
    let userData = UserData()
    
    var soundOn = true
    
    var audioPlayer = AudioManager.instance
    
    @IBOutlet weak var btnUpView: UIImageView!
    @IBOutlet weak var btnUp: UIButton!
    @IBOutlet weak var btnDownView: UIImageView!
    @IBOutlet weak var btnDown: UIButton!
    @IBOutlet weak var btnKick: UIButton!
    @IBOutlet weak var btnKickView: UIImageView!
    @IBOutlet weak var btnPunch: UIButton!
    @IBOutlet weak var btnPunchView: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var btnPlayAgain: UIButton!
    @IBOutlet weak var btnPlayAgainView: UIImageView!
    @IBOutlet weak var leftBtnsView: UIView!
    @IBOutlet weak var rightBtnsView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var btnSoundView: UIImageView!
    @IBOutlet weak var btnSound: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            homeViewController = HomeViewController()
            
            scene.start()
            
//            view.showsFPS = true
//            view.showsNodeCount = true
        }
    }
    
    func showAd() {
        if homeViewController.interstitial != nil {
            homeViewController.interstitial!.present(fromRootViewController: self)
        } else {
            resetScene()
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        resetScene()
    }
    
    /// Tells the delegate that the ad presented full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        homeViewController.requestIntersticial()
        resetScene()
    }
    
    func resetScene() {
        scene.reset()
        scene.start()
    }
    
    func updateScore() {
        userData.saveBestScore(score: Int(score))
        updateScoreLabel()
    
        GameCenter.shared.updateScore(with: Int(score))
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
