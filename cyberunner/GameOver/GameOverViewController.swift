//
//  GameOverViewController.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 17/02/22.
//

import UIKit

class GameOverViewController: UIViewController {
    var gameViewController: GameViewController!
    private var buttonClicked: ButtonClicked?
    var callbackClosure: ((ButtonClicked) -> Void)?
    
    @IBOutlet weak var btnPlayAgain: UIButton!
    @IBOutlet weak var btnBackHome: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameViewController = GameViewController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        callbackClosure?(buttonClicked!)
    }
    
    @IBAction func PlayAgainPressed(_ sender: Any) {
        buttonClicked = .playAgain
        btnPlayAgain.setImage(UIImage(named: "btnPlayAgainClicked"), for: .normal)
    }
    
    @IBAction func PlayAgainReleased(_ sender: Any) {
        btnPlayAgain.setImage(UIImage(named: "btnPlayAgain"), for: .normal)
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BackHomePressed(_ sender: Any) {
        buttonClicked = .backHome
        btnBackHome.setImage(UIImage(named: "btnBackHomeClicked"), for: .normal)
    }
    
    @IBAction func BackHomeReleased(_ sender: Any) {
        btnBackHome.setImage(UIImage(named: "btnBackHome"), for: .normal)
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }
}

enum ButtonClicked {
    case playAgain
    case backHome
}
