//
//  UserData.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 05/02/22.
//

import Foundation

class UserData {
    let bestScore = "bestScore"
    let musicVolume = "musicVolume"
    let soundVolume = "soundVolume"
    let character = "character"
    let coin = "coin"
    
    let defaults = UserDefaults.standard
    
    init() {
        defaults.register(
            defaults: [
                "bestScore": 0,
                "musicVolume": 0.6,
                "soundVolume": 1.0,
                "character": CharacterEnum.pam.rawValue,
                "coin" : 0,
            ]
        )
    }
    
    
    func saveBestScore(score: Int) {
        let lastBest = getBestScore()
        
        if score > lastBest {
            defaults.set(score, forKey: bestScore)
        }
    }
    
    func getBestScore() -> Int {
        return defaults.integer(forKey: bestScore)
    }
    
    func setMusicVolume(volume: Float) {
        defaults.set(volume, forKey: musicVolume)
    }
    
    func getMusicVolume() -> Float {
        return defaults.float(forKey: musicVolume)
    }
    
    func setSoundVolume(volume: Float) {
        defaults.set(volume, forKey: soundVolume)
    }
    
    func getSoundVolume() -> Float {
        return defaults.float(forKey: soundVolume)
    }
    
    func setCharacter(char: CharacterEnum) {
        defaults.set(char.rawValue, forKey: character)
    }
    
    func getCharacter() -> String? {
        return defaults.string(forKey: character)
    }
    
    func setCoin(value: Int) {
        defaults.set(value, forKey: coin)
    }
    
    func getCoin() -> Int {
        return defaults.integer(forKey: coin)
    }
}
