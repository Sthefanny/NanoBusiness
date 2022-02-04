//
//  GameViewController.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 27/01/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideGameSettings()
        
//        scoreLabel.layer.cornerRadius = 16
//        scoreLabel.layer.borderWidth = 2
//        scoreLabel.layer.borderColor = UIColor(named: "appBlue")?.cgColor
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
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
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
    }
    @IBAction func BtnDownRealesed(_ sender: Any) {
        scene.DownPressed()
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
    
    func showGameSettings() {
        btnUpView.alpha = 1
        btnUp.alpha = 1
        btnDownView.alpha = 1
        btnDown.alpha = 1
        btnKick.alpha = 1
        btnKickView.alpha = 1
        btnPunch.alpha = 1
        btnPunchView.alpha = 1
        
        scoreLabel.alpha = 1
    }
    
    func hideGameSettings() {
        btnUpView.alpha = 0
        btnUp.alpha = 0
        btnDownView.alpha = 0
        btnDown.alpha = 0
        btnKick.alpha = 0
        btnKickView.alpha = 0
        btnPunch.alpha = 0
        btnPunchView.alpha = 0
        
        scoreLabel.alpha = 0
    }
    
    func setScore(score: Int) {
        scoreLabel.text
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
