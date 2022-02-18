//
//  AudioManager.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 06/02/22.
//

import AVKit

enum SoundOption: String {
    case backgroundSoundLoop
    case jump
    case power
    case punchRat
    case punchWall
    case rat
    case walkingDown
}

class AudioManager {
    var bgPlayer: AVAudioPlayer?
    var player: AVAudioPlayer?
    let userData = UserData()
    
    static let instance = AudioManager()
    
    func playBackgroundSound(sound: SoundOption) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        
        do {
            bgPlayer = try AVAudioPlayer(contentsOf: url)
            bgPlayer?.volume = userData.getMusicVolume()
            bgPlayer?.numberOfLoops = -1
            bgPlayer?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
        
    }
    
    func playSound(sound: SoundOption) {
        stopSound()
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            stopSound()
            player?.volume = userData.getSoundVolume()
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
        
    }
    
    func stopSound() {
        player?.stop()
    }
    
    func stopBgSound() {
        bgPlayer?.stop()
    }
    
    func changeMusicVolume(volume: Float) {
        bgPlayer?.volume = volume
    }
    
    func changeSoundVolume(volume: Float) {
        player?.volume = volume
    }
}
