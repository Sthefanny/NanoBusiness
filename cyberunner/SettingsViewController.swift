//
//  SettingsViewController.swift
//  cyberunner
//
//  Created by Ana C S Costa on 11/02/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var sz = [1...21]
    
    
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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func btnClosePressed(_ sender: Any) {
        
    }
    
}
