//
//  HomeViewController.swift
//  cyberunner
//
//  Created by Ana C S Costa on 10/02/22.
//

import UIKit

class HomeViewController: UIViewController {
   
    @IBOutlet weak var btnPlayView: UIImageView!
    @IBOutlet weak var btnWinnerView: UIImageView!
    @IBOutlet weak var btnStoreView: UIImageView!
    
    
    @IBOutlet weak var ButtonSettings: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func PlayPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "game")
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "settings")
        navigationController?.pushViewController(vc, animated: false)
        
        ButtonSettings.backgroundColor = .white
           
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func buttonPlay(_ sender: Any) {
//        setButtonHome(button: .play, status: .tap)
        
    }
    
    @IBAction func buttonStore(_ sender: Any) {
//        setButtonHome(button: .store, status: .tap)
    }
    
    @IBAction func buttonWinner(_ sender: Any) {
//        setButtonHome(button: .winner, status: .tap)
    }
    
    func setButtonHome(button: ScreenButtonsHome, status: TapStatus){
        switch button {
        case .play: btnPlayView.image = UIImage(named: status == .tap ? "btnPlayTap" : "btnPlay")
            
        case .store: btnStoreView.image = UIImage(named: status == .tap ? "btnStoreTap" : "btnStore")
            
        case .winner: btnWinnerView.image = UIImage(named: status == .tap ? "btnWinnerTap" : "btnWinner")

        }
    }

}


enum ScreenButtonsHome {
    case play
    case store
    case winner
}
