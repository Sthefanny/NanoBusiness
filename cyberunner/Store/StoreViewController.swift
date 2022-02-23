//
//  StoreViewController.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 22/02/22.
//

import Foundation
import UIKit

class StoreViewController: UIViewController {
    let userData = UserData()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnZoey: UIButton!
    @IBOutlet weak var btnChris: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont(name: "NicoMoji-Regular", size: 21)
        titleLabel.minimumScaleFactor = 0.01
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func BtnZoeyPressed(_ sender: Any) {
        userData.setCharacter(char: .zoey)
        closeView()
    }
    
    @IBAction func BtnChrisPressed(_ sender: Any) {
        userData.setCharacter(char: .chris)
        closeView()
    }
    
    func closeView() {
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }
}
