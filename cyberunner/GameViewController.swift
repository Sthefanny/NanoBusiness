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
    @IBOutlet weak var btnPunch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        scene.FootPressed()
    }
    @IBAction func BtnUpPressed(_ sender: Any) {
        scene.UpPressed()
    }
    @IBAction func BtnDownPressed(_ sender: Any) {
        scene.DownPressed()
    }
    
    func setButton(button: ScreenButtons, status: TapStatus){
        switch button {
        case .up:
            btnUpView.image = UIImage(named: status == .tap ? "btnUpTap" : "btnUp")
        case .down:
            btnDownView.image = UIImage(named: status == .tap ? "btnDownTap" : "btnDown")
        default:
            break
        }
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
