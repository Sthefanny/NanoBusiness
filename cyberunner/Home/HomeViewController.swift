//
//  HomeViewController.swift
//  cyberunner
//
//  Created by Ana C S Costa on 10/02/22.
//

import UIKit
import GameplayKit
import GameKit
import GoogleMobileAds

class HomeViewController: UIViewController, GKGameCenterControllerDelegate, GADFullScreenContentDelegate {
    
    var audioPlayer = AudioManager.instance
    
    let userData = UserData()
    
    var soundOn = true
    
    @IBOutlet weak var btnPlayView: UIImageView!
    @IBOutlet weak var btnWinnerView: UIImageView!
    @IBOutlet weak var btnStoreView: UIImageView!
    @IBOutlet weak var btnSettings: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        GameCenter.shared.authenticateLocalPlayer(presentingVC: self)
        GameCenter.shared.gcVC.gameCenterDelegate = self
        
        audioPlayer.playBackgroundSound(sound: .backgroundSoundLoop)
        userData.setCharacter(char: .pam)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "settings")
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func storePressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "store")
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func buttonPlayPressed(_ sender: Any) {
        btnPlayView.image = UIImage(named: "btnPlayTap")
    }
    
    @IBAction func buttonPlayReleased(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "game")
        navigationController?.pushViewController(vc, animated: false)
        
        self.btnPlayView.image = UIImage(named: "btnPlay")
    }
    
    @IBAction func buttonStorePressed(_ sender: Any) {
        btnStoreView.image = UIImage(named: "btnStoreTap")
    }
    
    @IBAction func buttonStoreReleased(_ sender: Any) {
        btnStoreView.image = UIImage(named: "btnStore")
    }
    
    @IBAction func buttonWinnerPressed(_ sender: Any) {
        btnWinnerView.image = UIImage(named: "btnWinnerTap")
    }
    
    @IBAction func buttonWinnerReleased(_ sender: Any) {
        btnWinnerView.image = UIImage(named: "btnWinner")
        showLeaderboard()
    }
    
    func showLeaderboard() {
        let gcVC = GKGameCenterViewController(leaderboardID: GameManager.leaderboardID, playerScope: .friendsOnly, timeScope: .today)
        gcVC.gameCenterDelegate = self
        present(gcVC, animated: true, completion: nil)
    }
    
}


enum ScreenButtonsHome {
    case play
    case store
    case winner
}
