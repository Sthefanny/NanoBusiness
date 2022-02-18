//
//  SettingsViewController.swift
//  cyberunner
//
//  Created by Ana C S Costa on 11/02/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var callbackClosure: (() -> Void)?
    var audioPlayer = AudioManager.instance
    let userData = UserData()
    
    @IBOutlet weak var backgroundSettings: UIView!
    
    @IBOutlet weak var buttonClose: NSLayoutConstraint!
    
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var sliderMusic: UISlider!
    @IBOutlet weak var sliderSound: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAudios()
        
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
    
    func setAudios() {
        sliderMusic.setValue(userData.getMusicVolume(), animated: false)
        sliderSound.setValue(userData.getSoundVolume(), animated: false)
        
        audioPlayer.changeMusicVolume(volume: sliderMusic.value)
        audioPlayer.changeSoundVolume(volume: sliderSound.value)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        callbackClosure?()
    }
    
    @IBAction func btnClosePressed(_ sender: Any) {
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func SliderMusicChanged(_ sender: Any) {
        audioPlayer.changeMusicVolume(volume: sliderMusic.value)
        userData.setMusicVolume(volume: sliderMusic.value)
    }
    
    @IBAction func SliderSoundChanged(_ sender: Any) {
        audioPlayer.changeSoundVolume(volume: sliderSound.value)
        userData.setSoundVolume(volume: sliderSound.value)
    }
    
}
