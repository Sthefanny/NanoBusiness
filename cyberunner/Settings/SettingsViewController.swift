//
//  SettingsViewController.swift
//  cyberunner
//
//  Created by Ana C S Costa on 11/02/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var callbackClosure: (() -> Void)?
    
    @IBOutlet weak var backgroundSettings: UIView!
    
    @IBOutlet weak var buttonClose: NSLayoutConstraint!
    
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundSettings.layer.cornerRadius = 24
        backgroundSettings.layer.borderWidth = 2
        backgroundSettings.layer.borderColor = UIColor(named: "appPurple")?.cgColor
        
        musicLabel.font = UIFont(name: "NicoMoji-Regular", size: 21)
        musicLabel.minimumScaleFactor = 0.01
        musicLabel.adjustsFontSizeToFitWidth = true
        
        soundLabel.font = UIFont(name: "NicoMoji-Regular", size: 21)
        soundLabel.minimumScaleFactor = 0.01
        soundLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        callbackClosure?()
    }
    
    @IBAction func btnClosePressed(_ sender: Any) {
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }
    
}
