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
    var interstitial: GADInterstitialAd?
    
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
        
        requestIntersticial()
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
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "settings")
        navigationController?.pushViewController(vc, animated: false)
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
        showLeaderboard()
        btnWinnerView.image = UIImage(named: "btnWinnerTap")
    }
    
    @IBAction func buttonWinnerReleased(_ sender: Any) {
        btnWinnerView.image = UIImage(named: "btnWinner")
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
