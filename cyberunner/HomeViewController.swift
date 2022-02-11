//
//  HomeViewController.swift
//  cyberunner
//
//  Created by Ana C S Costa on 10/02/22.
//

import UIKit

class HomeViewController: UIViewController {
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func PlayPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "game")
        navigationController?.pushViewController(vc, animated: false)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
